#import "N3AddressBook.h"
#import "N3Person.h"
#import "N3Pinyin.h"







@implementation N3AddressBook

    ABAddressBookRef _addressBookRef;
    NSThread *_addressBookThread; //在同一线程操作, ABAddressBook不是线程安全的


@synthesize addressBookThread=_addressBookThread;

-(id)init{
    self = [super init];
    if (self){
   
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        if (ABAddressBookCreateWithOptions != NULL){
             __block CFErrorRef errorRef = NULL;
            
                _addressBookRef = ABAddressBookCreateWithOptions(nil, &errorRef);
            
            if (!_addressBookRef){
                N3ErrorLog(@"Error: 通过 ABAddressBookCreateWithOptions() 创建 N3AddressBook 失败 error: %@", errorRef);
                if (errorRef) CFRelease(errorRef);
                arc_release_nil(self);
                return nil;
            }
            
         } else {
#endif //end iOS6+
             
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 _addressBookRef = ABAddressBookCreate();
#pragma clang diagnostic pop
             
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
         }
#endif //end iOS6+
        
    }
    return self;
}

+(N3AuthorizationStatus)authorizationStatus{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    if (ABAddressBookGetAuthorizationStatus != NULL){
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined: return N3AuthorizationStatusNotDetermined;
            case kABAuthorizationStatusRestricted: return N3AuthorizationStatusRestricted;
            case kABAuthorizationStatusDenied: return N3AuthorizationStatusDenied;
            case kABAuthorizationStatusAuthorized: return N3AuthorizationStatusAuthorized;
        }
    }
#endif //end iOS6+
    
    return N3AuthorizationStatusAuthorized;
}


-(void)requestAuthorizationWithCompletion:(void (^)(bool granted, NSError* error))completion{
    completion = (__bridge id)Block_copy((__bridge void *)completion);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    
     if (ABAddressBookRequestAccessWithCompletion != NULL){
         
         [self performAddressBookAction:^(ABAddressBookRef addressBookRef) {
             ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                 completion(granted, (__bridge NSError*)error);
                 if (error) CFRelease(error);
                 Block_release((__bridge void *)completion);
             });
    
         } waitUntilDone:YES];
             
        return;    
         
     }
    
#endif //end iOS6+
    
    //else, run the completion block async (access is always allowed pre iOS6)
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(YES, nil);
        Block_release((__bridge void *)completion);
    });
    
}

#pragma mark - threads

-(void)performAddressBookAction:(void (^)(ABAddressBookRef addressBookRef))actionBlock waitUntilDone:(BOOL)wait{
    if (_addressBookRef) CFRetain(_addressBookRef);
    actionBlock(_addressBookRef);
    if (_addressBookRef) CFRelease(_addressBookRef);
}


#pragma mark - access - people

-(NSArray*)people{
    __block NSArray *result = nil;
    CFArrayRef peopleRefs = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    if (peopleRefs){
        result = arc_retain([self peopleForABRecordRefs:peopleRefs]);
        CFRelease(peopleRefs);
    }
    return arc_autorelease(result);
}


-(long)numberOfPeople{
    __block long result = 0;
    result = ABAddressBookGetPersonCount(_addressBookRef);
    return result;
}

-(NSArray*)peopleOrderedBySortOrdering:(ABPersonSortOrdering)ordering{
    __block NSArray *result = nil;
    CFArrayRef peopleRefs = ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    if (peopleRefs){
        CFMutableArrayRef mutablePeopleRefs = CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(peopleRefs), peopleRefs);
        if (mutablePeopleRefs){
            
            //sort
            CFArraySortValues(mutablePeopleRefs, CFRangeMake(0, CFArrayGetCount(mutablePeopleRefs)), (CFComparatorFunction) ABPersonComparePeopleByName, (void*) ordering);
            result = arc_retain([self peopleForABRecordRefs:mutablePeopleRefs]);
            CFRelease(mutablePeopleRefs);
            
        }
        
        CFRelease(peopleRefs);
        
    }
    return arc_autorelease(result);
}

-(NSArray*)peopleOrderedByUsersPreference{
    return [self peopleOrderedBySortOrdering:[N3AddressBook sortOrdering]];
}
-(NSArray*)peopleOrderedByFirstName{
    return [self peopleOrderedBySortOrdering:kABPersonSortByFirstName];
}
-(NSArray*)peopleOrderedByLastName{
    return [self peopleOrderedBySortOrdering:kABPersonSortByLastName];
}



-(NSArray*)peopleWithName:(NSString*)name{
    NSArray *result = nil;
    CFArrayRef peopleRefs = ABAddressBookCopyPeopleWithName(_addressBookRef, (__bridge CFStringRef)name);
    if (peopleRefs) {
        result = arc_retain([self peopleForABRecordRefs:peopleRefs]);
        CFRelease(peopleRefs);
    }
    return arc_autorelease(result);
}

-(N3Person*)personForABRecordRef:(ABRecordRef)personRef{
    
    if (personRef == NULL) return nil; //bail
    
    N3Person *person = nil;
    //if exact matching failed, look using recordID;
    ABRecordID personID = kABRecordInvalidID;
    personID = ABRecordGetRecordID(personRef);
    //is valid ?
    if (personID == kABRecordInvalidID) return nil; //invalid, (no further lookup possible, return nil)
    personRef = ABAddressBookGetPersonWithRecordID(_addressBookRef, personID);
    
    if (personRef){
        person = [[N3Person alloc] initWithAddressBook:self recordRef:personRef];
    }
    return arc_autorelease(person);
}

-(NSArray*)peopleForABRecordRefs:(CFArrayRef)peopleRefs{
    if (!peopleRefs) return nil;
    
    NSMutableArray *people = [NSMutableArray array];
    for (CFIndex i = 0; i < CFArrayGetCount(peopleRefs); i++) {
        ABRecordRef personRef = CFArrayGetValueAtIndex(peopleRefs, i);
            
        N3Person *person = [self personForABRecordRef:personRef];
        if (person) [people addObject:person];
    }
    return [NSArray arrayWithArray:people];
}

-(N3Person*)personForABRecordID:(ABRecordID)personID{
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(_addressBookRef, personID);
    return [self personForABRecordRef:recordRef];
}

-(NSDictionary*)personForWeb:(ABRecordID)personID{
    N3Person *person = [self personForABRecordID:personID];
    if (!person) return nil;
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    N3MultiStringValue *phones = person.phoneNumbers;
    
    NSMutableArray *allPhones = arc_autorelease([[NSMutableArray alloc] init]);
    for (int i=0; i < [[phones values] count]; i++) {
    
        [allPhones addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              [phones labelAtIndex:i],@"type",
                              [phones valueAtIndex:i ],@"no",
                              @"",@"rowId",nil]];
    }
    
    [result setObject:[NSNumber numberWithInteger:personID] forKey:@"contactId"];
    [result setObject:person.name?:@"" forKey:@"displayName"];
    [result setObject:person.firstName?:@"" forKey:@"firstName"];
    [result setObject:person.lastName?:@"" forKey:@"lastName"];
    [result setObject:allPhones forKey:@"phones"];
    
    return arc_autorelease(result);
}



-(BOOL)isBlank:(NSString *)str{
    return str == nil ||
    str == NULL ||
    [str isKindOfClass:[NSNull class]] ||
    [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


- (NSString *)fisrtLetter:(NSString*)str{
    if ([self isBlank:str]) return @"#";
    NSString *cleanString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    char *fistPinyin = charWithPinyinFirstLetter([cleanString characterAtIndex:0]);
    return [[NSString stringWithFormat:@"%c",fistPinyin] uppercaseString];
}

- (NSDictionary *)peopleForWeb {
    NSMutableArray *contacts = arc_autorelease([[NSMutableArray alloc] init]);
    NSArray *people = [self peopleOrderedByLastName];
    for (N3Person *person in people) {
        NSString *firstLetter = [self fisrtLetter:person.name]?:@"";
        NSDictionary *contactDisplay = [NSDictionary dictionaryWithObjectsAndKeys: person.name, @"displayName",
                                        [NSString stringWithFormat:@"%d",person.recordID], @"contactId", nil];
        
        NSDictionary *last = (NSDictionary *)[contacts lastObject];
        NSMutableArray *contactDisplays = nil;
        if (last && [firstLetter isEqualToString:(NSString *)[last objectForKey:@"key"]] ){
            contactDisplays = [last objectForKey:@"values"];
            [contactDisplays addObject:contactDisplay];
        }
        else{
            contactDisplays  = [[NSMutableArray alloc] init];
            [contactDisplays addObject:contactDisplay];
            [contacts addObject:[NSDictionary dictionaryWithObjectsAndKeys:firstLetter,@"key",contactDisplays,@"values", nil] ];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:contacts,@"contacts", nil];
}





#pragma mark - prefs
+(ABPersonSortOrdering)sortOrdering{
    return ABPersonGetSortOrdering();
}
+(BOOL)orderByFirstName{
    return [N3AddressBook sortOrdering] == kABPersonSortByFirstName;
}
+(BOOL)orderByLastName{
    return [N3AddressBook sortOrdering] == kABPersonSortByLastName;
}

-(void)dealloc{
}


@end

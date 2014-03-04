//
//  N3Persion.m
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import "N3Person.h"
#import "N3AddressBook.h"

@implementation N3Person




#pragma mark - personal properties

-(NSString*)name{
    return [self.compositeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// kABPersonFirstNameProperty
-(NSString*)firstName{
    return [self getBasicValueForPropertyID:kABPersonFirstNameProperty];
}
-(void)setFirstName:(NSString*)firstName{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)firstName forPropertyID:kABPersonFirstNameProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}

// kABPersonLastNameProperty
-(NSString*)lastName{
    return [self getBasicValueForPropertyID:kABPersonLastNameProperty];
}
-(void)setLastName:(NSString*)lastName{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)lastName forPropertyID:kABPersonLastNameProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonMiddleNameProperty
-(NSString*)middleName{
    return [self getBasicValueForPropertyID:kABPersonMiddleNameProperty];
}
-(void)setMiddleName:(NSString*)middleName{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)middleName forPropertyID:kABPersonMiddleNameProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonPrefixProperty
-(NSString*)prefix{
    return [self getBasicValueForPropertyID:kABPersonPrefixProperty];
}
-(void)setPrefix:(NSString*)prefix{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)prefix forPropertyID:kABPersonPrefixProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonSuffixProperty
-(NSString*)suffix{
    return [self getBasicValueForPropertyID:kABPersonSuffixProperty];
}
-(void)setSuffix:(NSString*)suffix{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)suffix forPropertyID:kABPersonSuffixProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonNicknameProperty
-(NSString*)nickname{
    return [self getBasicValueForPropertyID:kABPersonNicknameProperty];
}
-(void)setNickname:(NSString*)nickname{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)nickname forPropertyID:kABPersonNicknameProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonFirstNamePhoneticProperty
-(NSString*)firstNamePhonetic{
    return [self getBasicValueForPropertyID:kABPersonFirstNamePhoneticProperty];
}
-(void)setFirstNamePhonetic:(NSString*)firstNamePhonetic{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)firstNamePhonetic forPropertyID:kABPersonFirstNamePhoneticProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonLastNamePhoneticProperty
-(NSString*)lastNamePhonetic{
    return [self getBasicValueForPropertyID:kABPersonLastNamePhoneticProperty];
}
-(void)setLastNamePhonetic:(NSString*)lastNamePhonetic{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)lastNamePhonetic forPropertyID:kABPersonLastNamePhoneticProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonMiddleNamePhoneticProperty
-(NSString*)middleNamePhonetic{
    return [self getBasicValueForPropertyID:kABPersonMiddleNamePhoneticProperty];
}
-(void)setMiddleNamePhonetic:(NSString*)middleNamePhonetic{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)middleNamePhonetic forPropertyID:kABPersonMiddleNamePhoneticProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonOrganizationProperty
-(NSString*)organization{
    return [self getBasicValueForPropertyID:kABPersonOrganizationProperty];
}
-(void)setOrganization:(NSString*)organization{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)organization forPropertyID:kABPersonOrganizationProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonJobTitleProperty
-(NSString*)jobTitle{
    return [self getBasicValueForPropertyID:kABPersonJobTitleProperty];
}
-(void)setJobTitle:(NSString*)jobTitle{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)jobTitle forPropertyID:kABPersonJobTitleProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonDepartmentProperty
-(NSString*)department{
    return [self getBasicValueForPropertyID:kABPersonDepartmentProperty];
}
-(void)setDepartment:(NSString*)department{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)department forPropertyID:kABPersonDepartmentProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonEmailProperty - (Multi String)
-(N3MultiStringValue*)emails{
    return [self getMultiValueForPropertyID:kABPersonEmailProperty];
}
-(void)setEmails:(N3MultiStringValue*)emails{
    NSError *error = nil;
    if (![self setMultiValue:emails forPropertyID:kABPersonEmailProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonBirthdayProperty
-(NSDate*)birthday{
    return [self getBasicValueForPropertyID:kABPersonBirthdayProperty];
}
-(void)setBirthday:(NSDate*)birthday{
    NSError *error = nil;
    if (![self setBasicValue:(CFDateRef)birthday forPropertyID:kABPersonBirthdayProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonNoteProperty
-(NSString*)note{
    return [self getBasicValueForPropertyID:kABPersonNoteProperty];
}
-(void)setNote:(NSString*)note{
    NSError *error = nil;
    if (![self setBasicValue:(CFStringRef)note forPropertyID:kABPersonNoteProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


// kABPersonCreationDateProperty (read only)
-(NSDate*)created{
    return [self getBasicValueForPropertyID:kABPersonCreationDateProperty];
}


// kABPersonModificationDateProperty (read only)
-(NSDate*)modified{
    return [self getBasicValueForPropertyID:kABPersonModificationDateProperty];
}


#pragma mark - Addresses
// kABPersonAddressProperty (multi dictionary)
-(N3MultiDictionaryValue*)addresses{
    return [self getMultiValueForPropertyID:kABPersonAddressProperty];
}
-(void)setAddresses:(N3MultiDictionaryValue*)addresses{
    NSError *error = nil;
    if (![self setMultiValue:addresses forPropertyID:kABPersonAddressProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


#pragma mark - Dates
// kABPersonDateProperty (multi date)
-(N3MultiDateTimeValue*)dates{
    return [self getMultiValueForPropertyID:kABPersonDateProperty];
}
-(void)setDates:(N3MultiDateTimeValue*)dates{
    NSError *error = nil;
    if (![self setMultiValue:dates forPropertyID:kABPersonDateProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}


#pragma mark - Kind
// kABPersonKindProperty
-(NSNumber*)kind{
    return [self getBasicValueForPropertyID:kABPersonKindProperty];
}
-(void)setKind:(NSNumber*)kind{
    NSError *error = nil;
    if (![self setBasicValue:(CFNumberRef)kind forPropertyID:kABPersonKindProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}

// if person == kABPersonKindOrganization
-(BOOL)isOrganization{ return ([[self kind] isEqualToNumber:(NSNumber*)kABPersonKindOrganization]); }

// if person == kABPersonKindPerson
-(BOOL)isPerson{ return ([[self kind] isEqualToNumber:(NSNumber*)kABPersonKindPerson]); }

#pragma mark - Phone numbers
// kABPersonPhoneProperty (Multi String)
-(N3MultiStringValue*)phoneNumbers{
    return [self getMultiValueForPropertyID:kABPersonPhoneProperty];
}
-(void)setPhoneNumbers:(N3MultiStringValue*)phoneNumbers{
    NSError *error = nil;
    if (![self setMultiValue:phoneNumbers forPropertyID:kABPersonPhoneProperty error:&error]){
        N3ErrorLog(@"-[N3Person %@] error:%@", NSStringFromSelector(_cmd), error);
    }
}

#pragma mark - generic getter/setter/remover
-(id)getBasicValueForPropertyID:(ABPropertyID)propertyID{
    if (!_recordRef) return nil; //no record ref
    if (propertyID == kABPropertyInvalidID) return nil; //invalid
    
    __block CFTypeRef value = NULL;
    
    [self performRecordAction:^(ABRecordRef recordRef) {
        value = ABRecordCopyValue(recordRef, propertyID);
    } waitUntilDone:YES];
    
    id result = [(__bridge id)value copy];
    if (value) CFRelease(value);
    
    return arc_autorelease(result);
}

-(BOOL)setBasicValue:(CFTypeRef)value forPropertyID:(ABPropertyID)propertyID error:(NSError**)error{
    if (!_recordRef) return false; //no record ref
    if (propertyID == kABPropertyInvalidID) return false; //invalid
    if (value == NULL) return [self unsetBasicValueForPropertyID:propertyID error:error]; //allow NULL to unset the property
    
    __block CFErrorRef cfError = NULL;
    __block BOOL result;
    [self performRecordAction:^(ABRecordRef recordRef) {
        result = ABRecordSetValue(recordRef, propertyID, value, &cfError);
    } waitUntilDone:YES];
    
    if (!result){
        if (error && cfError) *error = (NSError*)ARCBridgingRelease(CFRetain(cfError));
        if (cfError) CFRelease(cfError);
    }
    return result;
}


#pragma mark - generic multi value getter/setter/remover

-(N3MultiValue*)getMultiValueForPropertyID:(ABPropertyID)propertyID{
    if (!_recordRef) return nil; //no record ref
    if (propertyID == kABPropertyInvalidID) return nil; //invalid
    
    __block ABMultiValueRef valueRef = NULL;
    
    [self performRecordAction:^(ABRecordRef recordRef) {
        valueRef = ABRecordCopyValue(recordRef, propertyID);
    } waitUntilDone:YES];
    
    N3MultiValue *multiValue = nil;
    if (valueRef){
        multiValue = [[N3MultiValue alloc] initWithMultiValueRef:valueRef];
        CFRelease(valueRef);
    }
    return arc_autorelease(multiValue);
}

-(BOOL)setMultiValue:(N3MultiValue*)multiValue forPropertyID:(ABPropertyID)propertyID error:(NSError**)error{
    if (multiValue == NULL) return [self unsetMultiValueForPropertyID:propertyID error:error]; //allow NULL to unset the property
    return [self setBasicValue:multiValue.multiValueRef forPropertyID:propertyID error:error];
}

-(BOOL)unsetMultiValueForPropertyID:(ABPropertyID)propertyID error:(NSError**)error{
    //this should just be able to be forwarded
    return [self unsetBasicValueForPropertyID:propertyID error:error];
}

#pragma mark - localized property and labels (class methods)
+(NSString*)localizedPropertyName:(ABPropertyID)propertyID{
    CFStringRef nameRef = ABPersonCopyLocalizedPropertyName(propertyID);
    NSString *name = nil;
    if (nameRef){
        name = [NSString stringWithString:(__bridge NSString*)nameRef];
        CFRelease(nameRef);
    }
    return name;
}

+(NSString*)localizedLabel:(NSString*)label{
    CFStringRef localizedRef = ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label);
    NSString *localized = nil;
    if (localizedRef){
        localized = [NSString stringWithString:(__bridge NSString*)localizedRef];
        CFRelease(localizedRef);
    }
    return localized;
}

@end

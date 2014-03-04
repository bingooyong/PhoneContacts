#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@class N3Record;
@class N3Person;


#ifndef N3_AB_ENABLE_DEBUG_LOGGING
#define N3_AB_ENABLE_DEBUG_LOGGING  ( defined(DEBUG) || FALSE )
#endif

typedef enum N3AuthorizationStatus {
    N3AuthorizationStatusNotDetermined = 0,
    N3AuthorizationStatusRestricted,
    N3AuthorizationStatusDenied,
    N3AuthorizationStatusAuthorized
} N3AuthorizationStatus;

@interface N3AddressBook : NSObject


+(N3AuthorizationStatus)authorizationStatus; // iOS6+ 以前固定返回 N3AuthorizationStatusAuthorized
-(void)requestAuthorizationWithCompletion:(void (^)(bool granted, NSError* error))completion;




//any access to the underlying ABAddressBook should be done inside this block wrapper below.
//from the addressbook programming guide... Important: Instances of ABAddressBookRef cannot be used by multiple threads. Each thread must make its own instance by calling ABAddressBookCreate.
-(void)performAddressBookAction:(void (^)(ABAddressBookRef addressBookRef))actionBlock waitUntilDone:(BOOL)wait;



@property (readonly, retain) NSThread *addressBookThread;

-(NSArray*)people;
-(long)numberOfPeople;
-(NSDictionary *)peopleForWeb;
-(NSArray*)peopleOrderedBySortOrdering:(ABPersonSortOrdering)ordering;
-(NSArray*)peopleOrderedByUsersPreference; //preferred
-(NSArray*)peopleOrderedByFirstName;
-(NSArray*)peopleOrderedByLastName;

-(NSArray*)peopleWithName:(NSString*)name;
-(N3Person*)personForABRecordRef:(ABRecordRef)personRef; //returns nil if ref not found in the current ab, eg unsaved record from another ab. if the passed recordRef does not belong to the current addressbook, the returned person objects underlying personRef will differ from the passed in value. This is required in-order to maintain thread safety for the underlying AddressBook instance.
-(N3Person*)personForABRecordID:(ABRecordID)personID; //returns nil if not found in the current ab, eg unsaved record from another ab.
-(NSDictionary*)personForWeb:(ABRecordID)personID;

//user prefs
+(ABPersonSortOrdering)sortOrdering;
+(BOOL)orderByFirstName; // YES if first name ordering is preferred
+(BOOL)orderByLastName;  // YES if last name ordering is preferred

@end



#if N3_AB_ENABLE_DEBUG_LOGGING
#define N3Log(format, ...) NSLog( @"%s:%i %@ ", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat: format, ##__VA_ARGS__])
#else
#define N3Log(format, ...)
#endif

#define N3ErrorLog(format, ...) NSLog( @"%s:%i %@ ", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat: format, ##__VA_ARGS__])
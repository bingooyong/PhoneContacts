//
//  N3Persion.h
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#import "N3Record.h"
#import "N3MultiValue.h"





@interface N3Person : N3Record

//personal properties
@property (readonly) NSString *name;                        // alias for compositeName
@property (nonatomic, copy) NSString *firstName;            // kABPersonFirstNameProperty
@property (nonatomic, copy) NSString *lastName;             // kABPersonLastNameProperty
@property (nonatomic, copy) NSString *middleName;           // kABPersonMiddleNameProperty
@property (nonatomic, copy) NSString *prefix;               // kABPersonPrefixProperty
@property (nonatomic, copy) NSString *suffix;               // kABPersonSuffixProperty
@property (nonatomic, copy) NSString *nickname;             // kABPersonNicknameProperty

@property (nonatomic, copy) NSString *firstNamePhonetic;    // kABPersonFirstNamePhoneticProperty
@property (nonatomic, copy) NSString *lastNamePhonetic;     // kABPersonLastNamePhoneticProperty
@property (nonatomic, copy) NSString *middleNamePhonetic;   // kABPersonMiddleNamePhoneticProperty

@property (nonatomic, copy) NSString *organization;         // kABPersonOrganizationProperty
@property (nonatomic, copy) NSString *jobTitle;             // kABPersonJobTitleProperty
@property (nonatomic, copy) NSString *department;           // kABPersonDepartmentProperty

//@property (nonatomic, copy) RHMultiStringValue *emails;     // kABPersonEmailProperty - (Multi String)
@property (nonatomic, copy) NSDate *birthday;               // kABPersonBirthdayProperty
@property (nonatomic, copy) NSString *note;                 // kABPersonNoteProperty


@property (nonatomic, readonly) NSDate *created;            // kABPersonCreationDateProperty
@property (nonatomic, readonly) NSDate *modified;           // kABPersonModificationDateProperty


//Phone numbers
@property (nonatomic, copy) N3MultiStringValue *phoneNumbers;     // kABPersonPhoneProperty (Multi String) possible labels are ( kABPersonPhoneMobileLabel, kABPersonPhoneIPhoneLabel, kABPersonPhoneMainLabel, kABPersonPhoneHomeFAXLabel, kABPersonPhoneWorkFAXLabel, kABPersonPhoneOtherFAXLabel, kABPersonPhonePagerLabel )



-(id)initWithAddressBook:(N3AddressBook*)addressBook recordRef:(ABRecordRef)recordRef;

//localised property and labels (class methods)
+(NSString*)localizedPropertyName:(ABPropertyID)propertyID; //properties eg:kABPersonFirstNameProperty (ABPersonCopyLocalizedPropertyName)
+(NSString*)localizedLabel:(NSString*)label; //labels eg: kABWorkLabel (ABAddressBookCopyLocalizedLabel)

@end

//
//  N3Record.h
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@class N3AddressBook;
@class N3MultiValue;

@interface N3Record : NSObject{
    ABRecordID _recordID;
    __strong N3AddressBook *_addressBook;
    ABRecordRef _recordRef;
}

@property (readonly, retain) N3AddressBook* addressBook;

@property (readonly) ABRecordID recordID;
@property (readonly) ABRecordRef recordRef;
@property (readonly) ABRecordType recordType;
@property (readonly) NSString *compositeName;

//thread safe access block
-(void)performRecordAction:(void (^)(ABRecordRef recordRef))actionBlock waitUntilDone:(BOOL)wait;


//generic property accessors (only safe for toll free bridged values)
-(id)getBasicValueForPropertyID:(ABPropertyID)propertyID;
-(BOOL)setBasicValue:(CFTypeRef)value forPropertyID:(ABPropertyID)propertyID error:(NSError**)error;
-(BOOL)unsetBasicValueForPropertyID:(ABPropertyID)propertyID error:(NSError**)error;


//multi value accessors
-(N3MultiValue*)getMultiValueForPropertyID:(ABPropertyID)propertyID; //returned multi's are always immutable, if you want to edit use -[N3MultiValue mutableCopy]
-(BOOL)setMultiValue:(N3MultiValue*)multiValue forPropertyID:(ABPropertyID)propertyID error:(NSError**)error;
-(BOOL)unsetMultiValueForPropertyID:(ABPropertyID)propertyID error:(NSError**)error;


@end

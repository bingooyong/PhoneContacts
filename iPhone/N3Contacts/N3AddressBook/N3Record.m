//
//  N3Record.m
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import "N3Record.h"
#import "N3MultiValue.h"
#import "N3AddressBook.h"

@implementation N3Record

-(id)initWithAddressBook:(N3AddressBook*)addressBook recordRef:(ABRecordRef)recordRef{
    
    self = [super init];
    if (self) {
        
        if (!recordRef){
            arc_release_nil(self);
            return nil;
        }
        
        _addressBook = arc_retain(addressBook);
        _recordRef = CFRetain(recordRef);
    }
    return self;
}


#pragma mark - properties

@synthesize addressBook=_addressBook;
@synthesize recordRef=_recordRef;


-(ABRecordID)recordID{
    
    __block ABRecordID recordID = kABPropertyInvalidID;
    
    [self performRecordAction:^(ABRecordRef recordRef) {
        recordID = ABRecordGetRecordID(recordRef);
    } waitUntilDone:YES];
    
    return recordID;
}

-(ABRecordType)recordType{
    
    __block ABRecordType recordType = -1;
    
    [self performRecordAction:^(ABRecordRef recordRef) {
        recordType = ABRecordGetRecordType(recordRef);
    } waitUntilDone:YES];
    
    return recordType;
}

-(NSString*)compositeName{
    __block CFStringRef compositeNameRef = NULL;
    
    [self performRecordAction:^(ABRecordRef recordRef) {
        compositeNameRef = ABRecordCopyCompositeName(recordRef);
    } waitUntilDone:YES];
    
    NSString* compositeName = [(__bridge NSString*)compositeNameRef copy];
    if (compositeNameRef) CFRelease(compositeNameRef);
    
    return arc_autorelease(compositeName);
}



#pragma mark - thread safe action block
-(void)performRecordAction:(void (^)(ABRecordRef recordRef))actionBlock waitUntilDone:(BOOL)wait{
    //if we have an address book perform it on that thread
    if (_addressBook){
        if (_recordRef) CFRetain(_recordRef);
        [_addressBook performAddressBookAction:^(ABAddressBookRef addressBookRef) {
            actionBlock(_recordRef);
            if (_recordRef) CFRelease(_recordRef);
        } waitUntilDone:wait];
    } else {
        //otherwise, a user created object... just use current thread.
        actionBlock(_recordRef);
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

-(BOOL)unsetBasicValueForPropertyID:(ABPropertyID)propertyID error:(NSError**)error{
    if (!_recordRef) return false; //no record ref
    if (propertyID == kABPropertyInvalidID) return false; //invalid
    
    __block CFErrorRef cfError = NULL;
    __block BOOL result;
    [self performRecordAction:^(ABRecordRef recordRef) {
        result = ABRecordRemoveValue(recordRef, propertyID, &cfError);
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

-(void)dealloc {
    arc_release_nil(_addressBook);
    if (_recordRef) CFRelease(_recordRef);
    _recordRef = NULL;
    arc_super_dealloc();
}

@end

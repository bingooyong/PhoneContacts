//
//  N3MultiValue.h
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class N3MultiValue;
@class N3MutableMultiValue;

//some clarifying typedefs. no need for separate subclasses.
typedef N3MultiValue N3MultiStringValue;
typedef N3MultiValue N3MultiIntegerValue;
typedef N3MultiValue N3MultiRealValue;
typedef N3MultiValue N3MultiDateTimeValue;
typedef N3MultiValue N3MultiDictionaryValue;

typedef N3MutableMultiValue N3MutableMultiStringValue;
typedef N3MutableMultiValue N3MutableMultiIntegerValue;
typedef N3MutableMultiValue N3MutableMultiRealValue;
typedef N3MutableMultiValue N3MutableMultiDateTimeValue;
typedef N3MutableMultiValue N3MutableMultiDictionaryValue;


typedef N3MultiValue N3MultiStringValue;

@interface N3MultiValue : NSObject{
    ABMultiValueRef _multiValueRef;
}

@property (readonly) ABMultiValueRef multiValueRef;

//init
-(id)initWithMultiValueRef:(ABMultiValueRef)multiValueRef; //passing NULL to init is invalid

//accessors
-(ABPropertyType)propertyType;

//values
-(NSUInteger)count;
-(id)valueAtIndex:(NSUInteger)index;
-(NSArray*)values;

//labels
-(NSString*)labelAtIndex:(NSUInteger)index;
-(NSString*)localizedLabelAtIndex:(NSUInteger)index;

@end


@interface N3MutableMultiValue : N3MultiValue

@end

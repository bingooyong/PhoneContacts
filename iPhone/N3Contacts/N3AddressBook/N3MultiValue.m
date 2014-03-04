//
//  N3MultiValue.m
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import "N3MultiValue.h"

#import "N3Person.h"
#import "N3Record.h"


@implementation N3MultiValue

@synthesize multiValueRef=_multiValueRef;

#pragma mark - init
-(id)initWithMultiValueRef:(ABMultiValueRef)multiValueRef{
    self = [super init];
    if (self){
        if (!multiValueRef){
            arc_release_nil(self);
            return nil;
        }
        
        _multiValueRef = CFRetain(multiValueRef);
    }
    return self;
}

-(void)dealloc{
    if (_multiValueRef) CFRelease(_multiValueRef);
    _multiValueRef = NULL;
    
    arc_super_dealloc();
}

#pragma mark - basic accessors

-(ABPropertyType)propertyType{
    return ABMultiValueGetPropertyType(_multiValueRef);
}

- (NSUInteger)count{
    return ABMultiValueGetCount(_multiValueRef);
}

//values
-(id)valueAtIndex:(NSUInteger)index{
    id value = (id)ARCBridgingRelease(ABMultiValueCopyValueAtIndex(_multiValueRef, index));
    return value;
}

-(NSArray*)values{
    NSArray* values = (NSArray*)ARCBridgingRelease(ABMultiValueCopyArrayOfAllValues(_multiValueRef));
    return values;
}

//labels
-(NSString*)labelAtIndex:(NSUInteger)index{
    NSString* label = (NSString*)ARCBridgingRelease(ABMultiValueCopyLabelAtIndex(_multiValueRef, index));
    return label;
}

-(NSString*)localizedLabelAtIndex:(NSUInteger)index{
    return [N3Person localizedLabel:[self labelAtIndex:index]];
}

@end

#import <Foundation/Foundation.h>

/*!
 * This is just a normalized object representation of a request sent to the native app from Javascript. It's really just
 * a way for us to pass this request information to our native code that is going to respond to the request.
 */
@interface N3NativeAction : NSObject {
    NSString *mAction;
    NSString *mMethod;
    NSDictionary *mParams;
}

@property(copy) NSString *action;
@property(copy) NSString *method;
@property(strong) NSDictionary *params;

- (id)initWithAction:(NSString *)action method:(NSString *)method params:(NSDictionary *)params;

+ (id)objectWithAction:(NSString *)action method:(NSString *)method params:(NSDictionary *)params;


@end
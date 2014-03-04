#import "N3NativeAction.h"


@implementation N3NativeAction
@synthesize method = mMethod;
@synthesize params = mParams;

- (id)initWithAction:(NSString *)action method:(NSString *)method params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.action = action;
        mMethod = method;
        mParams = params;
    }
    return self;
}

+ (id)objectWithAction:(NSString *)action method:(NSString *)method params:(NSDictionary *)params {
    return [[N3NativeAction alloc] initWithAction:action method:method params:params];
}

- (NSString *)action {
    return mAction;
}

- (void)setAction:(NSString *)action {
    if (mAction != action) {
        mAction = [action lowercaseString];
    }

}

@end
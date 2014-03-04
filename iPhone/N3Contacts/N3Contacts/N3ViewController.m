//
//  N3ViewController.m
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import "N3ViewController.h"

#import "N3AddressBookFrame.h"

@interface N3ViewController ()

@end

@implementation N3ViewController

@synthesize webView = mWebView;
@synthesize addressBook=_addressBook;

+ (void)initialize {
    [super initialize];
    
    // Create an instance of our custom NSURLCache object to use for
    // to check any outgoing requests in our app
    JavascriptBridgeURLCache *cache = [[JavascriptBridgeURLCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tell our custom NSURLCache object that we want this class to handle requests to native code. This method
    // is a category on NSURLCache that safely sets the delegate property (defined in JavascriptBridgeURLCache.h)
    [NSURLCache setJavascriptBridgeDelegate:self];
    
    // create our webview and add it to the view hierarchy
    mWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mWebView];
    
    NSURL *url =[NSURL URLWithString:@"http://www.thev5.com/lvyong/android/www/ListPage1.html"];
    
    // load our HTML and JS from a local file
    //    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"www/index" ofType:@"html"];
    //    NSURL *url = [NSURL fileURLWithPath:filePath];
    [mWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
    self.addressBook = [[[N3AddressBook alloc] init] autorelease];
    
    //if not yet authorized, force an auth.
    if ([N3AddressBook authorizationStatus] == N3AuthorizationStatusNotDetermined){
        [_addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            
        }];
    }
    
    //    NSArray *people = [_addressBook people];
    //
    //    long numberOfPeople = [_addressBook numberOfPeople];
    //
    //    NSLog(@"numberOfPeople:%d", numberOfPeople);
    //
    //
    //    for (N3Person *person in people) {
    //
    //        N3MultiStringValue *phones = person.phoneNumbers;
    //
    //        NSLog(@"phones:%@",phones.values);
    //
    //        NSLog(@"compositeName:%@",person.compositeName);
    //
    //    }
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    [NSURLCache setJavascriptBridgeDelegate:nil];
}



#pragma mark -
#pragma mark WebView Delegate
//============================================================================================================


/*!
 * This is the method that gets called when Javascript wants to tell our native app something. It is called from our
 * shared JavascriptBridgeURLCache object.
 *
 * \param N3NativeAction The request from Javascript
 * \param error A pointer to an error object that we can populate if we encounter a problem in handling this request
 * \return A dictionary that will be serialized into a JSON object and sent back to Javascript as the response
 */
- (NSDictionary *)handleAction:(N3NativeAction *)N3NativeAction error:(NSError **)error {
    // For this demo, we'll handle two types of requests. The first will simply show a native UIAlertView with params
    // passed from Javascript, and the second will go fetch the contacts from our address book and pass names and phone
    // numbers back to Javascript.
    
    // -------- GET /alert
    if ([N3NativeAction.action isEqualToString:@"alert"]) {
        //Typically, this request is sent to native code on the Web Thread, so if we want to do something that is
        // going to draw to the screen from native code, we need to run it on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[N3NativeAction.params objectForKey:@"title"] message:[N3NativeAction.params objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        });
        return nil;
    }
    
    // -------- GET /contacts
    else if ([N3NativeAction.action isEqualToString:@"contacts_lists"]) {
        __block NSDictionary *contactDisplay = nil;
        //if not yet authorized, force an auth.
        if ([N3AddressBook authorizationStatus] == N3AuthorizationStatusNotDetermined){
            [_addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
                contactDisplay =  [_addressBook peopleForWeb];
            }];
        }
        contactDisplay =  [_addressBook peopleForWeb];
        return contactDisplay;
    }
    
    // -------- GET /contacts
    else if ([N3NativeAction.action isEqualToString:@"contacts_detail"]) {
        NSString *recordid = (NSString*)[[N3NativeAction params] objectForKey:@"id"];
        __block NSDictionary *contactDisplay = nil;
        //if not yet authorized, force an auth.
        if ([N3AddressBook authorizationStatus] == N3AuthorizationStatusNotDetermined){
            [_addressBook requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
                contactDisplay =  [_addressBook personForWeb:(ABRecordID)[recordid intValue]];
            }];
        }
        contactDisplay =  [_addressBook personForWeb:(ABRecordID)[recordid intValue]];
        return contactDisplay;
        
    }
    
    return nil;
}


@end

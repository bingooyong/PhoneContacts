/*!
 * \file    WebViewController
 * \project
 * \author  Andy Rifken
 * \date    11/20/12.
 *
 * Copyright 2012 Andy Rifken
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "RootViewController.h"
#import "JavascriptBridgeURLCache.h"
#import "NativeAction.h"
#import "N3Pinyin.h"
#import <AddressBook/AddressBook.h>

@implementation RootViewController
@synthesize webView = mWebView;

+ (void)initialize {
    [super initialize];
    
    // Create an instance of our custom NSURLCache object to use for
    // to check any outgoing requests in our app
    JavascriptBridgeURLCache *cache = [[JavascriptBridgeURLCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
}


- (void)viewDidLoad {
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
}

- (void)dealloc {
    // This instance is going away, so unbind it from our custom NSURLCache
    [NSURLCache setJavascriptBridgeDelegate:nil];
}

#pragma mark -
#pragma mark WebView Delegate
//============================================================================================================



-(BOOL)isBlank:(NSString *)str{
    return str == nil ||
    str == NULL ||
    [str isKindOfClass:[NSNull class]] ||
    [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


- (NSString *)fisrtLetter:(NSString*)str{
    if ([self isBlank:str]) {
        return @"#";
    }
    
    NSString *cleanString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    char *fistPinyin = charWithPinyinFirstLetter([cleanString characterAtIndex:0]);
    return [[NSString stringWithFormat:@"%c",fistPinyin] uppercaseString];
}

- (NSDictionary *)persons:(ABAddressBookRef)addressBook {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    
    NSArray *allPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSUInteger peopleCounter = 0;

    
    NSMutableDictionary *namesAndNumbers = [[NSMutableDictionary alloc] init];
    for (peopleCounter = 0; peopleCounter < [allPeople count]; peopleCounter++)
    {
        ABRecordRef thisPerson =  (__bridge ABRecordRef) [allPeople objectAtIndex:peopleCounter];
        NSInteger recordID  =  ABRecordGetRecordID(thisPerson);
        NSString *firstName = (__bridge_transfer NSString *) ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *) ABRecordCopyValue(thisPerson, kABPersonLastNameProperty);
        NSString *fullName = [NSString stringWithFormat:@"%@%@",lastName ?: @"",  firstName ?: @""];
        NSString *firstLetter = [self fisrtLetter:fullName];
        
        NSDictionary *contactDisplay = [NSDictionary dictionaryWithObjectsAndKeys: fullName, @"displayName", [NSString stringWithFormat:@"%d",recordID], @"contactId", nil];
        NSMutableArray *contactDisplays =[namesAndNumbers objectForKey:firstLetter];
        
        if (!contactDisplays) {
            contactDisplays = [[NSMutableArray alloc] init];
            [namesAndNumbers setObject:contactDisplays forKey:firstLetter];
        }
         [contactDisplays addObject:contactDisplay];
        
    }
    

    for (NSString* key in namesAndNumbers) {
        NSMutableArray* value = [namesAndNumbers objectForKey:key];
        [contacts addObject:[NSDictionary dictionaryWithObjectsAndKeys:key,@"key",value,@"values", nil] ];
    }
    
    
    NSArray *sortedArray = [contacts sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(NSDictionary*)a objectForKey:@"key"];
        NSString *second = [(NSDictionary*)b objectForKey:@"key"];
        return [first compare:second];
    }];
    
    
    return @{
             @"contacts" : sortedArray
            };
}

- (NSDictionary *)persons:(ABAddressBookRef)addressBook recordid:(NSString *)recordid
{
    
    
    NSMutableDictionary *namesAndNumbers = [[NSMutableDictionary alloc] init];
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)[recordid intValue]);
    NSInteger recordID  =  ABRecordGetRecordID(person);
    NSString *firstName = (__bridge_transfer NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];

    for (int m = 0; m< ABMultiValueGetCount(phoneNumbers); m++)  {
        //获取电话Label类型
        NSString* personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneNumbers, m));
        //获取該Label下的电话值
        NSString* personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, m);
        if (personPhone != nil) {
            [phones addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                            personPhoneLabel,@"type",
                                            personPhone,@"no",
                                            @"",@"rowId",nil]];
        }
    }

    CFRelease(phoneNumbers);
    
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    for (int m = 0; m< ABMultiValueGetCount(emailsRef); m++)  {
        NSString* type = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emailsRef, m));
        NSString* value = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailsRef, m);
        if (value != nil) {
            [emails addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               type,@"type",
                               value,@"value",
                               @"",@"rowId",nil]];
        }
    }
    CFRelease(emailsRef);
    
    
    [namesAndNumbers setObject:[NSNumber numberWithInteger:recordID] forKey:@"contactId"];
    [namesAndNumbers setObject:firstName?:@"" forKey:@"firstName"];
    [namesAndNumbers setObject:lastName?:@"" forKey:@"lastName"];
    [namesAndNumbers setObject:phones forKey:@"phones"];
    [namesAndNumbers setObject:emails forKey:@"emails"];
    

    return namesAndNumbers;
}

/*!
 * This is the method that gets called when Javascript wants to tell our native app something. It is called from our
 * shared JavascriptBridgeURLCache object.
 *
 * \param nativeAction The request from Javascript
 * \param error A pointer to an error object that we can populate if we encounter a problem in handling this request
 * \return A dictionary that will be serialized into a JSON object and sent back to Javascript as the response
 */
- (NSDictionary *)handleAction:(NativeAction *)nativeAction error:(NSError **)error {
    // For this demo, we'll handle two types of requests. The first will simply show a native UIAlertView with params
    // passed from Javascript, and the second will go fetch the contacts from our address book and pass names and phone
    // numbers back to Javascript.
    
    // -------- GET /alert
    if ([nativeAction.action isEqualToString:@"alert"]) {
        //Typically, this request is sent to native code on the Web Thread, so if we want to do something that is
        // going to draw to the screen from native code, we need to run it on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[nativeAction.params objectForKey:@"title"] message:[nativeAction.params objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        });
        return nil;
    }
    
    // -------- GET /contacts
    else if ([nativeAction.action isEqualToString:@"contacts_lists"]) {
        // get names and numbers from the address book
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        __block NSDictionary *contactDisplay = nil;
        if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                contactDisplay = [self persons:addressBook];
            });
        }
        contactDisplay =  [self persons:addressBook];
        
        return contactDisplay;
    
    }
    
    // -------- GET /contacts
    else if ([nativeAction.action isEqualToString:@"contacts_detail"]) {
        NSString* recordid = [[nativeAction params] objectForKey:@"id"];
        // get names and numbers from the address book
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        __block NSDictionary *contactDisplay = nil;
        if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                contactDisplay = [self persons:addressBook recordid:recordid];
            });
        }
        contactDisplay = [self persons:addressBook recordid:recordid];
        
        return contactDisplay;
        
    }
    
    return nil;
}





@end
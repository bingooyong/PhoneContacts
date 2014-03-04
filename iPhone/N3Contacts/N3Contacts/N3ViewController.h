//
//  N3ViewController.h
//  N3Contacts
//
//  Created by 吕 勇 on 14-2-28.
//  Copyright (c) 2014年 LvYong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "N3AddressBookFrame.h"

@interface N3ViewController : UIViewController<UIWebViewDelegate, JavascriptBridgeDelegate> {
    UIWebView *mWebView;
}

@property(strong) UIWebView *webView;
@property (retain, nonatomic) N3AddressBook *addressBook;

@end

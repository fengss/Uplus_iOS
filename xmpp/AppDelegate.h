//
//  AppDelegate.h
//  xmpp
//
//  Created by In8 on 14-4-21.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@class AFHTTPRequestOperationManager;
@class MyXMPP;
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) MyXMPP  * myxmpp;
@property(nonatomic,strong) AFHTTPRequestOperationManager  * manger;


@end

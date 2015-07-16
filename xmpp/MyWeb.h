//
//  MyWeb.h
//  xmpp
//
//  Created by fengss on 15-4-15.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface MyWeb : NSObject
{
    AFHTTPRequestOperationManager *manger;
}
+(instancetype)sharedMyWeb;

/**
 *  登陆日志
 */
-(void)loginLog;

/**
 *  聊天数据上载
 */
-(void)updateChatMessageWithMessage:(NSString*)message withTo:(NSString*)toUser withForm:(NSString*)formUser;

@end

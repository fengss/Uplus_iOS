//
//  MyWeb.m
//  xmpp
//
//  Created by fengss on 15-4-15.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "MyWeb.h"

@implementation MyWeb
+(instancetype)sharedMyWeb{
    static MyWeb *webManger=nil;
    if (webManger==nil) {
        webManger=[[MyWeb alloc]init];
    }
    return webManger;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        manger=app.manger;
        manger.requestSerializer=[AFHTTPRequestSerializer serializer];
    }
    return self;
}


/**
 *  登陆日志
 */
-(void)loginLog{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString * username=[user objectForKey:kUserName];
    NSString * pwd=[user objectForKey:kPassword];
    
    NSDictionary *dic=@{
                        @"username":username,
                        @"password":pwd
                        };
    
    [manger GET:@"http://uplus.coderss.cn/index.php?m=User&a=LoginLog" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"登陆日志输出:----->%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/**
 *  上载聊天数据
 */
-(void)updateChatMessageWithMessage:(NSString*)message withTo:(NSString*)toUser withForm:(NSString*)formUser{
    NSRange range=[toUser rangeOfString:@"@"];
    NSString *ntoUser=[toUser substringToIndex:range.location];
    NSDictionary *dic=@{
                        @"from":formUser,
                        @"to":ntoUser,
                        @"message":message
                        };
    
    [manger GET:@"http://uplus.coderss.cn/index.php?m=ChatMessage&a=ToMessageIos" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"聊天上传结果输出:----->%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end

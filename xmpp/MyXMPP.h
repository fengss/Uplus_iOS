//
//  MyXMPP.h
//  xmpp
//
//  Created by In8 on 14-4-23.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"
#import "XMPPRoster.h"
#import "XMPPReconnect.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPCapabilities.h"


typedef void(^BLOCK)(BOOL b) ;
@class DataModel;

@protocol MyXMPPDelegate <NSObject>

@optional
//上线
- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
- (void)didDisconnect;
//消息
- (void)newMessageReceived:(NSString *)messageContent;

@end

@interface MyXMPP : NSObject<XMPPRosterDelegate>
@property(nonatomic,strong) DataModel  * dataModel;
@property (nonatomic , strong) XMPPStream *xmppStream;
@property(nonatomic,strong)   XMPPRoster *xmppRoster;
@property (nonatomic , assign) id<MyXMPPDelegate> delegate;
//回调执行的方法
@property(nonatomic,copy) BLOCK bc;
//判断是否登录还是注册
@property(nonatomic,assign) BOOL isLogin;
//判断是否登录还是注册
@property(nonatomic,assign) BOOL isReg;
//聊天窗口
@property(nonatomic,strong) ChatViewController  * chatvc;
//是否进入朋友列表
@property(nonatomic,assign) BOOL  * isEnterFriendList;
+ (MyXMPP *)sharedMyXMPP;
//好友请求代码块
@property(nonatomic,strong)  void(^addFriendBlock)(BOOL rec,NSString *result);
@property(nonatomic,strong) XMPPReconnect  * xmppReconnect;
@property(nonatomic,strong) XMPPvCardTempModule * xmppvCardTempModule;
@property(nonatomic,strong) XMPPvCardAvatarModule  * xmppvCardAvatarModule;
@property(nonatomic,strong) XMPPCapabilities  * xmppCapabilities;
- (BOOL)connect;
- (void)disconnect;

//注册
-(void)registerUser:(BLOCK)block;
//登陆
-(void)loginsterUser:(BLOCK)block;
//获取所有好友
-(void)getAllFriend;
//发送文字信息
-(void)sendMessageWithJid:(NSString*)jid WithMessage:(NSString*)message;
//删除好友
-(void)deleteWithUserName:(NSString*)userName;
//添加好友
-(void)addFriendWithUserName:(NSString*)userName;
@end

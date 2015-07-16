//
//  DataModel.h
//  xmpp
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriednModel.h"
#import "GroupModel.h"
#import "ChatMessageModel.h"
#import "FriendMessage_Update.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@class FMDatabase;

@interface DataModel : NSObject
@property(nonatomic,strong) FMDatabase  * FMDB;
@property(nonatomic,strong) AppDelegate *app;
@property(nonatomic,strong) AFHTTPRequestOperationManager  * manger;

+(instancetype)sharedDataModel;

#pragma mark 各种更新代理
@property(nonatomic,assign) id<FriendMessage_Update> delegateFirendMessageUpdate;

/**
 *  好友分组数据
 */
@property(nonatomic,strong) NSMutableArray  * MyGroupData;

/**
 *  朋友好友数据
 */
@property(nonatomic,strong) NSMutableArray  * MyFirendData;

/**
 *  朋友圈数据
 */
@property(nonatomic,strong) NSMutableArray  * MyFriendMessageData;

#pragma mark 朋友好友数据模型
/**
 *  插入好友信息
 *
 *  @param friend 好友信息
 *
 *  @return 是否成功插入
 */
-(BOOL)insertIntoMyFriend:(FriednModel*)friend;
/**
 *  查询所有好友信息
 *
 *  @return 好友数组
 */
-(NSMutableArray*)getAllFriend;

/**
 *  通过jid查询到一条好友详细记录
 *
 *  @param jid jid
 *
 *  @return 好友数据模型
 */
-(FriednModel*)getOneFriendWithJid:(NSString*)jid;


/**
 *  删除好友
 *
 *  @param userName
 */
-(BOOL)deleteFriendWithUserName:(NSString*)userName;


/**
 *  以组的信息单用username查询好友用来完善信息,解决openfire和自己的数据不同步问题
 *
 *  @param arr arr-username
 *
 *  @return
 */
-(void)getFriendByArray:(NSMutableArray*)arr withBlock:(void(^)(BOOL str,NSMutableArray *arr))BLOCK;



#pragma mark 聊天模型数据
/**
 *  插入聊天信息
 *
 *  @param chatModel 聊天信息模型
 *
 *  @return 是否插入
 */
-(BOOL)insertIntoMessage:(ChatMessageModel*)chatModel;

/**
 *  返回聊天信息
 *
 *  @param toJid   发向的用户
 *  @param fromJid 接受的用户
 *
 *  @return 返回的数组
 */
-(NSArray*)getAllMessageWithToJid:(NSString*)toJid withFormJid:(NSString*)formJid;
/**
 *  查询出组里面带人的数据
 *
 *  @return 两个数组
 */
-(NSMutableArray*)getGroupAboutFirends;


#pragma mark 朋友圈信息
/**
 *  获取所有好友
 */
-(void)getAllFriendMessage;


#pragma mark 最近聊天
/**
 *  获取最近聊天
 */
-(NSMutableArray*)nearChat;
@end

//
//  MyFriednModel.h
//  xmpp
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriednModel : NSObject
/**
 *  联系人昵称
 */
@property(nonatomic,copy,readonly) NSString  * name;
/**
 *  联系人ID
 */
@property(nonatomic,copy,readonly) NSString  * jid;
/**
 *  联系人的头像
 */
@property(nonatomic,copy,readonly) NSString  * avatorImage;
/**
 *  联系人的在线状态
 */
@property(nonatomic,copy,readonly) NSString  * state;
/**
 *  联系人的分组
 */
@property(nonatomic,copy) NSString  * group;
/**
 *  初始化
 *
 *  @param name
 *  @param jid
 *  @param state
 */
-(instancetype)initWithName:(NSString*)name withJid:(NSString*)jid withState:(NSString*)state withGroup:(NSString*)group;


#pragma mark 系统默认
@property(nonatomic,copy) NSString  * username;
@property(nonatomic,copy) NSString  * avator;
@end

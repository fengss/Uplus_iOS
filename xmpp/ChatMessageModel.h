//
//  ChatMessageModel.h
//  Uplus
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 Fss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageModel : NSObject
/**
 *  用户的Jid
 */
@property(nonatomic,copy) NSString  * formJid;
/**
 *  用户名
 */
@property(nonatomic,copy) NSString  * formName;
/**
 *  用户聊天内容
 */
@property(nonatomic,copy) NSString  * messageContent;
/**
 *  用户聊天的时间
 */
@property(nonatomic,copy) NSString  * messageDate;
/**
 *  发给指定的哪个用户
 */
@property(nonatomic,copy) NSString  * toJid;
/**
 *  指定的用户名
 */
@property(nonatomic,copy) NSString  * toName;

-(instancetype)initWithFormJid:(NSString*)formJid withName:(NSString*)formName withMessageContent:(NSString*)messageContent withMessageDate:(NSString*)messageDate withToJid:(NSString*)tojid withToName:(NSString*)toName;
@end

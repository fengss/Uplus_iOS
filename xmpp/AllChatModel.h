//
//  AllChatModel.h
//  xmpp
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllChatModel : NSObject
/**
 *  联系人昵称
 */
@property(nonatomic,copy) NSString  * name;
/**
 *  联系人ID
 */
@property(nonatomic,copy) NSString  * jid;
/**
 *  联系人最后发来的内容
 */
@property(nonatomic,copy) NSString  * content;
/**
 *  联系人最后的发表时间
 */
@property(nonatomic,copy) NSString  * time;
/**
 *  联系人的头像
 */
@property(nonatomic,copy) NSString  * avatorImage;
@end

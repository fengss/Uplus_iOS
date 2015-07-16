//
//  FriendMessageModel.h
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendMessageModel : NSObject
@property(nonatomic,copy) NSString  * jid;
@property(nonatomic,copy) NSString   *username;
@property(nonatomic,copy) NSString  * message;
@property(nonatomic,copy) NSString  * image;
@property(nonatomic,strong) NSString  * addtime;
@property(nonatomic,strong) NSString  * avator;
@end

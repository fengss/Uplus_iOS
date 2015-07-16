//
//  ReplyModel.h
//  xmpp
//
//  Created by fengss on 15-4-17.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject
@property(nonatomic,copy) NSString  * addtime;
@property(nonatomic,copy) NSString  * replymessage;
@property(nonatomic,copy) NSString  * messageid;
@property(nonatomic,copy) NSString  * formusername;
@property(nonatomic,copy) NSString  * avator;
@end

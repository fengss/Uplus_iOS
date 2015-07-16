//
//  GroupModel.h
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject
/**
 *  分组名
 */
@property(nonatomic,copy) NSString *groupName;
/**
 *  是否打开的状态值
 */
@property(nonatomic,assign) BOOL  * isOpen;

/**
 *  好友数据列表
 */
@property(nonatomic,strong) NSMutableArray * friendArray;

@end

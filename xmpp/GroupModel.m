//
//  GroupModel.m
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

-(NSMutableArray *)friendArray{
    if (_friendArray==nil) {
        _friendArray=[[NSMutableArray alloc]init];
//        _groupName = @[@"我的好友",@"特别关注"];
        _groupName=@"Freinds";
    }
    return _friendArray;
}

@end

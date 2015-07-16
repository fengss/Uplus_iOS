//
//  MyFriednModel.m
//  xmpp
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "FriednModel.h"

@implementation FriednModel
-(instancetype)initWithName:(NSString*)name withJid:(NSString*)jid withState:(NSString*)state withGroup:(NSString*)group{
    if (self==[super init]) {
        _name=name;
        _jid=jid;
        _state=state;
        _group=group;
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end

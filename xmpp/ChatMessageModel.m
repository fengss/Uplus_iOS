//
//  ChatMessageModel.m
//  Uplus
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 Fss. All rights reserved.
//

#import "ChatMessageModel.h"

@implementation ChatMessageModel
-(instancetype)initWithFormJid:(NSString *)formJid withName:(NSString *)formName withMessageContent:(NSString *)messageContent withMessageDate:(NSString *)messageDate withToJid:(NSString *)tojid withToName:(NSString *)toName{
    if (self==[super init]) {
        _formJid=formJid;
        _formName=formName;
        _messageContent=messageContent;
        _messageDate=messageDate;
        _toJid=tojid;
        _toName=toName;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",_formJid,_formName,_toJid,_toName,_messageContent,_messageDate];
}
@end

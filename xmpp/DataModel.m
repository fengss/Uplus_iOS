//
//  DataModel.m
//  xmpp
//
//  Created by fengss on 15-4-9.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "DataModel.h"
#import "FMDatabase.h"
#import "NetWorking.h"


@interface DataModel()
@end

@implementation DataModel
+(instancetype)sharedDataModel{
    static DataModel *dm=nil;
    if (dm==nil) {
        dm=[[DataModel alloc]init];
    }
    return dm;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Uplus.db"];
        self.FMDB=[FMDatabase databaseWithPath:dbPath];
        NSLog(@"%@",dbPath);
        self.app=[UIApplication sharedApplication].delegate;
        self.manger=self.app.manger;
    }
    return self;
}



#pragma mark 朋友数据模型
//  好友朋友数据模型
-(NSMutableArray *)MyFirendData{
    if (_MyFirendData==nil) {
        _MyFirendData=[[NSMutableArray alloc]init];
    }
    return _MyFirendData;
}
//插入好友数据
-(BOOL)insertIntoMyFriend:(FriednModel*)friend{
    BOOL rec=NO;
    if ([self.FMDB open]) {
        NSString *sql=@"create table if not exists Friend(Jid varchar(128) primary key,name varchar(128),avatorImage varchar(128),avator varchar(128),state varchar(128),Fgroup varchar(128));";
        rec=[self.FMDB executeUpdate:sql];
        if ([friend.group isEqual:@"(null)"]) {
            friend.group=@"Friends";
        }
        NSString *insertSql=[NSString stringWithFormat:@"insert into Friend(JID,name,avatorImage,state,Fgroup,avator) values('%@','%@','%@','%@','%@','%@');",friend.jid,friend.name,friend.avatorImage,friend.state,friend.group,friend.avator];
        NSLog(@"%@",insertSql);
        rec=[self.FMDB executeUpdate:insertSql];
        [self.FMDB close];
    }
    return YES;
}
//以组的形式查询好友信息并返回，返回更加完善的用户信息
-(void)getFriendByArray:(NSMutableArray*)arr withBlock:(void(^)(BOOL str,NSMutableArray *arr))BLOCK{
    
    //用户信息数组
    NSMutableArray *friendArr=[[NSMutableArray alloc]init];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
    NSDictionary *dic=@{
                        @"arrData":jsonData
                        };
    
    [self.manger POST:GETFRIEND_ARRAY parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *mdic in result) {
            FriednModel *model=[[FriednModel alloc]init];
            [model setValuesForKeysWithDictionary:mdic];
            model.avator=[mdic objectForKey:@"avator"];
            [friendArr addObject:model];
        }
        
        //用代码块去执行接下来的事情
        BLOCK(YES,friendArr);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}


//获取全部好友
-(NSMutableArray*)getAllFriend{
    NSMutableArray *data=[NSMutableArray array];
    if ([self.FMDB open]) {
        NSString *sql=@"select * from Friend;";
        FMResultSet *set=[self.FMDB executeQuery:sql];
        NSLog(@"%@",set);
        while ([set next]) {
            FriednModel *model=[[FriednModel alloc]initWithName:[set objectForColumnName:@"name"] withJid:[set objectForColumnName:@"JID"] withState:[set objectForColumnName:@"state"] withGroup:[set objectForColumnName:@"Fgroup"]];
            [data addObject:model];
        }
        [set close];
    }
    [self.FMDB close];
    return data;
}
//查询单条好友
-(FriednModel*)getOneFriendWithJid:(NSString*)jid{
    FriednModel *model;
    if ([self.FMDB open]) {
        NSString *sql=[NSString stringWithFormat:@"select * from Friend Where JID='%@';",[jid stringByAppendingString:kfix]];
        FMResultSet *set=[self.FMDB executeQuery:sql];
        while ([set next]) {
            model=[[FriednModel alloc]initWithName:[set objectForColumnName:@"name"] withJid:[set objectForColumnName:@"JID"] withState:[set objectForColumnName:@"state"] withGroup:[set objectForColumnName:@"Fgroup"]];
        }
        [set close];
    }
    [self.FMDB close];
    return model;
}

#pragma mark 好友分组模型
//得到所有的好友数据
-(NSMutableArray *)MyGroupData{
    if (_MyFirendData==nil) {
        _MyFirendData=[NSMutableArray array];
    }
    return _MyFirendData;
}

//查询相关分组下的好友数据
-(NSMutableArray*)getGroupAboutFirends{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    if ([self.FMDB open]) {
        NSString *sql=@"select distinct(Fgroup) from Friend;";
        FMResultSet *set=[self.FMDB executeQuery:sql];
        while ([set next]) {
            GroupModel *model=[[GroupModel alloc]init];
            model.groupName=[set objectForColumnName:@"Fgroup"];
            model.isOpen=NO;
            
            NSString *newSql=[NSString stringWithFormat:@"select * from Friend where Fgroup='%@'",model.groupName];
            FMResultSet *newSet=[self.FMDB executeQuery:newSql];
            while ([newSet next]) {
                FriednModel *fmodel=[[FriednModel alloc]initWithName:[newSet objectForColumnName:@"name"] withJid:[newSet objectForColumnName:@"JID"] withState:[newSet objectForColumnName:@"state"] withGroup:[newSet objectForColumnName:@"Fgroup"]];
                fmodel.avator=[newSet objectForColumnName:@"avator"];
                [model.friendArray addObject:fmodel];
            }
            [arr addObject:model];
        }
        
    }
    [self.FMDB close];
    NSLog(@"我索取的数据合集----->%@",arr);
    return arr;
}

/**
 *  删除单个好友操作
 *
 *  @param userName
 */
-(BOOL)deleteFriendWithUserName:(NSString*)userName{
    BOOL rec=NO;
    if ([self.FMDB open]) {
        NSString *sql=[NSString stringWithFormat:@"delete from Friend where Jid='%@'",userName];
        BOOL rec=[self.FMDB executeUpdate:sql];
        [self.FMDB close];
    }
    return rec;
}

#pragma mark 聊天数据模型
//插入聊天数据
-(BOOL)insertIntoMessage:(ChatMessageModel*)chatModel{
    BOOL rec=NO;
    if ([self.FMDB open]) {
        NSString *sql=@"create table if not exists ChatMessage(id integer primary key autoIncrement,FormJid varchar(128),FormName varchar(128),MessageContent varchar(128),MessageData varchar(128),ToJid varchar(128),ToName varchar(128));";
        rec=[self.FMDB executeUpdate:sql];
        NSString *insertSql=[NSString stringWithFormat:@"insert into ChatMessage(FormJid,FormName,MessageContent,MessageData,ToJid,ToName) values('%@','%@','%@','%@','%@','%@')",chatModel.formJid,chatModel.formName,chatModel.messageContent,chatModel.messageDate,chatModel.toJid,chatModel.toName];
        rec=[self.FMDB executeUpdate:insertSql];

    }
    [self.FMDB close];
    return rec;
    
}
//返回指定某人与某人的聊天数据
-(NSArray*)getAllMessageWithToJid:(NSString*)toJid withFormJid:(NSString*)formJid{
    NSMutableArray *arr=[NSMutableArray array];
    if ([self.FMDB open]) {
        NSString *sql=[NSString stringWithFormat:@"select * from ChatMessage Where (FormJid='%@' and ToJid='%@') or (FormJid='%@' and ToJid='%@');",formJid,toJid,toJid,formJid];
        NSLog(@"%@",sql);
        FMResultSet *set=[self.FMDB executeQuery:sql];
        while ([set next]) {
            ChatMessageModel *model=[[ChatMessageModel alloc]initWithFormJid:[set objectForColumnName:@"FormJid"] withName:[set objectForColumnName:@"FormName"] withMessageContent:[set objectForColumnName:@"MessageContent"] withMessageDate:[set objectForColumnName:@"MessageData"] withToJid:[set objectForColumnName:@"ToJid"] withToName:[set objectForColumnName:@"ToName"]];
            [arr addObject:model];
        }
    }
    return [NSArray arrayWithArray:arr];
}



#pragma mark 朋友圈信息
-(NSMutableArray *)MyFriendMessageData{
    if (_MyFirendData==nil) {
        _MyFirendData=[NSMutableArray array];
    }
    return _MyFirendData;
}

//获取所有好友圈信息
-(void)getAllFriendMessage{
    [[NetWorking sharedNetWorking] sendAsynchronousRequestWithURLString:FRIENDMESSAGE completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self.MyFriendMessageData addObjectsFromArray:arr];
        //数据加载完成通知更新用户的函数
        [self.delegateFirendMessageUpdate FrendMessageUpdate];
    }];
}


#pragma mark 最近聊天
/**
 *  获取最近聊天
 */
-(NSMutableArray*)nearChat{
    NSMutableArray *arrData=[[NSMutableArray alloc]init];
    
    if ([self.FMDB open]) {
        NSString *sql=@"select distinct(ToJid) from ChatMessage";
        FMResultSet *set=[self.FMDB executeQuery:sql];
        while ([set next]) {
            NSString *username=[set stringForColumn:@"ToJid"];
            if ([username rangeOfString:@"@"].location!=NSNotFound) {
                username=[username substringToIndex:[username rangeOfString:@"@"].location];
            }
            [arrData addObject:username];
        }
    }
    return arrData;
}
@end

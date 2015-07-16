//
//  MyXMPP.m
//  xmpp
//
//  Created by In8 on 14-4-23.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import "MyXMPP.h"
#import "DataModel.h"
#import "JSMessageSoundEffect.h"
#import "XMPPRosterCoreDataStorage.h"
#import "FriednModel.h"

@interface MyXMPP(){
    XMPPRosterCoreDataStorage *xmppRosterStorage;
}
@end

@implementation MyXMPP

BOOL getFriend=NO;

+ (MyXMPP *)sharedMyXMPP {
    static MyXMPP *sharedMyXMPP = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyXMPP = [[self alloc] init];
    });
    return sharedMyXMPP;
}

#pragma mark - self

- (instancetype)init {
    if (self==[super init]) {
        self.xmppStream = [[XMPPStream alloc] init];
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
        self.xmppReconnect = [[XMPPReconnect alloc] init];
        [self.xmppReconnect         activate:self.xmppStream];
        [self.xmppRoster            activate:self.xmppStream];
        [self.xmppvCardTempModule   activate:self.xmppStream];
        [self.xmppvCardAvatarModule activate:self.xmppStream];
        [self.xmppCapabilities      activate:self.xmppStream];
        
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //自动获取用户列表
        self.xmppRoster.autoFetchRoster = NO;
        self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
    }
    return self;
}

-(DataModel *)dataModel{
    if (_dataModel==nil) {
        _dataModel=[[DataModel alloc]init];
    }
    return _dataModel;
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

#pragma mark - out

- (BOOL)connect {
    
    if (!self.xmppStream) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    if (!xmppRosterStorage) {
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    }
    
    if (!self.xmppRoster) {
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    }
    
    NSString *jabberID = [[[NSUserDefaults standardUserDefaults] stringForKey:kUserName] stringByAppendingString:kfix];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kPassword];
    NSString *server = kServerHost;
    
    if (![self.xmppStream isDisconnected]) {
        [self.xmppStream disconnect];
    }
    
    if (jabberID == nil || myPassword == nil) {
        return NO;
    }
    
    
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    [self.xmppStream setHostName:server];
    
    NSError *error = nil;
    BOOL rect=[self.xmppStream connectWithTimeout:1 error:nil];
    if (!rect)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:[NSString stringWithFormat:@"对不起,连接服务器失败.......%@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    else{
        return YES;
    }
}

- (void)disconnect {
    
    if (xmppRosterStorage!=nil&&self.xmppRoster!=nil) {
        xmppRosterStorage = nil;
        self.xmppRoster = nil;
    }
    
    [self goOffline];
    [self.xmppStream disconnect];
    
}

#pragma mark - XMPP Delegate

#pragma mark 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSError *error = nil;
    if (self.isLogin) {
        NSLog(@"登录中.......");
        
        NSLog(@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName] ,[[NSUserDefaults standardUserDefaults] objectForKey:kPassword]);
        //登录
        [self.xmppStream authenticateWithPassword:[[NSUserDefaults standardUserDefaults] objectForKey:kPassword] error:&error];
        self.isLogin=NO;
        
    }
    else if(self.isReg){
        NSLog(@"注册中.......");
        //注册
        [self.xmppStream registerWithPassword:[[NSUserDefaults standardUserDefaults] objectForKey:kPassword] error:&error];
        self.isReg=NO;
    }
}

#pragma mark 登陆成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"登录成功 %@",sender.description);
    [self goOnline];
    //登录成功即可获得所有好友
    [self getAllFriend];
    self.bc(true);
}

#pragma mark 登陆未成功
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"登录失败");
    NSLog(@"%@",[error description]);
}

#pragma mark 注册


#pragma mark 接受朋友信息
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    NSLog(@"%@",iq);
    /**
     *  解析朋友信息
     */
    /*
     <iq xmlns="jabber:client" type="result" to="cwl@www.fss.com/fb401e90">
     <query xmlns="jabber:iq:roster">
     <item jid="fss@www.fss.com" name="fss" subscription="both">
     <group>Friends</group>
     </item>
     </query>
     </iq>
     
     */
    
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query=iq.childElement;
        NSArray *items=[query children];
        NSMutableArray *array=[NSMutableArray array];
        
        //第一次解析完善数据请求web
        NSMutableArray *userArr=[[NSMutableArray alloc]init];
        for (NSXMLElement * item in items) {
            NSString *jid=[item attributeStringValueForName:@"jid"];
            
            //剔除@www.coderss.cn这类的服务器后缀
            if ([jid rangeOfString:[NSString stringWithFormat:@"%@",kfix]].location!=NSNotFound) {
                jid=[jid substringToIndex:[jid rangeOfString:[NSString stringWithFormat:@"%@",kfix]].location];
            }
            [userArr addObject:jid];
        }
        
        [[DataModel sharedDataModel]getFriendByArray:userArr withBlock:^(BOOL str, NSMutableArray *arr) {
            
            BOOL flag=YES;
            
            if (str) {
                //第二次解析插入数据库
                for (int i=0,j=0; i<items.count; i++){
                    NSXMLElement * item=items[i];
                    NSString *jid=[item attributeStringValueForName:@"jid"];
                    NSString *name=[item attributeStringValueForName:@"name"];
                    NSString *group=[[[item childAtIndex:0]children]objectAtIndex:0];
                    
                    
                    if (j>arr.count-2) {
                        flag=NO;
                    }
                    else if(j<1){
                        flag=YES;
                    }
                    
                    
                    //开始完善信息
                    FriednModel *fmodel=arr[j];
                    
                    if (flag) {
                        j++;
                    }
                    else{
                        j--;
                    }
                    
                    
                    NSLog(@"我解析后的数据-----》 jid:%@,name:%@,group:%@",jid,name,group);
                    
                    /**
                     建立数据模型
                     */
                    FriednModel *model=[[FriednModel alloc]initWithName:name withJid:jid withState:@"在线" withGroup:group];
                    
                    //完善头像信息
                    model.avator=fmodel.avator;
                    
                    /**
                     *  插入数据库中
                     */
                    BOOL rec=[self.dataModel insertIntoMyFriend:model];
                    if (rec) {
                        NSLog(@"好友数据更新成功");
                        
                    }
                    
                    
                }
            }
            
        }];
        
        
        
        
        
    }
    
    if (getFriend&&_isEnterFriendList) {
        self.addFriendBlock(YES,nil);
        getFriend=NO;
    }
    
    //自己被别人删除了
    
    /*
     <iq xmlns="jabber:client" type="set" id="997-1716" to="cwl@www.coderss.cn/7c5cc633">
     <query xmlns="jabber:iq:roster">
     <item jid="jiayou13@www.coderss.cn" subscription="remove"/>
     </query>
     </iq>
     */
    
    if ([[iq type] isEqualToString:@"set"]) {
        if ([iq childCount]>0) {
            NSXMLElement *query=[iq childElement];
            NSXMLElement *item=[query childAtIndex:0];
            if ([[item attributeForName:@"subscription"] isEqual:@"remove"]) {
                
                //自己被别人删除了
                NSString *str=[item attributeForName:@"jid"];
                NSString *username=[str substringToIndex:[str rangeOfString:@"@"].location];
                NSLog(@"我被别人删除了 -------> username%@",username);
            }
        }
    }
    
    
    return YES;
}

#pragma mark 接受暴露
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            
            [self.delegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kDomain]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            [self.delegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, kDomain]];
            
        }
        
    }
    
    if ([[presence type]isEqualToString:@"subscribe"]) {
        NSLog(@"有新的添加好友新信息过来");
#warning 这里允许任何好友添加
        XMPPJID* form=[presence from];
        NSString *nickName=form.user;
        if (_isEnterFriendList) {
            [self.xmppRoster addUser:form withNickname:nickName];
        }
    }
    
    
    if ([presence childCount]>0) {
        NSXMLElement *node=[presence childAtIndex:0];
        NSString *str=[node stringValue];
        if (_isEnterFriendList) {
            [self getAllFriend];
            getFriend=YES;
        }
    }
    
    
    
    
    
    NSLog(@"%@",presence);
}

#pragma mark 接受信息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    if ([message isChatMessageWithBody]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        from = [[from componentsSeparatedByString:@"/"] objectAtIndex:0];
        NSString *msgStr = [NSString stringWithFormat:@"%@:%@",from,msg];
        //将接收到的信息写入字典中
        [self.chatvc.messageArray addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@@Out",msg] forKey:@"Text"]];
        [self.chatvc.timestamps addObject:[NSDate date]];
        //然后将信息提交到页面上
        [JSMessageSoundEffect playMessageReceivedSound];
        /**
         *  将信息聊天模型插入
         */
        
        ChatMessageModel *model=[[ChatMessageModel alloc]initWithFormJid:from  withName:from withMessageContent:msg withMessageDate:[NSDate dateWithTimeIntervalSinceNow:0] withToJid:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName] withToName:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
        
        if ([[DataModel sharedDataModel]insertIntoMessage:model]) {
            NSLog(@"聊天数据插入成功");
        }
        
        
        [self.chatvc finishSend];
    }
    
    NSLog(@"%@",message);
}
#pragma mark 登陆
-(void)loginsterUser:(BLOCK)bc{
    self.isLogin=YES;
    self.bc=[bc copy];
    [self connect];
}

#pragma mark 注册
-(void)registerUser:(BLOCK)bc{
    self.isReg=YES;
    self.bc=[bc copy];
    [self connect];
}

#pragma mark 获取所有好友
-(void)getAllFriend{
    NSXMLElement *query=[NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq=[NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

#pragma mark 发送信息给好友
-(void)sendMessageWithJid:(NSString*)jid WithMessage:(NSString *)message{
    XMPPJID *xmppjid=[XMPPJID jidWithString:jid];
    XMPPMessage *xmppmessage=[[XMPPMessage alloc]initWithType:@"chat" to:xmppjid];
    [xmppmessage addBody:message];
    
    /**
     *  将信息聊天模型插入
     */
    
    ChatMessageModel *model=[[ChatMessageModel alloc]initWithFormJid:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]  withName:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName] withMessageContent:message withMessageDate:[NSDate dateWithTimeIntervalSinceNow:0] withToJid:jid withToName:jid];
    
    if ([[DataModel sharedDataModel]insertIntoMessage:model]) {
        NSLog(@"聊天数据插入成功");
    }
    [_xmppStream sendElement:xmppmessage];
    
}

#pragma mark 删除好友
-(void)deleteWithUserName:(NSString*)userName{
    
    //告诉服务器我要删除好友
    [self.xmppRoster removeUser:[XMPPJID jidWithString:userName]];
}

#pragma mark 添加好友
-(void)addFriendWithUserName:(NSString *)userName{
    if (_isEnterFriendList) {
        [self.xmppRoster addUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",userName,kfix]] withNickname:userName groups:[NSArray arrayWithObject:@"Friends"]];
    }
}

@end

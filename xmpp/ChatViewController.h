//
//  ViewController.h
//  ChatMessageTableViewController
//
//  Created by Yongchao on 21/11/13.
//  Copyright (c) 2013 Yongchao. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface ChatViewController : JSMessagesViewController
@property(nonatomic,strong) NSString  * jid;

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *timestamps;


- (void)finishSend;
@end

//
//  FirendMessageViewController.h
//  xmpp
//
//  Created by fengss on 15-4-13.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJRefreshFooterView;
@class MJRefreshHeaderView;
@class AppDelegate;
@interface FirendMessageViewController : UIViewController
@property(nonatomic,strong) NSMutableArray  * arrayData;
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) MJRefreshFooterView *mjFootRefresh;
@property(nonatomic,strong) MJRefreshHeaderView *mjHeadRefresh;
@property(nonatomic,strong) AppDelegate *app;
//评论的数据
@property(nonatomic,strong) NSMutableArray *replyData;
//评论列表
@property(nonatomic,strong) UITableView *reply_table;
@end

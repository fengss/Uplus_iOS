//
//  AllChatViewController.m
//  xmpp
//
//  Created by fengss on 15-4-8.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "AllChatViewController.h"
#import "ChatViewController.h"
#import "DataModel.h"
#import "MyFriendCell.h"
#import "FriednModel.h"
#import "MJRefresh.h"
#import "ProgressHUD.h"

@interface AllChatViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    AFHTTPRequestOperationManager *manger;
    MJRefreshHeaderView *mjhead;
}
@property(nonatomic,strong) UITableView  * table;
@end

@implementation AllChatViewController

-(NSMutableArray *)chatDataArray{
    if (_chatDataArray==nil) {
        _chatDataArray=[[NSMutableArray alloc]init];
    }
    return _chatDataArray;
}

- (void)viewDidLoad {
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    manger=app.manger;
    
    [super viewDidLoad];
    [self loadData];
    [self createTableView];
    //创建刷新
    [self createMJRefresh];
    [self createAllChatView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark 创建刷新
-(void)createMJRefresh{
    mjhead=[MJRefreshHeaderView header];
    mjhead.delegate=self;
    mjhead.scrollView=self.table;
}

#pragma mark mjrefresh delegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [ProgressHUD showOnView:self.view];
    
    [self loadData];
}

#pragma mark 表格
-(void)createTableView{
    self.table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate=self;
    self.table.dataSource=self;
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
}

-(void)createAllChatView{
    self.navigationItem.title=@"最近聊天";
}

#pragma mark tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _chatDataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=@"cellid";
    MyFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MyFriendCell" owner:self options:nil]firstObject];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    FriednModel *model=self.chatDataArray[indexPath.row];
    cell.model=model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}



#pragma mark table delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    ChatViewController *chatvc=[board instantiateViewControllerWithIdentifier:@"chat"];
    FriednModel *model=self.chatDataArray[indexPath.row];
    NSString *username=[NSString stringWithFormat:@"%@%@",model.username,kfix];
    chatvc.jid=username;
    chatvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chatvc animated:YES];
}

#pragma mark 最近聊天人的数据加载
-(void)loadData{
    //获取各类数据
    NSMutableArray *arrayData=[[DataModel sharedDataModel]nearChat];
    //去获取网络上各类人的主要数据

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayData
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
    NSDictionary *dic=@{
                        @"arrData":jsonData
                        };
    
    [self.chatDataArray removeAllObjects];
    [manger POST:GETFRIEND_ARRAY parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *mdic in result) {
           FriednModel *model=[[FriednModel alloc]init];
            [model setValuesForKeysWithDictionary:mdic];
            [self.chatDataArray addObject:model];
        }
        
        [ProgressHUD hideOnView:self.view];
        [self.table reloadData];
        [mjhead endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end

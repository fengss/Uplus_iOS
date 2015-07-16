//
//  AddFriendViewController.m
//  xmpp
//
//  Created by fengss on 15-4-18.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SearchFriendModel.h"

@interface AddFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{
    NSMutableArray *dataArr;
    AFHTTPRequestOperationManager *manger;
    MyXMPP *xmpp;
    //选中要添加的好友
    NSString *selectUserName;
}
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    manger=app.manger;
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    xmpp=app.myxmpp;
    dataArr=[[NSMutableArray alloc]init];
    
    [self createUI];
    
    [self createAddFriendSearChBar];
}

-(void)createAddFriendSearChBar{
    UISearchBar *bar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    bar.placeholder=@"搜索好友";
    bar.showsCancelButton=YES;
    bar.delegate=self;
    self.tableview.tableHeaderView=bar;
    self.tableview.sectionHeaderHeight=44.0f;
    
}

-(void)createUI{
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.translucent=NO;
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
}

#pragma mark tableview data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=@"cellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    SearchFriendModel *model=dataArr[indexPath.row];
    
    cell.textLabel.text=model.username;
    
    return cell;
}
#pragma mark searchBar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSLog(@"开始搜索结果");
    [self loadData:searchBar.text];
}

#pragma mark 数据加载
-(void)loadData:(NSString*)string{
    NSDictionary *dic=@{
                        @"username":string
                        };
    
    [manger GET:GETFRIEND parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       //获得数据
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [dataArr removeAllObjects];
            
            for (int i=0; i<arr.count; i++) {
                SearchFriendModel *model=[[SearchFriendModel alloc]init];
                NSDictionary *dic=arr[i];
                [model setValuesForKeysWithDictionary:dic];
                [dataArr addObject:model];
            }
            
            
            [self.tableview reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchFriendModel *model=dataArr[indexPath.row];
    NSString *username=model.username;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:[NSString stringWithFormat:@"你是否真的要添加这位好友:%@",username] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    selectUserName=username;
    [alert show];
}

#pragma mark uialertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [xmpp addFriendWithUserName:selectUserName];
            
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

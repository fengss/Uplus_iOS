//
//  MeViewController.m
//  xmpp
//
//  Created by fengss on 15-4-8.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "MeViewController.h"
#import "MyProfileViewController.h"
#import "SettingTableViewController.h"
#import "FirendMessageViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *table;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"关于我";
    [self createTable];
}

-(void)createTable{
    self.table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.view addSubview:self.table];
}

#pragma mark TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 2;
    }
    else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSString *cellid=@"cellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image=[UIImage imageNamed:@"Checkers"];
    
    if (section==0) {
        cell.textLabel.text=@"个人资料";
        cell.imageView.image=[UIImage imageNamed:@"MoreExpressionShops@2x"];
    }
    else if (section==1&&row==0){
        cell.textLabel.text=@"相册";
        cell.imageView.image=[UIImage imageNamed:@"MoreMyAlbum@2x"];
    }
    else if (section==1&&row==1){
        cell.textLabel.text=@"收藏";
        cell.imageView.image=[UIImage imageNamed:@"MoreMyFavorites@2x"];
    }
    else if (section==2){
        cell.textLabel.text=@"钱包";
        cell.imageView.image=[UIImage imageNamed:@"MoreMyBankCard@2x"];
    }
    else if (section==3){
        cell.textLabel.text=@"设置";
        cell.imageView.image=[UIImage imageNamed:@"MoreSetting@2x"];
    }
    
    return cell;
}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        MyProfileViewController *mp=[story instantiateViewControllerWithIdentifier:@"MyProfile"];
        mp.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mp animated:YES];
    }
    else if (indexPath.section==3){
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        SettingTableViewController *setting=[story instantiateViewControllerWithIdentifier:@"Setting"];
        setting.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:setting animated:YES];
    }
    else if (indexPath.section==1){
        FirendMessageViewController *friendMessage=[[FirendMessageViewController alloc]init];
        friendMessage.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:friendMessage animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

//
//  MomentsViewController.m
//  xmpp
//
//  Created by fengss on 15-4-8.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "MomentsViewController.h"
#import "SYQRCodeViewController.h"
#import "FirendMessageViewController.h"
#import "TagViewController.h"
#import "LocationDemoViewController.h"
#import "WebViewViewController.h"

@interface MomentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *table;
@end

@implementation MomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTable];
}

-(void)createTable{
    self.navigationItem.title=@"发现";
    
    self.table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.view addSubview:self.table];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2){
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
    if (section==0) {
        cell.textLabel.text=@"朋友圈";
        cell.imageView.image=[UIImage imageNamed:@"FriendCardNodeIconLivingArea@2x"];
    }
    else if (section==1&&row==0){
        cell.textLabel.text=@"扫一扫";
        cell.imageView.image=[UIImage imageNamed:@"ff_IconQRCode@2x"];
    }
    else if (section==2&&row==0){
        cell.textLabel.text=@"附近的人";
        cell.imageView.image=[UIImage imageNamed:@"FriendCardNodeIconLocationService@2x"];
    }
    else if (section==2&&row==1){
        cell.textLabel.text=@"漂流瓶";
        cell.imageView.image=[UIImage imageNamed:@"FriendCardNodeIconBottle@2x"];
    }
    else if (section==3){
        cell.textLabel.text=@"购物";
        cell.imageView.image=[UIImage imageNamed:@"MoreGame@2x"];
    }
    
    return cell;
}

#pragma mark delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYQRCodeViewController *syqvc=[[SYQRCodeViewController alloc]init];
    FirendMessageViewController *fmVc=[[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"FirendMessageViewController"];
    if (indexPath.section==1&&indexPath.row==0) {
        syqvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:syqvc animated:YES];
    }
    else if (indexPath.section==0){
        fmVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:fmVc animated:YES];
    }
    else if (indexPath.section==2&&indexPath.row==1){
        TagViewController *tag=[[TagViewController alloc]init];
        tag.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:tag animated:YES];
    }
    else if (indexPath.section==2&&indexPath.row==0){
        LocationDemoViewController* local=[[LocationDemoViewController alloc]init];
        local.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:local animated:YES];
    }
    else if (indexPath.section==3){
        WebViewViewController *web=[[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"webview"];
        
        web.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:web animated:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

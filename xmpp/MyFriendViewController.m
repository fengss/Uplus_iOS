//
//  MyFriendViewController.m
//  xmpp
//
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "MyFriendViewController.h"
#import "ChatViewController.h"
#import "FriednModel.h"
#import "DataModel.h"
#import "MyFriendCell.h"
#import "GroupModel.h"
#import "RNBlurModalView.h"
#import "KOPopupView.h"
#import "AMBlurView.h"
#import "AddFriendViewController.h"

#define USE_DELEGATE 1

@interface MyFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    MyXMPP *xmpp;
}
@property(nonatomic,strong) KOPopupView * popupView;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UISearchBar *bar;
@property(nonatomic,strong) NSMutableArray  * data;
/**
 *  好友数据模型
 */
@property(nonatomic,strong) DataModel  * dataModel;
/**
 *  分组数据
 */
@property(nonatomic,strong) GroupModel * groupModel;

@end

@implementation MyFriendViewController

//数据载入
-(NSMutableArray *)data{
    if (_data==nil) {
        
        _data=[[DataModel sharedDataModel] getGroupAboutFirends];
    }
    return _data;
}

-(DataModel *)dataModel{
    if (_dataModel==nil) {
        _dataModel=[[DataModel alloc]init];
    }
    return _dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate * app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    xmpp=app.myxmpp;
    xmpp.isEnterFriendList=YES;
    xmpp.addFriendBlock=^(BOOL rec,NSString* result){
        if (rec) {
            _data=[[DataModel sharedDataModel] getGroupAboutFirends];
            [self.table reloadData];
        }
    };
    
    
    [self createFriendView];
    
    [self createSearchBar];
    [self createTable];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [super viewDidAppear:animated];
}

-(void)createFriendView{
    self.navigationItem.title=@"我的朋友";
    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    self.navigationItem.rightBarButtonItem=add;
}


#pragma mark 添加好友
-(void)addFriend:(UIBarButtonItem*)item{
    if(!self.popupView)
        self.popupView = [KOPopupView popupView];
    [self.popupView removeFromSuperview];
    
    AddFriendViewController *addFriend=[[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"AddFriendViewController"];
    addFriend.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addFriend animated:YES];
    
//    [self.popupView show];
}

-(void)btnClick2:(UIButton*)btn{
    [self.popupView hideAnimated:YES];
}

#pragma mark 创建searchbar
-(void)createSearchBar{
    self.bar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.bar.delegate=self;
    self.bar.placeholder=@"搜索好友";
    [self.bar setShowsCancelButton:YES animated:YES];
}

-(void)createTable{
    self.dataModel=[[DataModel alloc]init];
    
    self.table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.table.dataSource=self;
    self.table.delegate=self;
    //设置sectionIndexColor
    self.table.sectionIndexBackgroundColor=[UIColor clearColor];
    self.table.sectionHeaderHeight=90;
    
    //设置表头视图
    self.table.sectionHeaderHeight=44;
    self.table.tableHeaderView=self.bar;
    
    
    [self.view addSubview:self.table];
    
}


#pragma mark TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    /**
     *  返回好友分组的数据
     */
    return [self.data count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //设置开关
    GroupModel *group=(GroupModel*)self.data[section];
    if (group.isOpen) {
        return [group.friendArray count];
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 44;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(0, 0,0, tableView.sectionHeaderHeight);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=[UIColor whiteColor];
    btn.tag=section;
    GroupModel *model=(GroupModel*)[self.data objectAtIndex:section];
    [btn setTitle:model.groupName forState:UIControlStateNormal];
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
    
    //添加删除分组的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //AlbumRedDelete@2x
    [button setImage:[UIImage imageNamed:@"AlbumRedDelete@2x"] forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.bounds.size.width - 40, 12, 20, 20);
    [button addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 111 + section;
//    [btn addSubview:button];
    return btn;
}

//删除分组按钮的点击事件
-(void)deleteButtonClick:(UIButton *)button
{
    NSLog(@"删除成功");
}

/**
 *  分组按钮
 */
-(void)btnClick:(UIButton*)btn{
    GroupModel *model=(GroupModel*)[self.data objectAtIndex:btn.tag];
    model.isOpen=!model.isOpen;
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  移动特效
     */
    CGFloat rotationAngleDegrees = 0;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-200, -20);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    
    
    UIView *card = [cell contentView];
    card.layer.transform = transform;
    card.layer.opacity = 0.8;
    
    
    
    [UIView animateWithDuration:1.0f animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid=@"cellid";
    MyFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MyFriendCell" owner:self options:nil]firstObject];
    }
    
    //提取数据
    GroupModel *gmodel=[self.data objectAtIndex:indexPath.section];
    FriednModel *fmodel=[gmodel.friendArray objectAtIndex:indexPath.row];
    
    
    //设置数据
    cell.model=fmodel;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  跳转聊天窗口Controller
     */
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    ChatViewController *chatvc=[board instantiateViewControllerWithIdentifier:@"chat"];
    GroupModel *gmodel=[self.data objectAtIndex:indexPath.section];
    FriednModel *fmodel=[gmodel.friendArray objectAtIndex:indexPath.row];
    chatvc.jid=fmodel.jid;
    chatvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chatvc animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //删除好友操作
    
    //找到分组
    GroupModel *groupModel=self.data[indexPath.section];
    
    //删除好友
     FriednModel *friend=groupModel.friendArray[indexPath.row];
    
    [groupModel.friendArray removeObjectAtIndex:indexPath.row];
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section ] withRowAnimation:UITableViewRowAnimationFade];
    
    //通知数据库删除
    [self.dataModel deleteFriendWithUserName:friend.jid];
    
    //通知服务器删除
    [xmpp deleteWithUserName:friend.jid];
}

#pragma mark searchbar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
}

#warning 搜索栏点击事件
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

#pragma mark TableView indexs
/*
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0;i<26;i++) {
        [array addObject:[NSString stringWithFormat:@"%c",'A'+i]];
    }
    return array;
}
*/
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

//
//  FirendMessageViewController.m
//  xmpp
//
//  Created by fengss on 15-4-13.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "FirendMessageViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "FriendMessageModel.h"
#import "FriendMessageCellTableViewCell.h"
#import "UpMyFriendMessageViewController.h"
#import "PersonModel.h"
#import "ProgressHUD.h"
#import "XHShockHUD.h"
#import "ReplyModel.h"
#import "ReplyCell.h"
#import "AMBlurView.h"

@interface FirendMessageViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UITextFieldDelegate>
{
    int numPage;
    
    UIImageView *avator;
    
    UIView *view;
    
    //当前tableview选中的信息model
    FriendMessageModel *selectModel;
    
    //暂无评论view
    AMBlurView *noReplyView;
    
}
@end

@implementation FirendMessageViewController

- (void)viewDidLoad {
    self.app=[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];

    
    [self createNav];
    [self createTableView];
    [self loadDataWithNumPage:[NSString stringWithFormat:@"%d",numPage] withIsTop:YES];
    [self getMySelfData];
    //创建回复列表
    [self createReplyTable];
    //创建等待
    [self createProgress];
    
    //创建暂无评论的view
    [self createNoReply];
    
}

#pragma mark 暂无评论view创建
-(void)createNoReply{
    noReplyView=[[AMBlurView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH, 0, UISCREEN_WIDTH/3*2, UISCREEN_HEIGHT-69)];
    noReplyView.backgroundColor=[UIColor whiteColor];
    noReplyView.layer.cornerRadius=9.0f;
    noReplyView.layer.masksToBounds=YES;
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH/3*2, UISCREEN_HEIGHT-69)];
    title.text=@"暂无评论";
    title.numberOfLines=10;
    title.textColor=[UIColor grayColor];
    title.font=[UIFont systemFontOfSize:98.0f];
    [noReplyView addSubview:title];
    [self.view addSubview:noReplyView];
    noReplyView.hidden=YES;
}


#pragma mark 懒加载
-(NSMutableArray *)replyData{
    if (_replyData==nil) {
        _replyData=[[NSMutableArray alloc]init];
    }
    return _replyData;
}

#pragma mark 创建回复列表
-(void)createReplyTable{
    self.reply_table=[[UITableView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-69) style:UITableViewStylePlain];
    self.reply_table.tag=110;
    self.reply_table.dataSource=self;
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(30, 30, self.reply_table.frame.size.width, 13)];
    title.font=[UIFont systemFontOfSize:13.0f];
    title.textColor=[UIColor grayColor];
    title.text=@"->往右移除评论栏";

    self.reply_table.tableHeaderView=title;
    self.reply_table.sectionHeaderHeight=43.0f;
    
    self.reply_table.delegate=self;
    self.reply_table.layer.cornerRadius=7.0f;
    self.reply_table.layer.masksToBounds=YES;
    
    [self.view addSubview:self.reply_table];
}


#pragma mark 等待progress
/**
 *  创建等待
 */
-(void)createProgress{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-69)];
    view.tag=995;
    [ProgressHUD showOnView:view];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
}

/**
 *  移除等待
 */
-(void)removeProgress{
    UIView *view=[self.view viewWithTag:995];
    [ProgressHUD hideOnView:view];
    [view removeFromSuperview];
}



/**
 *  获取自己信息
 */
-(void)getMySelfData{
    NSDictionary *dic=@{
                        @"username":[[NSUserDefaults standardUserDefaults]objectForKey:kUserName]
                        };
    
    AFHTTPRequestOperationManager *manger=self.app.manger;
    //不要去解析
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manger GET:@"http://uplus.coderss.cn/index.php?m=User&a=getUserIos&safe=fss" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //获取到数据,并解析数据
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *data=[arr lastObject];
        
        PersonModel *model=[[PersonModel alloc]init];
        
        NSLog(@"%@",data);
        [model setValuesForKeysWithDictionary:data];
        
        //直接设置ui
        [self configUI:model];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


/**
 *  配置本vc的ui
 *
 *  @param model
 */
-(void)configUI:(PersonModel*)model{
    [avator setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://uplus.coderss.cn/upload/%@",model.avator]] placeholderImage:[UIImage imageNamed:@"Avator"]];
}

#pragma mark 自身方法
-(NSMutableArray *)arrayData{
    if (_arrayData==nil) {
        _arrayData=[NSMutableArray array];
    }
    return _arrayData;
}

-(void)createNav{
    self.title=@"朋友圈";
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(left:)];
    self.navigationItem.rightBarButtonItem=left;
    
}


/**
 *  正式写说说发布到服务器
 *
 *  @param item
 */
-(void)left:(UIBarButtonItem*)item{
    UpMyFriendMessageViewController *myMessageViewController=[[UpMyFriendMessageViewController alloc]init];
    //跳入准备发布
    [self.navigationController pushViewController:myMessageViewController animated:YES];
}

-(void)createTableView{
    self.navigationController.navigationBar.translucent=NO;
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-69) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    /**
     头部相册
     */
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 170)];
    //背景
#warning 修改顶部照片墙
    UIImageView *bgimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,UISCREEN_WIDTH , UISCREEN_WIDTH/2)];
    bgimageview.image=[UIImage imageNamed:@"demo-avatar-jobs"];
    bgimageview.layer.shadowColor=[UIColor blueColor].CGColor;
    bgimageview.layer.shadowOpacity=YES;
    bgimageview.layer.shadowOffset=CGSizeMake(1, 1);
    bgimageview.layer.shadowRadius=10.0f;
    [view addSubview:bgimageview];
    
    //头像
    avator=[[UIImageView alloc]initWithFrame:CGRectMake(bgimageview.frame.size.width/2, 75, bgimageview.frame.size.width/2, bgimageview.frame.size.height/3*2)];
    avator.image=[UIImage imageNamed:@"Avator"];
    avator.layer.cornerRadius=20.0f;
    avator.layer.masksToBounds=YES;
    [bgimageview addSubview:avator];
    
    
    self.tableview.sectionHeaderHeight=170.0f;
    self.tableview.tableHeaderView=view;
    
    [self.view addSubview:self.tableview];
    
    
}


/**
 *  上拉下拉
 */
-(void)createMjRefresh{
    numPage=1;
    if (self.mjHeadRefresh==nil) {
        self.mjHeadRefresh=[MJRefreshHeaderView header];
        self.mjFootRefresh=[MJRefreshFooterView footer];
    }
    self.mjHeadRefresh.scrollView=self.tableview;
    self.mjFootRefresh.scrollView=self.tableview;
    
    self.mjFootRefresh.delegate=self;
    self.mjHeadRefresh.delegate=self;
}


/**
 *  加载数据
 *
 *  @param numpage 页码
 *  @param isTop   刷新还是加载
 */
-(void)loadDataWithNumPage:(NSString*)numpage withIsTop:(BOOL)isTop{
    if (self.app==nil) {
        self.app=[UIApplication sharedApplication].delegate;
    }
    
    
    NSDictionary *dic=@{
                        @"username":@"fengss",
                        @"type":@"all",
                        @"page":numpage
                        };
    AFHTTPRequestOperationManager *manger=self.app.manger;
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    [manger GET:FRIENDMESSAGE parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //接受到的数据
        NSArray *data=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //判断是否是刷新
        if (isTop) {
            [self.arrayData removeAllObjects];
        }
//        //开始模型封装
//        for (int i=0; i<data.count; i++) {
//            FriendMessageModel *model=[[FriendMessageModel alloc]init];
//            [model setValuesForKeysWithDictionary:data[i]];
//            [model setValue:[data[i]objectForKey:@"id"] forKey:@"jid"];
//            //添加模型
//            [self.arrayData addObject:model];
//        }
        //开始模型封装
        for (int i = (int)data.count - 1; i > 0; i--) {
            FriendMessageModel *model=[[FriendMessageModel alloc]init];
            [model setValuesForKeysWithDictionary:data[i]];
            [model setValue:[data[i]objectForKey:@"id"] forKey:@"jid"];
            //添加模型
            [self.arrayData addObject:model];
        }
        //重新刷新视图
        [self.tableview reloadData];
        //不刷新
        [self.mjFootRefresh endRefreshing];
        [self.mjHeadRefresh endRefreshing];
        //移除等待
        [self removeProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"数据接受失败------>%@",[error localizedDescription]);
    }];
}

#pragma mark refresh delegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView==self.mjFootRefresh) {
        numPage++;
        [self loadDataWithNumPage:[NSString stringWithFormat:@"%d",numPage] withIsTop:NO];
    }
    else{
        [self loadDataWithNumPage:[NSString stringWithFormat:@"1"] withIsTop:YES];
    }
}

#pragma mark TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.reply_table) {//评论的tableview
        if (self.replyData.count==0) {
            noReplyView.hidden=NO;
        }
        else{
            noReplyView.hidden=YES;
            
        }
        return self.replyData.count;
        
    }
    else{
        return self.arrayData.count;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.reply_table) {//评论的tableview
        return UISCREEN_WIDTH/3+15;
    }
    else{
        return 230.0f;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.reply_table||tableView.tag==110) {//评论的tableview
        NSString *cellid=@"replycellid";
        ReplyCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[ReplyCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        ReplyModel *mymodel=self.replyData[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell configUI:mymodel];
        return cell;
    }
    else{
        NSString *cellid=@"cellid";
        FriendMessageCellTableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[FriendMessageCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        
        //取出数据
        FriendMessageModel *model=[self.arrayData objectAtIndex:indexPath.row];
        //设置数据
        cell.fmessage=model;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.tag=indexPath.row;
        
        //为每一个cell给予一个左右滑手势
        UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeEvent:)];
        UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeEvent:)];
        rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
        leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
        [cell addGestureRecognizer:leftSwipe];
        [cell addGestureRecognizer:rightSwipe];
        
        
        return cell;
    }
}


#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView!=self.reply_table) {
        selectModel=self.arrayData[indexPath.row];
        
        if (!view) {
            //改一层显示大图
            view=[[UIView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH,UISCREEN_HEIGHT, 1, 1)];
            view.backgroundColor=[UIColor blackColor];
            [self.view addSubview:view];
        }
        
        
        //添加btn的图片
        UIButton *btn;
        
        if ([view viewWithTag:998]) {
            btn=(UIButton*)[view viewWithTag:998];
        }
        else{
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame=CGRectMake(view.frame.size.width/2,view.frame.size.height/2, 0, 0);
            btn.tag=998;
            [view addSubview:btn];
        }
        
        
        //添加别人描述的内容
        UILabel *content;
        if ([view viewWithTag:997]) {
            content=(UILabel*)[view viewWithTag:997];
        }
        else{
            content=[[UILabel alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH,UISCREEN_HEIGHT,100, 100)];
            content.tag=997;
            content.backgroundColor=[UIColor blueColor];
            content.textColor=[UIColor whiteColor];
            content.text=@"测试测试";
            [view addSubview:content];
        }
        
        //添加回复的按钮
        UIButton *reply;
        if ([view viewWithTag:996]) {
            reply=(UIButton *)[view viewWithTag:996];
        }
        else{
            reply=[UIButton buttonWithType:UIButtonTypeCustom];
            reply.tag=996;
            reply.backgroundColor=[UIColor blueColor];
            reply.layer.cornerRadius=8.0f;
            reply.layer.masksToBounds=YES;
            [reply setTitle:@"评论一下" forState:UIControlStateNormal];
            [reply addTarget:self action:@selector(replyForThisMessage:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:reply];
        }
        
        
        
        
        //添加信息
        content.text=selectModel.message;
        
        
        
        //添加图片
        [btn setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURE,selectModel.image]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon"]];
        
        //自动拉长
        CGSize size=[selectModel.message sizeWithFont:[UIFont systemFontOfSize:20.0F] constrainedToSize:CGSizeMake(UISCREEN_WIDTH, 300) lineBreakMode:NSLineBreakByCharWrapping];
        
        
        
        [UIView animateWithDuration:0.8 animations:^{
            view.frame=CGRectMake(0,0, UISCREEN_WIDTH, UISCREEN_HEIGHT);
            btn.frame=view.frame;
            content.frame=CGRectMake(0, UISCREEN_HEIGHT-61-size.height, UISCREEN_WIDTH, size.height);
            reply.frame=CGRectMake(UISCREEN_WIDTH-140, UISCREEN_HEIGHT-content.frame.size.height-110, 140, 40);
        }];
    }
}

/**
 *  隐藏详情和回复界面
 *
 *  @param btn
 */
-(void)btnClick:(UIButton*)btn{
    UIButton * mbtn=[view viewWithTag:998];
    UILabel * content=[view viewWithTag:997];
    UIButton * reply=[view viewWithTag:996];
    [UIView animateWithDuration:0.8 animations:^{
        view.frame=CGRectMake(UISCREEN_WIDTH,UISCREEN_HEIGHT, 1, 1);
        btn.frame=CGRectMake(UISCREEN_WIDTH,UISCREEN_HEIGHT, 0, 0);
        content.frame=CGRectMake(UISCREEN_WIDTH/2,UISCREEN_HEIGHT/2, 0, 0);
        reply.frame=CGRectMake(UISCREEN_WIDTH/2,UISCREEN_HEIGHT/2, 0, 0);
    }];
}


/**
 *  回复评论界面
 *
 *  @param btn
 */
-(void)replyForThisMessage:(UIButton*)btn{
    [self btnClick:nil];
    
    //回复框背景view
    AMBlurView *reply_view;
    
    if ([self.view viewWithTag:888]) {
        reply_view=[self.view viewWithTag:888];
    }
    else{
        reply_view=[[AMBlurView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH/2-150, UISCREEN_HEIGHT/2-150, 0, 0)];
        reply_view.tag=888;
        reply_view.layer.cornerRadius=9.0f;
        reply_view.layer.masksToBounds=YES;
//        [reply_view addTarget:self action:@selector(hideThisView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    //回复的信息框
    UITextField *reply_message;
    if ([reply_view viewWithTag:889]) {
        reply_message=[reply_view viewWithTag:889];
    }
    else{
        
        reply_message=[[UITextField alloc]initWithFrame:CGRectMake(15, reply_view.frame.size.height/2, 0, 0)];
        reply_message.borderStyle=UITextBorderStyleRoundedRect;
        reply_message.tag=889;
        reply_message.delegate=self;
        reply_message.returnKeyType=UIReturnKeyDone;
        [reply_view addSubview:reply_message];
        
        
    }
    
    
    
    //两个按钮
    UIButton *reply_btn;
    if ([reply_view viewWithTag:887]) {
        reply_btn=[reply_view viewWithTag:887];
    }
    else{
        reply_btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        reply_btn.frame=CGRectMake(15, reply_message.frame.origin.y+reply_message.frame.size.height+5, 0, 0);
        [reply_btn setTitle:@"回复信息" forState:UIControlStateNormal];
        [reply_btn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
        reply_btn.backgroundColor=[UIColor blueColor];
        reply_btn.tag=887;
        [reply_view addSubview:reply_btn];
    }
    
    
    UIButton *reply_exit;
    if ([reply_view viewWithTag:886]) {
        reply_exit=[reply_view viewWithTag:886];
    }
    else{
        reply_exit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        reply_exit.frame=CGRectMake(15, reply_btn.frame.origin.y+reply_btn.frame.size.height+reply_btn.frame.size.height+5, 0, 0);
        [reply_exit setTitle:@"退出回复" forState:UIControlStateNormal];
        reply_exit.backgroundColor=[UIColor blueColor];
        [reply_exit addTarget:self action:@selector(hideThisView:) forControlEvents:UIControlEventTouchUpInside];
        reply_exit.tag=886;
        [reply_view addSubview:reply_exit];
    }
    
    
    
    reply_btn.hidden=NO;
    reply_exit.hidden=NO;
    reply_message.hidden=NO;
    
    
    [UIView animateWithDuration:0.8 animations:^{
        reply_view.frame=CGRectMake(UISCREEN_WIDTH/2-125, 50, 250, 200);
        reply_message.frame=CGRectMake(15, 15, reply_view.frame.size.width-30, 30);
        reply_message.text=@"";
        reply_message.placeholder=@"此刻你的想法";
        reply_btn.frame=CGRectMake(reply_message.frame.origin.x, reply_message.frame.origin.y+reply_message.frame.size.height+5, reply_message.frame.size.width, 50);
        reply_exit.frame=CGRectMake(reply_message.frame.origin.x,reply_btn.frame.origin.y+reply_btn.frame.size.height+15, reply_message.frame.size.width, 50);
        
        
    }];
    
    [self.view addSubview:reply_view];
    
    
}


/**
 *  回复信息
 *
 *  @param btn
 */
-(void)replyMessage:(UIButton*)btn{
    //父级view
    UIView *view=[btn superview];
    //评论内容
    UITextField *text=(UITextField*)[view viewWithTag:889];
    AFHTTPRequestOperationManager *manger=self.app.manger;
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *dic=@{
                        @"safe":@"fss",
                        @"messageid":selectModel.jid,
                        @"replymessage":text.text,
                        @"formusername":[[NSUserDefaults standardUserDefaults]objectForKey:kUserName]
                        };
    
    [manger GET:@"http://uplus.coderss.cn/index.php?m=Reply&a=ToReply" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"OK"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"信息评论成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"信息评论失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        //回复后隐藏界面
        [self hideThisView:btn.superview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


/**
 *  隐藏界面
 *
 *  @param control
 */
-(void)hideThisView:(UIControl*)control{
    //为退出回复做退出准备
    if (control.tag!=888) {
        control=[control superview];
    }
    
    [control endEditing:YES];
    
    UITextField *reply_message=(UITextField*)[control viewWithTag:889];
    UIButton * reply_btn=(UIButton*)[control viewWithTag:887];
    UIButton * reply_exit=(UIButton*)[control viewWithTag:886];
    
    [UIView animateWithDuration:0.8 animations:^{
        control.frame=CGRectMake(UISCREEN_WIDTH/2-150, UISCREEN_HEIGHT/2-150, 0, 0);
        reply_message.frame=CGRectMake(0, control.frame.size.height/2,0, 0);
        reply_btn.frame=CGRectMake(0, reply_message.frame.origin.y+reply_message.frame.size.height+5, 0, 0);
        reply_exit.frame=CGRectMake(0,control.frame.origin.y+control.frame.size.height+control.frame.size.height+5, 0, 0);
        reply_btn.hidden=YES;
        reply_exit.hidden=YES;
        reply_message.hidden=YES;
        
    }];
    
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

#pragma mark swipe delegate   ----  左右滑动  显示回复列表
-(void)leftSwipeEvent:(UISwipeGestureRecognizer*)ges{
    FriendMessageCellTableViewCell *cell=ges.view;
    FriendMessageModel *model=self.arrayData[cell.tag];
    
    AFHTTPRequestOperationManager *manger=self.app.manger;
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *mydic=@{
                          @"safe":@"fss",
                          @"messageid":model.jid
                          };
    
    [UIView animateWithDuration:0.2 animations:^{
        self.reply_table.frame=CGRectMake(UISCREEN_WIDTH/3, 0, UISCREEN_WIDTH/3*2, UISCREEN_HEIGHT-69);
        noReplyView.frame=CGRectMake(UISCREEN_WIDTH/3, 0, UISCREEN_WIDTH/3*2, UISCREEN_HEIGHT-69);
    }]; 
    
    
    [ProgressHUD showOnReplyView:self.reply_table];
    
    [manger GET:@"http://uplus.coderss.cn/index.php?m=Reply&a=getReply" parameters:mydic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self.replyData removeAllObjects];
            for (int i=0; i<arr.count; i++) {
                ReplyModel *model=[[ReplyModel alloc]init];
                NSDictionary *mdic=arr[i];
                [model setValuesForKeysWithDictionary:mdic];
                [self.replyData addObject:model];
                //刷新self.reply_table
                [self.reply_table reloadData];
                
            }
            [ProgressHUD hideOnView:self.reply_table];
        }
        else{
            [self.replyData removeAllObjects];
            //刷新self.reply_table
            [self.reply_table reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"评论获取失败->%@",error);
    }];
    
    
}

-(void)rightSwipeEvent:(UISwipeGestureRecognizer*)ges{
    FriendMessageCellTableViewCell *cell=ges.view;
    FriendMessageModel *model=self.arrayData[cell.tag];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.reply_table.frame=CGRectMake(UISCREEN_WIDTH, 0, UISCREEN_WIDTH/3*2, UISCREEN_HEIGHT-69);
        noReplyView.frame=CGRectMake(UISCREEN_WIDTH, 0, UISCREEN_WIDTH/3*2, UISCREEN_HEIGHT-69);
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createMjRefresh];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.mjFootRefresh.scrollView=nil;
    self.mjHeadRefresh.scrollView=nil;
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

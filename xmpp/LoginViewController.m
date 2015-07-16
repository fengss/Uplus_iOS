//
//  LoginViewController.m
//  xmpp
//
//  Created by cderss on 15-3-8.
//  Copyright (c) 2015年 fss. All rights reserved.
//

#import "LoginViewController.h"
#import "MyXMPP.h"
#import "MainViewController.h"
#import "AppDelegate.h"


@interface LoginViewController ()<UITextFieldDelegate>
{
    AFHTTPRequestOperationManager *manger;
}
@property(nonatomic,strong)MyXMPP *xmpp;
@property(nonatomic,assign) CGRect MyImageViewRect;
@property(nonatomic,assign) CGRect MyLoginButtonRect;
@property(nonatomic,assign) CGRect MyRegisterButtonRect;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    manger=app.manger;
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    self.xmpp=[(AppDelegate*)[UIApplication sharedApplication].delegate myxmpp];
    [self.adverView setArrayData:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
    [self viewAlloc];
    
}

-(void)viewAlloc{
    self.userName.delegate=self;
    self.passWord.delegate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Login:(UIButton *)sender {
    NSString *username=self.userName.text;
    NSString *password=self.passWord.text;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:kUserName];
    [ud setObject:password forKey:kPassword];
    
    //WEB服务器校验
    [self loginUserToWebServiceWithUserName:username withPassWord:password];
    
}

- (IBAction)Register:(UIButton *)sender {
    NSString *username=self.userName.text;
    NSString *password=self.passWord.text;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:kUserName];
    [ud setObject:password forKey:kPassword];
    
    //web服务注册
    [self RegisterWithUsername:username withPassWord:password];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag==100) {
        [[(UITextField*)self.view viewWithTag:101]becomeFirstResponder];
    }
    else if (textField.tag==101){
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)loginUserToWebServiceWithUserName:(NSString*)username withPassWord:(NSString*)passWord{
    NSDictionary *dic=@{
                        @"username":username,
                         @"password":passWord
                        
                        };
    [manger GET:@"http://uplus.coderss.cn/index.php?m=User&a=LoginUserIos&cat=fss" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSLog(@"获取数据成功 ------>%@",result);
        if (![result isEqualToString:@"Fail"]) {
            //获取个人信息
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic=[arr lastObject];


            //直接登陆
            [self.xmpp loginsterUser:^(BOOL b) {
                if (b) {
                    MainViewController *mvc=[[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainViewController"];
                    [self presentViewController:mvc animated:YES completion:nil];
                }
            }];
            //登陆日志记载一下
            [[MyWeb sharedMyWeb] loginLog];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"对不起,您登录的账号有误,请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取数据失败 %@",error);
    }];
}

/**
 *  服务器同步注册
 */
-(void)RegisterWithUsername:(NSString*)userName withPassWord:(NSString*)passWord{
    NSDictionary *dic=@{
                        @"username":userName,
                        @"password":passWord
                        };
    [manger GET:@"http://uplus.coderss.cn/index.php?m=User&a=RegisterUserIos&cat=fss" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"我获取的结果------>%@",result);
        
        [self.xmpp registerUser:^(BOOL b) {
            if (b) {
                MainViewController *mvc=[[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MainViewController"];
                [self presentViewController:mvc animated:YES completion:nil];
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"注册失败,->%@",error);
    }];
}



@end

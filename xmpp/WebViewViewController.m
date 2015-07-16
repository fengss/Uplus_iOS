//
//  WebViewViewController.m
//  xmpp
//
//  Created by fengss on 15-4-19.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "WebViewViewController.h"
#import "ProgressHUD.h"

@interface WebViewViewController ()<UIWebViewDelegate>

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent=NO;
    
    
    self.webview.scalesPageToFit=YES;
    self.webview.delegate=self;
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mls.coderss.cn"]];
    
    [self.webview loadRequest:request];
}

#pragma mark web delegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    view.tag=110;
    [ProgressHUD showOnView:view];
    [self.view addSubview:view];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    UIView *view=[self.view viewWithTag:110];
    [ProgressHUD hideOnView:view];
    [view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//
//  TagViewController.m
//  xmpp
//
//  Created by fengss on 15-4-18.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "TagViewController.h"
#import "DBSphereView.h"
#import "UserRand.h"

@interface TagViewController ()

@property (nonatomic, retain) DBSphereView *sphereView;
@property(nonatomic,strong) NSMutableArray  * dataArr;
@end

@implementation TagViewController

-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

@synthesize sphereView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    

    [self loadData];
}

-(void)loadData{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app.manger GET:@"http://uplus.coderss.cn/index.php?m=User&a=randOfStudent" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            for (NSDictionary *dic in arr) {
                UserRand *model=[[UserRand alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [self createUI];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#warning 把数字数据改成一个个头像
-(void)createUI{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app.manger POST:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < self.dataArr.count; i ++) {
        UserRand *model=self.dataArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:model.username forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:24.];
        btn.frame = CGRectMake(0, 0, 150, 20);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [sphereView addSubview:btn];
    }
    [sphereView setCloudTags:array];
    sphereView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sphereView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonPressed:(UIButton *)btn
{
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [sphereView timerStart];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MLLogisticsViewController.m
//  Matro
//
//  Created by NN on 16/4/11.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLLogisticsViewController.h"
#import "MLLogisticsTableViewCell.h"
#import "UIColor+HeinQi.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "SkyRadiusView.h"
#import "AppDelegate.h"

@interface MLLogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * _logisticsArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem * home = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Home_top_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(homeAction)];
    self.navigationItem.rightBarButtonItem = home;
    
    self.title = @"订单跟踪";
    
    _logisticsArray = @[@{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]},
                        @{@"info":@"感谢您在美罗全球精品购购物，欢迎再次光临",
                          @"time":[NSDate new]}
                        ];
    [self downLoadLogTrack];
}
- (void)downLoadLogTrack {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/OrderForm.ashx?op=wlxx&jlbh=xxx&userid=1502649",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"订单跟踪 请求成功");
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"%@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单跟踪 请求成功");
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)homeAction{
    [self getAppDelegate].tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _logisticsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    static NSString *CellIdentifier = @"MLLogisticsTableViewCell" ;
    MLLogisticsTableViewCell *cell = (MLLogisticsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    if (_logisticsArray.count == 1) {
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = YES;
        cell.point.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
        cell.infoLabel.textColor = [UIColor colorWithHexString:@"#AE8E5D"];

    }else{
        if (indexPath.row == 0) {
            cell.topLine.hidden = YES;
            cell.point.backgroundColor = [UIColor colorWithHexString:@"#AE8E5D"];
            cell.infoLabel.textColor = [UIColor colorWithHexString:@"#AE8E5D"];
        }else if (indexPath.row == _logisticsArray.count - 1){
            cell.bottomLine.hidden = YES;
            cell.point2.hidden = YES;
            cell.point.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
            cell.infoLabel.textColor = [UIColor colorWithHexString:@"#0e0e0e"];
        }else{
            cell.point2.hidden = YES;
        }
    }
    NSDictionary *dic = _logisticsArray[indexPath.row];
    cell.infoLabel.text = dic[@"info"];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",dic[@"time"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MLOrderCommentViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderComViewController.h"
#import "MLOrderSubComCell.h"
#import "MLOrderSubHeadCell.h"
#import "MLOrderComProductCell.h"
#import "UIColor+HeinQi.h"

@interface MLOrderComViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *productArray;

@end

@implementation MLOrderComViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单评价";
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubComCell" bundle:nil] forCellReuseIdentifier:kOrderComSubCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderSubHeadCell" bundle:nil] forCellReuseIdentifier:kOrderComHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderComProductCell" bundle:nil] forCellReuseIdentifier:kOrderComProductCell];
        [self.view addSubview:tableView];
        tableView;
    });
    
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.productArray.count;
    }
    return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MLOrderComProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComProductCell forIndexPath:indexPath];
        return cell;
    }
    else{
        if (indexPath.row == 0) {
            MLOrderSubHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComHeadCell forIndexPath:indexPath];
            return cell;
        }
        else{
            MLOrderSubComCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderComSubCell forIndexPath:indexPath];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.f;
    }
    else{
        if (indexPath.row == 0 ) {
            return 45.f;
        }
        return 192.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (NSMutableArray *)productArray{
    if (!_productArray) {
        _productArray = [NSMutableArray array];
        [_productArray addObject:@"1"];
        [_productArray addObject:@"1"];
        [_productArray addObject:@"1"];
    }
    return _productArray;
}

@end

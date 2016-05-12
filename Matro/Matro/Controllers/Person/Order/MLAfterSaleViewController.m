//
//  MLAfterSaleViewController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLAfterSaleViewController.h"
#import "MLAfterSaleProductCell.h"
#import "MLAfterSaleHeadCell.h"

@interface MLAfterSaleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MLAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleHeadCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleProductCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleProductCell];
        [self.view addSubview:tableView];
        tableView;
    });

    
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        MLAfterSaleHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLAfterSaleHeadCell forIndexPath:indexPath];
        return cell;
    }
    
    MLAfterSaleProductCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLAfterSaleProductCell forIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 120.f;
    }
    return 120.f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 10.F)];
    foot.backgroundColor = RGBA(245, 245, 245, 1);
    
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
    
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

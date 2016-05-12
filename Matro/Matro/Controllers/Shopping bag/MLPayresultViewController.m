//
//  MLPayresultViewController.m
//  Matro
//
//  Created by NN on 16/3/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLPayresultViewController.h"

#import "MLLikeTableViewCell.h"
#import "MLPayerrTableViewCell.h"
#import "HFSOrderListHeaderView.h"
#import "MLPayresultHeader.h"
#import "MLGoodsDetailsViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLLikeModel.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"

#define HEADER_IDENTIFIER @"MLPayresultHeader"
#define HEADER_IDENTIFIER01 @"OrderListHeaderIdentifier"

@interface MLPayresultViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_likeArray;
    NSArray *_likeArr;
    NSArray * _errTitleArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *otherBgView;

@end

@implementation MLPayresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_isSuccess) {
        self.title = @"支付成功";
        [self loadDateOrLike];
    }else{
        self.title = @"支付失败";
    }
    
    _otherBgView.hidden = _isSuccess;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MLPayresultHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER01];
    
    _likeArray = [[NSMutableArray alloc]initWithArray:@[@{
                                                            @"image":@"http://mg.soupingguo.com/bizhi/big/10/266/947/10266947.jpg"
                                                            },@{
                                                            @"image":@"http://pic6.nipic.com/20100330/1295091_132647229343_2.jpg",
                                                            },@{
                                                            @"image":@"http://www.bz55.com/uploads/allimg/150202/139-150202134H6.jpg",                                                                                                                     },@{
                                                            @"image":@"http://pic24.nipic.com/20121020/10653015_165154682160_2.jpg",
                                                            },@{
                                                            @"image":@"http://pic25.nipic.com/20121129/8305779_151443594000_2.jpg",
                                                            } ]];
    
    _errTitleArray = @[@"订单编号：",@"支付金额：",@"支付方式：",@"失败原因："];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取猜你喜欢数据
- (void)loadDateOrLike {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=getcnxh&spsl=2",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"猜你喜欢 请求成功");
        NSArray *arr = (NSArray *)responseObject;
        _likeArr = [MTLJSONAdapter modelsOfClass:[MLLikeModel class] fromJSONArray:arr error:nil];
        _likeArray = [[NSMutableArray alloc]initWithArray:_likeArr];
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
}


- (void)likeAction:(id)sender{
    UIControl * control = ((UIControl *)sender);
//
//    [self getAppDelegate].tabBarController.selectedIndex = 0;
//    [self.navigationController popViewControllerAnimated:NO];
    
    NSLog(@"%ld",control.tag);
    NSDictionary *likeobjl = _likeArray[control.tag];

    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    vc.paramDic = likeobjl;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (IBAction)otherAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        if(_isSuccess){
            return _likeArray.count%2 == 0 ? _likeArray.count/2 : (_likeArray.count + 1)/2;
        }else{
            return _errTitleArray.count;
        }
    }else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSuccess) {
        static NSString *CellIdentifier = @"MLLikeTableViewCell" ;
        MLLikeTableViewCell *cell = (MLLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        NSInteger lnum = indexPath.row * 2;
        NSInteger rnum = indexPath.row * 2 + 1;
        
        MLLikeModel *likeobjl = _likeArray[lnum];
        
            [cell.imageView01 sd_setImageWithURL:likeobjl.IMGURL placeholderImage:PLACEHOLDER_IMAGE];
            cell.lBgView.tag = lnum;
            cell.nameLabel01.text = likeobjl.SPNAME;
            cell.priceLabel01.text = likeobjl.XJ;
        
       
        
        NSUInteger length = [likeobjl.LSDJ length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:likeobjl.LSDJ];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
         NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName
                      value:cell.rpriceLabel01.textColor range:NSMakeRange(0, length)];
        [cell.rpriceLabel01 setAttributedText:attri];
        [cell.lBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (rnum >= _likeArray.count) {
            cell.rBgView.hidden = YES;
        }else{
            MLLikeModel *likeobjr = _likeArray[rnum];
            
            cell.rBgView.hidden = NO;
            [cell.imageView02 sd_setImageWithURL:likeobjr.IMGURL placeholderImage:PLACEHOLDER_IMAGE];
            cell.rBgView.tag = rnum;
            cell.nameLabel02.text = likeobjr.SPNAME;
            cell.priceLabel02.text = likeobjr.XJ;
            
            NSUInteger length = [likeobjr.LSDJ length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:likeobjr.LSDJ];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
             NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName
                          value:cell.rpriceLabel02.textColor range:NSMakeRange(0, length)];
            [cell.rpriceLabel02 setAttributedText:attri];
            
            [cell.rBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"MLPayerrTableViewCell" ;
        MLPayerrTableViewCell *cell = (MLPayerrTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.peTitleLabel.text = _errTitleArray[indexPath.row];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        if (_isSuccess) {
            return MAIN_SCREEN_WIDTH * 280/489 + 24;
        }else{
            if (indexPath.row == 3) {
                return 72;
            }else{
                return 36;
            }
        }
        
    }else{
        return 0;
    }
}

//设置头部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 36.0f;
    }else{
        if (_isSuccess) {
            return 230;
        }else{
            return 200;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1 && !_isSuccess) {
        return 92;
    }
    return 12.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        HFSOrderListHeaderView *headerView = [[HFSOrderListHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER01];
        if (_isSuccess) {
           headerView.nameLabel.text = @"猜你喜欢";
        }else{
            headerView.nameLabel.text = @"您的支付信息";
        }
        
        headerView.orderStatusLabel.hidden = YES;
        return headerView;
    }else{
        MLPayresultHeader *headerView = [[MLPayresultHeader alloc]initWithReuseIdentifier:HEADER_IDENTIFIER];
        
        if (_isSuccess) {
            headerView.tisLabel.text = @"支付成功";
            headerView.tisImageView.image = [UIImage imageNamed:@"zhifuchenggong-1"];
        }else{
            headerView.tisLabel.text = @"支付失败了！";
            headerView.tisImageView.image = [UIImage imageNamed:@"zhifushibai-1"];
            
            headerView.toHome.hidden = YES;
            headerView.toOrder.hidden = YES;
        }
        
        return headerView;
    }
    
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

//
//  MLBagViewController.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBagViewController.h"

#import "MLLoginViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLSureViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MTLJSONAdapter.h"
#import "MLLikeModel.h"

#import "HFSOrderListHeaderView.h"
#import "MLBagHeaderView.h"
#import "MLBagActiveTableViewCell.h"
#import "MLBagGoodsTableViewCell.h"
#import "MLBagZengpinTableViewCell.h"
#import "MLLikeTableViewCell.h"
#import "JSONKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLBagFootView.h"
#import <objc/runtime.h>
#import "MLInvoiceViewController.h"

#define HEADER_IDENTIFIER @"MLBagHeaderView"
#define HEADER_IDENTIFIER01 @"OrderListHeaderIdentifier"
#define FOOTER_IDENTIFIER @"OrderListFOOTIdentifier"

@interface MLBagViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView * _tableView;
    NSMutableDictionary * totalArray;
    NSMutableArray *oridinalAry;
    NSMutableArray *globalAry1;
    NSMutableArray *globalAry2;

    NSMutableArray *_likeArray;

    NSMutableArray *globalFrom; //来自哪个仓库
    int sectionkey;
    NSString *userid;
    NSMutableArray *selAry;
    BOOL iseidtStatus;
    BOOL isGlobalOrder;
}
//点击登录的按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//提示登录的文字
@property (weak, nonatomic) IBOutlet UILabel *tiShiLabel;

@property (strong, nonatomic) IBOutlet UIView *topBgView;//顶部登录底视图，登录时隐藏，未登录时显示 同时需要修改topH,登录 topH = 0 未登录 topH = 54

@property (strong, nonatomic) IBOutlet UIView *baseTableView;//为了做输入框不遮挡键盘，这个view给购物袋的tableview提供大小的约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopH;

@end

@implementation MLBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.title = @"我的购物袋";
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = editBtn;
    editBtn.tintColor = [HFSUtility hexStringToColor:@"AE8E5D"];
    
    
    sectionkey = 0;
    totalArray = [[NSMutableDictionary alloc] init];
    oridinalAry = [[NSMutableArray alloc] init];
    globalAry1 = [[NSMutableArray alloc] init];
    globalAry2 = [[NSMutableArray alloc] init];
    globalFrom = [[NSMutableArray alloc] init];
    _likeArray = [[NSMutableArray alloc] init];
    selAry = [[NSMutableArray alloc] init];
    //设置按钮的边框和颜色
    [_loginBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [_loginBtn.layer setBorderWidth:1.0f];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:3.0f];
    
    //购物袋主tableview
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tvc.tableView.frame = _baseTableView.frame;
    _tableView = [[UITableView alloc]init];
    _tableView = tvc.tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    [self.view insertSubview:_tableView belowSubview:_hud];
    [self addChildViewController:tvc];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"MLBagHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:@"HFSOrderListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER_IDENTIFIER01];
    
    //去掉弹簧效果
    //_tableView.bounces = NO;
    //隐藏垂直的滚动条
    _tableView.showsVerticalScrollIndicator = NO;
 
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self loadDateOrLike];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [totalArray removeAllObjects];
}

-(void)viewDidAppear:(BOOL)animated
{
    sectionkey = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    CGRect tframe = _baseTableView.frame;
    
    if (userid) {
        self.topBgView.hidden = YES;
        tframe.origin = CGPointMake(_baseTableView.frame.origin.x, 0);
        tframe.size = CGSizeMake(_baseTableView.frame.size.width, _baseTableView.frame.size.height+50);
        _baseTableView.frame = tframe;
        _tableView.frame = tframe;
    }
    [self downLoadOrdinaryBag];
    [super viewDidAppear:YES];
}

#pragma mark 获取猜你喜欢数据
- (void)loadDateOrLike {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=getcnxh&spsl=6",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject)
        {
            NSArray *arr = (NSArray *)responseObject;
            if (arr && arr.count>0) {
                [_likeArray addObjectsFromArray:arr];
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
}
#pragma mark 获取普通商品信息
- (void)downLoadOrdinaryBag {
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"正在加载...";
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=shopcartlist&selbj=&ddly=&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dic = (NSArray *)responseObject;
        if (dic && dic.count>0) {
            NSDictionary *dicoriginal = [NSDictionary dictionaryWithObjectsAndKeys:dic,@"CartInfoList", nil];
            [totalArray setObject:dicoriginal forKey:[NSString stringWithFormat:@"%i",sectionkey]];
            sectionkey++;
        }
        [_hud hide:YES];
        [self downLoadKJBag];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _hud.labelText = @"普通商品 请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}
#pragma mark 获取跨境商品信息
- (void)downLoadKJBag {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=shopcarthwglist&selbj=&userid=%@",SERVICE_GETBASE_URL,userid];
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dicary = (NSArray *)responseObject;
        if (dicary && dicary.count>0) {
            for (NSDictionary *dic in dicary) {
                NSArray *ary = dic[@"CartInfoList"];
                if (ary && ary.count>0) {
                    [totalArray setObject:dic forKey:[NSString stringWithFormat:@"%i",sectionkey]];
                    sectionkey++;
                }
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"跨境商品 请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}

#pragma mark 删除购物车
- (void)deleteCart:(NSDictionary*)paramdic {
    
//    NSData *data = [HFSUtility RSADicToData:@{@""}] ;
//    NSString *ret = base64_encode_data(data);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=delshopcart&JMSP_ID=%@&userid=%@",SERVICE_GETBASE_URL,paramdic[@"JMSP_ID"],userid];
        NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"error %@",result);
                                          if (result && [@"true" isEqualToString:result ]) {
                                              sectionkey = 0;
                                              
                                              UIBarButtonItem *btn = self.navigationItem.rightBarButtonItem;
                                              
                                                  [btn setTitle:@"编辑"];
                                                  iseidtStatus = NO;
                                              
                                              [_tableView reloadData];
                                              [self downLoadOrdinaryBag];
                                          }
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}


#pragma mark- 结算
- (IBAction)paymentAction:(id)sender{
    UIButton *btn = (UIButton*)sender;
    NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",btn.tag]];
    if (arydic[@"HWGCKDM"]) {
        isGlobalOrder = YES;
    }
    else{
        isGlobalOrder = NO;
    }
    
    [_hud show:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = @"正在生成订单，请稍后...";
   [self ordercheck];
}

#pragma mark- 登录
- (IBAction)loginButtonAction:(id)sender {
    NSLog(@"点击了登录按钮！==");
    NSString *typeStr = ((UIButton *)sender).titleLabel.text;
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
//    if ([typeStr isEqualToString:@"登录"]) {
        vc.isLogin = YES;
//    }else{
//        vc.isLogin = NO;
//    }

    MLNavigationController *nvc = [[MLNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        
    }];

}



-(void)orderAccount
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/ordersubmit.ashx?op=JieSuanInfo&ddly=0&userid=%@",SERVICE_GETBASE_URL,userid];

    NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          result = [result substringWithRange:NSMakeRange(1, result.length-2)];
//                                        [result stringByReplacingOccurrencesOfString:@"\\\\" withString:@"" options:1 range:NSMakeRange(0, result.length)];
                                          result = [result stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                          NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                                          NSError *err;
                                          NSDictionary *rdic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                              options:NSJSONReadingMutableContainers
                                                                                                error:&err];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud hide:YES];
                                              MLSureViewController * vc = [[MLSureViewController alloc]init];
                                              vc.paramDic = rdic;
                                              vc.isGlobalShop = isGlobalOrder;
                                              vc.shopsary = selAry;
                                              self.hidesBottomBarWhenPushed = YES;
                                              [self.navigationController pushViewController:vc animated:YES];
                                              self.hidesBottomBarWhenPushed = NO;
                                          });
                                      }
                                  }];
    [task resume];
}

-(BOOL)ordercheck
{
    __block BOOL isok=NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=jiesuan&ddly=0&userid=%@",SERVICE_GETBASE_URL,userid];
    NSURL * URL = [NSURL URLWithString:urlStr];
    
    //    NSData * postData = [params dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"error %@",result);
                                          if (result.length<=2) {
                                              isok = true;
                                               [self orderAccount];
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = result;
                                                  _hud.labelFont = [UIFont systemFontOfSize:13];
                                                  [_hud hide:YES afterDelay:2];
                                              });

                                          }
                                      }
                                      
                                  }];
    
    [task resume];
    
    return isok;
    
    
}

#pragma mark- 猜你喜欢点击
- (void)likeAction:(id)sender{
    UIControl * control = ((UIControl *)sender);
    
    NSLog(@"选择了第几个猜你喜欢商品：%ld",control.tag);
    NSDictionary *paramdic = _likeArray[control.tag];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    vc.paramDic = paramdic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_likeArray.count>0) {
        return totalArray.count+1;
    }
    return totalArray.count; //商品的senction + 猜你喜欢的section
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == totalArray.count) {//猜你喜欢的cell的数量，一个cell同时显示两个商品，所以得除
        if(iseidtStatus){
            return 0;
        }
        return _likeArray.count%2 == 0 ? _likeArray.count/2 : (_likeArray.count + 1)/2;
    }else{//假数据里面的列表的数量
        NSArray *list;
        NSDictionary *dic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
        if (dic[@"CartInfoList"]) {
            list = (NSArray*)dic[@"CartInfoList"];
        }
        return list.count;
    }
}

//猜你喜欢
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == totalArray.count) {//猜你喜欢
        static NSString *CellIdentifier = @"MLLikeTableViewCell" ;
        MLLikeTableViewCell *cell = (MLLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        
        NSInteger lnum = indexPath.row ;
        NSDictionary *likeobjl = _likeArray[lnum];
        NSDictionary *likeobjr = nil;

        NSInteger rnum = indexPath.row + 1;
        if (rnum<_likeArray.count) {
            likeobjr = _likeArray[rnum];
            
            [cell.imageView02 sd_setImageWithURL:[NSURL URLWithString:likeobjr[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
            cell.rBgView.tag = rnum;
            cell.nameLabel02.text = likeobjr[@"SPNAME"];
            cell.priceLabel02.text =[NSString stringWithFormat:@"￥%@",likeobjr[@"XJ"]] ;
            
            NSUInteger length = [likeobjr[@"LSDJ"] length];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:likeobjr[@"LSDJ"]];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
             NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
            [attri addAttribute:NSStrikethroughColorAttributeName
                          value:cell.rpriceLabel02.textColor range:NSMakeRange(0, length)];
            [cell.rpriceLabel02 setAttributedText:attri];
            [cell.rBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (rnum >= _likeArray.count) {
            cell.rBgView.hidden = YES;
        }
        
        [cell.imageView01 sd_setImageWithURL:[NSURL URLWithString:likeobjl[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
        cell.lBgView.tag = lnum;
        cell.nameLabel01.text = likeobjl[@"SPNAME"];
        cell.priceLabel01.text = [NSString stringWithFormat:@"￥%@",likeobjl[@"XJ"]] ;

        NSUInteger length = [likeobjl[@"LSDJ"] length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:likeobjl[@"LSDJ"]];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |
         NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName
                      value:cell.rpriceLabel01.textColor range:NSMakeRange(0, length)];
        [cell.rpriceLabel01 setAttributedText:attri];
        [cell.lBgView addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        NSDictionary *tempdic = arydic[@"CartInfoList"][indexPath.row];
        if (tempdic[@"tis"]) {
            static NSString *CellIdentifier = @"MLBagActiveTableViewCell" ;
            MLBagActiveTableViewCell *cell = (MLBagActiveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            return cell;
        }
        else if (tempdic[@"zeng"])
        {
            static NSString *CellIdentifier = @"MLBagZengpinTableViewCell" ;
            MLBagZengpinTableViewCell *cell = (MLBagZengpinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            
            return cell;
        }
        else{
            static NSString *CellIdentifier = @"MLBagGoodsTableViewCell" ;
            MLBagGoodsTableViewCell *cell = (MLBagGoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
          
            [cell.productImgView sd_setImageWithURL:[NSURL URLWithString:tempdic[@"IMGURL"]] placeholderImage:PLACEHOLDER_IMAGE];
            cell.productNameLabel.text = tempdic[@"NAME"];
            cell.priceLabel.text =[NSString stringWithFormat:@"￥%@",tempdic[@"LSDJ"]] ;
            NSString *selbj = tempdic[@"SELBJ"];
            BOOL issel = [selbj boolValue];
            [cell.selBtn setSelected:issel];
            
            if (cell.selBtn.selected) { //如果是选中的加入到选中数组
                [selAry addObject:tempdic];
            }
            objc_setAssociatedObject(cell.selBtn, "firstObject", tempdic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cell.selBtn addTarget:self action:@selector(paysel:) forControlEvents:UIControlEventTouchUpInside];
            if (iseidtStatus) {
                cell.delBtn.hidden = NO;
            }
            else{
                cell.delBtn.hidden = YES;
            }
            objc_setAssociatedObject(cell.delBtn, "firstObject", tempdic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [cell.delBtn addTarget:self action:@selector(delShopping:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    

}

-(void)delShopping:(id)sender
{
    UIButton *delbtn = (UIButton*)sender;
    delbtn.selected = !delbtn.selected;
    NSDictionary *firstobj = objc_getAssociatedObject(delbtn, "firstObject");
    [self deleteCart:firstobj];
}

#pragma 底部菜单全选
-(void)selectAllSectionGoods:(id)sender
{
    UIButton *selbtn = (UIButton*)sender;
    selbtn.selected = !selbtn.selected;
    for (int i =0; i<totalArray.count; i++) {
        NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%d",i]];
        if (arydic[@"CartInfoList"]) {
            NSArray *arrys = (NSArray*)arydic[@"CartInfoList"];
            NSMutableString *srty = [NSMutableString string];
            for (NSDictionary *dic in arrys) {
                NSString *jid = dic[@"JMSP_ID"];
                [srty appendString:jid];
                [srty appendString:@","];
            }
            
            if (srty.length>1) {
                NSString *jsids = [srty substringToIndex:srty.length-1];
                [self setShoppingCart:selbtn.selected spid:jsids];
            }
        }

    }
    
}

-(void)paysel:(id)sender
{
    UIButton *selbtn = (UIButton*)sender;
    selbtn.selected = !selbtn.selected;
    
    NSDictionary *firstobj = objc_getAssociatedObject(selbtn, "firstObject");
    if (selbtn.selected) {
        if (selAry.count>0) {
           BOOL isExist = [selAry containsObject:firstobj];
            if (!isExist) {
                [selAry addObject:firstobj];
            }
        }
    }
    else{
        if (selAry.count>0) {
           NSInteger i = [selAry indexOfObject:firstobj];
            if (i !=-1) {
                [selAry removeObjectAtIndex:i];
            }
        }
    }
    [self setShoppingCart:selbtn.selected spid:firstobj[@"JMSP_ID"]];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == totalArray.count) {
        return MAIN_SCREEN_WIDTH * 280/489 + 12;
    }else{
        NSDictionary * dic2 = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        NSArray *arr = dic2[@"CartInfoList"];
        NSDictionary *dic = arr[indexPath.row];
        if ([dic count] == 1) {
            if (dic[@"tis"]) {
                return 30;
            }else{
                return 40;
            }
        }else{
            return 105;
        }
    }
}

//设置头部的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 36.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == totalArray.count-1) {
        NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
        NSArray *temparry = arydic[@"CartInfoList"];
        float totalcount = 0.0f;
        if (temparry && temparry.count>0) {
            for (NSDictionary *tempdic in temparry) {
                NSString *pricestr = tempdic[@"LSDJ"];
                float price = [pricestr floatValue];
                totalcount = totalcount+price;
            }
        }
        MLBagFootView *footView = [[MLBagFootView alloc]initWithReuseIdentifier:FOOTER_IDENTIFIER];
        footView.countToPay.backgroundColor = [HFSUtility hexStringToColor:@"AE8E5D"];
        footView.countToPay.tag = section;
        [footView.countToPay addTarget:self action:@selector(paymentAction:) forControlEvents:UIControlEventTouchUpInside];
        [footView.checkBtn addTarget:self action:@selector(selectAllSectionGoods:) forControlEvents:UIControlEventTouchUpInside];
        BOOL isselAll = NO;
        for (int i=0; i<totalArray.count; i++) {
            int totalcount =0;
            NSArray *temparry = arydic[@"CartInfoList"];
            if (temparry && temparry.count>0) {
                for (NSDictionary *tempdic in temparry) {
                    NSString *selbj = tempdic[@"SELBJ"];
                    BOOL issel = [selbj boolValue];
                    if (issel) {
                        totalcount++;
                    }
                }
                if (totalcount==temparry.count) {
                    isselAll = YES;
                }
                else
                {
                    isselAll = NO;
                    break;
                }
            }
        }
        [footView.checkBtn setSelected:isselAll];
        
        
        footView.totalPriceLB.text = [NSString stringWithFormat:@"￥%.2f",totalcount];
        footView.totalShopCount.text = [NSString stringWithFormat:@"共%ld件商品，不含运费",temparry.count];
        return footView;
    }
    else{
        return nil;
 
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == totalArray.count) {
        HFSOrderListHeaderView *headerView = [[HFSOrderListHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER01];
        headerView.nameLabel.text = @"猜你喜欢";
        headerView.orderStatusLabel.hidden = YES;
        headerView.hidden = iseidtStatus;
        return headerView;
    }else{
        if (totalArray.count!=0) {
            MLBagHeaderView *headerView = [[MLBagHeaderView alloc]initWithReuseIdentifier:HEADER_IDENTIFIER ];
            NSDictionary * dic2 = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
            
            headerView.checkBox.tag = section;
            
            if (dic2[@"HWGCKMC"]) {
                [headerView.checkBox setTitle:[NSString stringWithFormat:@"  %@",dic2[@"HWGCKMC"]] forState:UIControlStateNormal|UIControlStateSelected];
                
                
            }
            NSArray *arys = dic2[@"CartInfoList"];
            int totalcount =0;
            if (arys && arys.count>0) {
                for (NSDictionary *tempdic in arys) {
                    NSString *selbj = tempdic[@"SELBJ"];
                    BOOL issel = [selbj boolValue];
                    if (issel) {
                        totalcount++;
                    }
                }
                if (totalcount==arys.count) {
                    [headerView.checkBox setSelected:YES];
                }
                else
                {
                    [headerView.checkBox setSelected:NO];

                }
            }
            [headerView.checkBox addTarget:self action:@selector(selAllGoods:) forControlEvents:UIControlEventTouchUpInside];
            return headerView;

        }
        return nil;
    }
    
}

#pragma table头部全选
-(void)selAllGoods:(id)sender
{
    UIButton *selbtn = (UIButton*)sender;
    selbtn.selected = !selbtn.selected;
    NSInteger section = selbtn.tag;
    
    NSDictionary *arydic = [totalArray objectForKey:[NSString stringWithFormat:@"%ld",section]];
    if (arydic[@"CartInfoList"]) {
        NSArray *arrys = (NSArray*)arydic[@"CartInfoList"];
        NSMutableString *srty = [NSMutableString string];
        for (NSDictionary *dic in arrys) {
            NSString *jid = dic[@"JMSP_ID"];
            [srty appendString:jid];
            [srty appendString:@","];
        }

        if (srty.length>1) {
            NSString *jsids = [srty substringToIndex:srty.length-1];
            [self setShoppingCart:selbtn.selected spid:jsids];
        }
    }
   
    
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
}
-(void)setShoppingCart:(int)selflag spid:(NSString*)spid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=selproductbath&flag=%i&jmsp_id=%@&ddly=0&ckdm=&userid=%@",SERVICE_GETBASE_URL, selflag,spid,userid];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSData 转NSString
                                      if (data && data.length>0) {
                                          NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"result is %@",result);
                                          if (![@"true" isEqualToString:result]) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [_hud show:YES];
                                                  _hud.mode = MBProgressHUDModeText;
                                                  _hud.labelText = @"请求失败";
                                                  [_hud hide:YES afterDelay:2];
                                              });
                                              
                                             
                                          }
                                          else{
                                              sectionkey = 0;
                                              [totalArray removeAllObjects];

                                              [self downLoadOrdinaryBag];

                                          }
                                         
                                      }
                                      
                                  }];
    
    [task resume];

    
    
    
}



//编辑的点击方法
- (void)editAction:(id)sender{
    UIBarButtonItem *btn = (UIBarButtonItem*)sender;
    if ([[btn title] isEqualToString:@"编辑"]) {
        [btn setTitle:@"完成"];
        
        iseidtStatus = YES;

    }
    else{
        [btn setTitle:@"编辑"];
        iseidtStatus = NO;

    }
    [_tableView reloadData];
}


@end

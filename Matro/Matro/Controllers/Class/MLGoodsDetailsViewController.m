//
//  MLGoodsDetailsViewController.m
//  Matro
//
//  Created by NN on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsDetailsViewController.h"
#import "RecommendCollectionViewCell.h"
#import "CPPhotoInfoViewController.h"
#import "MLGoodsDetailsTableViewCell.h"
#import "YAScrollSegmentControl.h"
#import "AppDelegate.h"
#import "HFSConstants.h"
#import "CPStepper.h"
#import "UIColor+HeinQi.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "HFSUtility.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "MLLoginViewController.h"
#import "MLSureViewController.h"
#import "MLBagViewController.h"


@interface UIImage (SKTagView)
+ (UIImage *)imageWithColor: (UIColor *)color;
@end

@interface MLGoodsDetailsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,YAScrollSegmentControlDelegate>{
    
    NSMutableArray *_imageArray;//轮播图数组
    
    NSMutableArray *_recommendArray;
    NSArray *_titleArray;//随机出现的商品属性选择的标题数组
    
    YAScrollSegmentControl *titleView;//标题上选择查看商品还是详情按钮
    NSString *userid;
    NSString *spid;
    NSString *weburl;
    BOOL isglobal;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;//最底层的SV
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontrol;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingmuW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingmuH;

@property (strong, nonatomic) IBOutlet UIScrollView *pingmu1rootScrollView;//第一页的SV商品页
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) IBOutlet UILabel *biaotiLabel;//标题
@property (strong, nonatomic) IBOutlet UILabel *texingLabel;//特性
@property (strong, nonatomic) IBOutlet UILabel *jiageLabel;//价格
@property (strong, nonatomic) IBOutlet UILabel *yuanjiaLabel;//原价
@property (strong, nonatomic) IBOutlet UIButton *shoucangButton;//收藏按钮
@property (strong, nonatomic) IBOutlet UILabel *yuanchandiLabel;//原产地

@property (strong, nonatomic) IBOutlet UIView *kujingBgView;//跨境商品显示选项的主视图，是跨境商品的时候显示且zengpinTH = 120 不是的时候隐藏且 zengpinTH = 0
@property (strong, nonatomic) IBOutlet UILabel *shuilvLabel;//跨境商品有的税率
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *zengpinTH;//跨境 = 120，正常 = 0

@property (strong, nonatomic) IBOutlet UILabel *huodongLabel;//活动
@property (strong, nonatomic) IBOutlet UIImageView *zengpImageView;//赠品图片
@property (strong, nonatomic) IBOutlet UILabel *zengpinnameLabel;//赠品文字
@property (strong, nonatomic) IBOutlet UILabel *cuxiaoxinxiLabel;//促销信息

@property (strong, nonatomic) IBOutlet UITableView *tableView;//选择商品类型，应该是类似于大小颜色之类的，cell应是随机标题+随机的选项按钮（未完成）
@property (strong, nonatomic) IBOutlet UILabel *kuncuntisLabel;//库存
@property (strong, nonatomic) IBOutlet CPStepper *shuliangStepper;
@property (strong, nonatomic) IBOutlet UIView *pingjiaView;//遍历这个View,来修改星星图片 tag 101~105
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *likeH;//猜你喜欢的collectionView的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tisH;

@property (strong, nonatomic) IBOutlet UIWebView *webView;//图文详情，加在第二页
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kuajingHeight;

@end

@implementation MLGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleView = [[YAScrollSegmentControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 20, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.tintColor = [UIColor clearColor];
    titleView.buttons = @[@"商    品",@"图文详情"];
    [titleView setTitleColor:[UIColor colorWithHexString:@"AE8E5D"] forState:UIControlStateSelected];
    [titleView setTitleColor:[UIColor colorWithHexString:@"0E0E0E"] forState:UIControlStateNormal];
    [titleView setBackgroundImage:[UIImage imageNamed:@"sel_type_g"] forState:UIControlStateSelected];
    [titleView setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
    titleView.delegate = self;
    self.navigationItem.titleView = titleView;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    
    // 一期隐藏
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
//    self.navigationItem.rightBarButtonItem = shareButton;
    
    _imageScrollView.delegate = self;
    _imageArray = [[NSMutableArray alloc] init];
    
    //设置SV1 上拉加载
    
    MJRefreshAutoStateFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
            titleView.selectedIndex = 1;
        } completion:^(BOOL finished) {
            //结束加载
            [_pingmu1rootScrollView.footer endRefreshing];
        }];
        
    }];
    [footer setTitle:@"点击或继续拖动，查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载失败" forState:MJRefreshStateNoMoreData];
    _pingmu1rootScrollView.footer = footer;
    
    
    //设置SV2 有下拉操作
    
    MJRefreshStateHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            //下拉执行对应的操作
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
            titleView.selectedIndex = 0;
        } completion:^(BOOL finished) {
            //结束加载
            [_webView.scrollView.header endRefreshing];
        }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"点击或继续拖动返回" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即返回" forState:MJRefreshStatePulling];
    [header setTitle:@"加载失败" forState:MJRefreshStateNoMoreData];
    
    
    [self.shoucangButton addTarget:self action:@selector(addFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    _webView.scrollView.header = header;
    [self loadDateProDetail];
    [self guessYLike];
}
-(void)addFavorite
{
    
}

#pragma mark 获取商品详情数据
- (void)loadDateProDetail {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@ajax/app/index.ashx?op=prodetail&jmsp_id=%@&zcsp=%@",SERVICE_GETBASE_URL,_paramDic[@"JMSP_ID"],_paramDic[@"ZCSP"]];
    
    [[HFSServiceClient sharedJSONClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if (dic && dic[@"SpXqInfo"] && dic[@"SpXqInfo"]!=[NSNull null]) {
            NSLog(@"return dic %@",dic);
            NSDictionary *tempdic = dic[@"SpXqInfo"];
            if (tempdic[@"JMSP_ID"] && tempdic[@"JMSP_ID"] !=[NSNull null]) {
                spid = dic[@"SpXqInfo"][@"JMSP_ID"];

            }
            self.biaotiLabel.text = dic[@"SpXqInfo"][@"NAMELIST"][@"2"];
            self.texingLabel.text = dic[@"SpXqInfo"][@"NAMELIST"][@"3"];
            self.jiageLabel.text = dic[@"SpXqInfo"][@"LSDJ"];
            self.yuanjiaLabel.text = dic[@"SpXqInfo"][@"XJ"];
            self.shuilvLabel.text = dic[@"SpXqInfo"][@"SL"];
            if ([dic[@"SpXqInfo"][@"GSSL"] isEqualToString:@"0"]) {
                self.kujingBgView.hidden = YES;
                self.kuajingHeight.constant = 0;
                isglobal = NO;
            }
            else{
                self.kujingBgView.hidden = NO;
                self.kuajingHeight.constant = 120;
                isglobal = YES;
            }
        }
        if (dic && dic[@"SpmsInfo"] && dic[@"SpmsInfo"] !=[NSNull null]) {

            NSDictionary *tempdic2 = dic[@"SpmsInfo"];
            if (tempdic2[@"MS"] && tempdic2[@"MS"] !=[NSNull null]) {
                weburl = tempdic2[@"MS"];
            }
        }
        
            _imageArray = dic[@"SptpList"];
            [self imageUIInit];
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _pingmuH.constant = MAIN_SCREEN_HEIGHT - 64 - 45;
    _pingmuW.constant = MAIN_SCREEN_WIDTH;
    
    //根据接口换地址
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]];
    [_webView loadRequest:request];
    
    _recommendArray = [[NSMutableArray alloc] init];
    _titleArray = @[@"货       源：",@"阶       段："];
    
   
    
}

- (void)guessYLike {
    NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/order/shoppingcart.ashx?op=getcnxh&spsl=6",SERVICE_GETBASE_URL];
    [[HFSServiceClient sharedClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject)
        {
            NSArray *arr = (NSArray *)responseObject;
            if (arr && arr.count>0) {
                [_recommendArray addObjectsFromArray:arr];
            }
        }
        NSInteger row = (((_recommendArray.count / 3) >= 1 ? (_recommendArray.count / 3) + ((_recommendArray.count % 3 == 0)? 0 : 1) : 1));
        
        CGRect rect = [UIScreen mainScreen].bounds;
        
        if (_recommendArray.count != 0) {
            _likeH.constant = 157*row;
//            _likeH.constant = (row + 1) * 10 + row *((MAIN_SCREEN_WIDTH - 5 * 10)/3/(rect.size.width/3)*157);
        }else{
            _likeH.constant = 0;
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"猜你喜欢 请求失败";
        [_hud hide:YES afterDelay:2];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 立即购买
- (IBAction)buyAction:(id)sender {
  
    [self addShoppingBag:nil];
    [self getAppDelegate].tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
}
#pragma mark 加入购物袋
- (IBAction)addShoppingBag:(id)sender {

    if (userid) {
        NSString *urlStr = [NSString stringWithFormat:@"%@Ajax/products.ashx?op=addcart&jmsp_id=%@&spsl=1&&userid=%@",SERVICE_GETBASE_URL,spid,userid];
        
        [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"加入购物袋 请求成功");
                    NSDictionary *dic = (NSDictionary *)responseObject;
                    NSLog(@"%@",dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:2];
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
   
}

#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLLoginViewController *vc = [[MLLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 分享按钮
-(void)shareButtonAction{
    
}

#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
    
    for(int i = 0; i<_imageArray.count; i++) {
        if ([_imageArray[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i][@"URL"]] placeholderImage:[UIImage imageNamed:@"imageloading"]];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [imageview addGestureRecognizer:singleTap];
        [_imageScrollView addSubview:imageview];
    }
    
    _imageScrollView.contentSize = CGSizeMake(imageScrollViewWidth*_imageArray.count, 0);
    _imageScrollView.bounces = NO;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.delegate = self;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    _pagecontrol.numberOfPages = _imageArray.count;

}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",tap.view.tag);
    
    CPPhotoInfoViewController * vc = [[CPPhotoInfoViewController alloc]init];
    
    vc.bigPhotoImageArray =_imageArray;
    vc.bigPhotoImageNum = tap.view.tag;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _imageScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        _pagecontrol.currentPage = i - 1;
    }
    
//    if (scrollView == _dataWebView.scrollView) {
//        if (scrollView.contentOffset.y > _dataWebView.scrollView.frame.size.height) {
//            _backToTopView.hidden = NO;
//        } else {
//            _backToTopView.hidden = YES;
//        }
//    }
}

- (IBAction)bagButtonAction:(id)sender {
    [self getAppDelegate].tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- 购买须知
- (IBAction)xuzhiAction:(id)sender {
    
}

#pragma mark- YAScrollSegmentControlDelegate
- (void)didSelectItemAtIndex:(NSInteger)index;{
    NSLog(@"%ld------------------------------+++",index);
    if (titleView.selectedIndex == index) {
        return;
    }else{
        if (index == 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                //下拉执行对应的操作
                self.mainScrollView.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                //结束加载
                [_webView.scrollView.header endRefreshing];
            }];

        }else{
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
            } completion:^(BOOL finished) {
                //结束加载
                [_pingmu1rootScrollView.footer endRefreshing];
            }];
            
        }
    }

}

#pragma end mark YAScrollview代理方法结束

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //    webView.scrollView.scrollEnabled = NO;
//    webView.scrollView.bounces = NO;
//    _dataWebView.scrollView.delegate = self;
//    _infoBgviewHConstraint.constant = webView.scrollView.contentSize.height + 30;
//    _webRootScrollView.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH, _infoBgviewHConstraint.constant);
//    _webRootSHConstraint.constant = MAIN_SCREEN_HEIGHT - 114;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
//    _infoBgviewHConstraint.constant = 30;
}


#pragma mark- UICollectionViewDataSource And UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _recommendArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RecommendCollectionViewCell" ;
    
    UINib *nib = [UINib nibWithNibName:@"RecommendCollectionViewCell"bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    RecommendCollectionViewCell * cell = (RecommendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *paramdic = [_recommendArray objectAtIndex:indexPath.row];
    cell.productNameLabel.text = paramdic[@"SPNAME"];
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:paramdic[@"IMGURL"]] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MAIN_SCREEN_WIDTH - 5 * 10)/3, (MAIN_SCREEN_WIDTH - 5 * 10)/4/101*157);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *CellIdentifier = @"MLGoodsDetailsTableViewCell" ;
    MLGoodsDetailsTableViewCell *cell = (MLGoodsDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    cell.infoTitleLabel.text = _titleArray[indexPath.row];

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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



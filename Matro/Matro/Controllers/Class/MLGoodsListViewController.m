//
//  MLGoodsListViewController.m
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsListViewController.h"
#import "MLGoodsDetailsViewController.h"
#import "MLSXView.h"

#import "HFSProductTableViewCell.h"
#import "HFSProductCollectionViewCell.h"

#import "HFSConstants.h"
#import "UIButton+HeinQi.h"
#import "UIColor+HeinQi.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "MLClassInfo.h"
#import "UIImageView+WebCache.h"

#import "MJRefresh.h"

#define SEARCH_PAGE_SIZE @10
#define HFSProductTableViewCellIdentifier @"HFSProductTableViewCellIdentifier"
#define HFSProductCollectionViewCellIdentifier @"HFSProductCollectionViewCellIdentifier"
#define CollectionViewCellMargin 10.0f

@interface MLGoodsListViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,NNSXDelegate,UITextFieldDelegate>{
    NSMutableArray *_productList;//当前商品列表的原数组，collectionView和tableView都共用
    BOOL _isCardView;//判断是否当前显示的是tableView还是collectionView
    
    UIControl * _blackControl;//显示分类筛选的时候黑底背景
    MLSXView * _sxView;//分类筛选的视图
    UITextField *searchText;
    NSDictionary *filterparamDic;
}
@property (strong, nonatomic) IBOutlet UIButton *xiaoliangButton;//销量排序
@property (strong, nonatomic) IBOutlet UIButton *jiageButtton;//价格排序
@property (strong, nonatomic) IBOutlet UIButton *shaixuanButton;//筛选
@property (strong, nonatomic) IBOutlet UIButton *changeButton;//更改显示方式，列表、卡片
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MLGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    _productList = [[NSMutableArray alloc]init];
    
    _isCardView = NO;//起始默认显示列表式
    
    [_tableView registerNib:[UINib nibWithNibName:@"HFSProductTableViewCell" bundle:nil] forCellReuseIdentifier:HFSProductTableViewCellIdentifier];
    [_tableView setTableFooterView:[[UIView alloc]init]];
    [_collectionView registerNib:[UINib  nibWithNibName:@"HFSProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HFSProductCollectionViewCellIdentifier];
    
    _tableView.header = [self refreshHeaderWith:_tableView];
    _collectionView.header = [self refreshHeaderWith:_collectionView];
    
    _tableView.footer = [self loadMoreDataFooterWith:_tableView];
    _collectionView.footer = [self loadMoreDataFooterWith:_collectionView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self reloadData];
    [self goodsListUI];
    if (_filterParam) {
        [self getGoodsFromClass];
    }
    if (_searchString) {
        [self getGoodsListByIndex:1];
    }
}

-(void)getGoodsFromClass
{
    NSString *str = [NSString stringWithFormat:@"%@ajax/Common/WebFrame.ashx?op=products&webframecode=%@&spsl=20",SERVICE_GETBASE_URL,_filterParam[@"WebrameCode"]];
    NSLog(@"搜索的商品URL：%@",str);
    [[HFSServiceClient sharedClient] GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject) {
            NSArray *dic = (NSArray *)responseObject;
            //NSLog(@"+++dic:%@---",dic[0]);
            if (dic && dic.count>0) {
                [_productList addObjectsFromArray:dic];
            }
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
}

#pragma mark 搜索关键字获取数据
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)goodsListUI{
    
    //添加边框和提示
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 28)];
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    CGFloat H = frameView.bounds.size.height - 8;
    CGFloat imgW = H;
    CGFloat textW = frameView.bounds.size.width - imgW - 6;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Magnifying-Class"]];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(imgW + 4, 2, textW, H)];
    //searchText.enabled = NO;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.delegate = self;
    [frameView addSubview:searchImg];
    [frameView addSubview:searchText];
    searchImg.frame = CGRectMake(4 , 4, imgW, imgW);
    searchText.frame = CGRectMake(imgW + 6, 4, textW, H);
    searchText.textColor = [UIColor grayColor];
    searchText.placeholder = @"寻找你想要的商品";
    searchText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    if (_searchString) {
        searchText.text = _searchString;
    }
    
    self.navigationItem.titleView = frameView;
    
    
    UIBarButtonItem *button =[[UIBarButtonItem alloc]initWithTitle:@"  " style: UIBarButtonItemStylePlain target:self action:@selector(nothingAction)];
    
    self.navigationItem.rightBarButtonItem = button;
    
    [_jiageButtton changeImageAndTitle];
    [_jiageButtton setImage:[UIImage imageNamed:@"jiage_arrow"] forState:UIControlStateNormal];
    [_jiageButtton setImage:[UIImage imageNamed:@"jiage_arrow_shang"] forState:UIControlStateSelected];
    
    [_shaixuanButton changeImageAndTitle];
    
    [_changeButton setImage:[UIImage imageNamed:@"kapianmoshi-3"] forState:UIControlStateNormal];
    [_changeButton setImage:[UIImage imageNamed:@"Starred-List"] forState:UIControlStateSelected];
    
    
    _blackControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH ,MAIN_SCREEN_HEIGHT)];
    _blackControl.backgroundColor = [UIColor blackColor];
    _blackControl.alpha = 0.4;
    _blackControl.hidden = YES;
    [_blackControl addTarget:self action:@selector(endEditingAction) forControlEvents:UIControlEventTouchUpInside];
    
    //    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MLSXView" owner:nil options:nil];
    _sxView = [[MLSXView alloc]init];
    _sxView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
    _sxView.delegate = self;
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackControl];
    [currentWindow addSubview:_sxView];
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [_sxView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

-(void)nothingAction{
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_sxView endEditing:YES];
}

#pragma mark- 刷新相关
//根据_isCardView来判断是_tableView还是_collectionView开始刷新
-(void)reloadData {
    if (_isCardView) {
        [_collectionView reloadData];
        [_collectionView.header beginRefreshing];
    } else {
        [_tableView.header beginRefreshing];
    }
}

-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#warning 先加分页index，之后还会加别的
- (void)getGoodsListByIndex:(NSInteger)index{
    if (_searchString) {
        if ([self IsChinese:_searchString]) {
            _searchString = [_searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        }
    }
    else
    {
        _searchString=@"";
    }
    //XSSL&false（销量）
    //    XJ&true（价格正序）
    //    XJ&false（价格倒序）
    NSString *isck=@"";
    NSString *isgloble=@"";
    NSString *spflcode =@"";
    NSString *sortstr = @"";
    NSString *spsbstr = @"";
    NSString *jgs = @"";
    NSString *jge = @"";
    if (filterparamDic) {
        if ([filterparamDic objectForKey:@"sortstr"]) {
            sortstr = [filterparamDic objectForKey:@"sortstr"];
        }
        if ([filterparamDic objectForKey:@"iskc"]) {
            isck = [filterparamDic objectForKey:@"iskc"];
        }
        if ([filterparamDic objectForKey:@"zcsp"]) {
            isgloble = [filterparamDic objectForKey:@"zcsp"];
        }
        if ([filterparamDic objectForKey:@"spflcode"]) {
            spflcode = [filterparamDic objectForKey:@"spflcode"];
        }
        
        if ([filterparamDic objectForKey:@"spsb"]) {
            spsbstr =[filterparamDic objectForKey:@"spsb"];
            spsbstr = [spsbstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        }
        if ([filterparamDic objectForKey:@"jgs"]) {
            jgs =[filterparamDic objectForKey:@"jgs"];
        }
        if ([filterparamDic objectForKey:@"jge"]) {
            jge =[filterparamDic objectForKey:@"jge"];
        }
    }
    if (sortstr && ![@"" isEqualToString:sortstr]) {

    }
    //SPSB 品牌名称 sort 是字符串  jgs开始价格，jpe 结束价格
    
//    NSString *paramstr = [NSString stringWithFormat:@"op=item_sp&spflcode=%@&tpgg=M&sort=%@&spsb=%@&pagesize=20&pageindex=%ld&key=%@&jgs=%@&jge=%@&iskc=%@&zcsp=%@",SERVICE_GETBASE_URL,spflcode,sortstr,spsbstr, index,_searchString,jgs,jge,isck,isgloble];
    
    NSString *str = [NSString stringWithFormat:@"%@Ajax/search/search.ashx?op=item_sp&spflcode=%@&tpgg=M&sort=%@&spsb=%@&pagesize=20&pageindex=%ld&key=%@&jgs=%@&jge=%@&iskc=%@&zcsp=%@",SERVICE_GETBASE_URL,spflcode,sortstr,spsbstr, index,_searchString,jgs,jge,isck,isgloble];

    [[HFSServiceClient sharedJSONClient] GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (index==1) {
            [_productList removeAllObjects];

        }

        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSArray *ary = (NSArray *)responseObject;
            if (ary && ary.count>0) {
                
                [_productList addObjectsFromArray:ary];
            }
        }
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];

}
-(NSString*)UrlValueEncode:(NSString*)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)str,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}


-(MJRefreshNormalHeader *)refreshHeaderWith:(UIScrollView *)scrollView {
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [scrollView.header endRefreshing];
        
    }];
    
    return refreshHeader;
}

-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [scrollView.footer endRefreshing];
    }];
    
    return loadMoreFooter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endEditingAction{
    [_sxView endEditing:YES];
}

#pragma mark- 功能按钮  销量、价格、筛选、切换
- (IBAction)listButtonAction:(id)sender {
    UIButton *button  = (UIButton * )sender;
    if (!filterparamDic) {
        filterparamDic = [NSMutableDictionary new];
    }
    NSString *typeStr = button.titleLabel.text;
    
    if ([typeStr isEqualToString:@"销量"]) {
        button.selected = !button.selected;
        if (button.selected) {
            [filterparamDic setValue:@"XSSL%26false" forKey:@"sortstr"];
        }
        else{
            [filterparamDic setValue:@"XSSL%26true" forKey:@"sortstr"];
        }
        [self getGoodsListByIndex:1];
    }else if ([typeStr isEqualToString:@"品牌"]){
        button.selected = !button.selected;
        NSString *urlStr = [NSString stringWithFormat:@"http://www.matrojp.com/Ajax/search/search.ashx?op=5&spflcode=&jgcount=5"];
        [[HFSServiceClient sharedClientNOT] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"价格筛选 请求成功");
            NSDictionary *result = (NSDictionary *)responseObject;
            NSLog(@"%@",result);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"价格筛选 请求失败");
            
        }];
        [self reloadData];
    }
    else if([typeStr isEqualToString:@"价格"])
    {
        button.selected = !button.selected;
        if (button.selected) {
            [filterparamDic setValue:@"XJ%26false" forKey:@"sortstr"];
        }
        else{
            [filterparamDic setValue:@"XJ%26true" forKey:@"sortstr"];
            
        }
        [self getGoodsListByIndex:1];

    }
    else if ([typeStr isEqualToString:@"筛选"]){
        button.selected = !button.selected;
        [UIView animateWithDuration:0.5 animations:^{
            if (_sxView.frame.origin.x == MAIN_SCREEN_WIDTH) {
                _sxView.frame = CGRectMake(60, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
                _blackControl.hidden = NO;
            }else{
                _sxView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
                _blackControl.hidden = YES;
            }
            _sxView.keywords = searchText.text;
        }];
    }else{//切换显示
        button.selected = !button.selected;
        if (_isCardView) {
            _tableView.hidden = NO;
            _collectionView.hidden = YES; 
        } else {
            _tableView.hidden = YES;
            _collectionView.hidden = NO;
        }
        _isCardView = !_isCardView;
        [self reloadData];
    }
    
}


#pragma mark - UITableViewDelegate and  UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    NSDictionary *paramdic = _productList[indexPath.row];
    vc.paramDic = paramdic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _productList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFSProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HFSProductTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[HFSProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HFSProductTableViewCellIdentifier];
    }
    NSDictionary *tempdic = _productList[indexPath.section];
    if (tempdic) {
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:tempdic[@"IMGURL"]]];
        if (_filterParam) {
            cell.productNameLabel.text =tempdic[@"SPNAME"];
        }
        else{
            cell.productNameLabel.text =tempdic[@"NAME"];
        }
        
        cell.currentPriceLabel.text =[NSString stringWithFormat:@"￥%@",tempdic[@"XJ"]] ;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDataSource and  UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _productList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFSProductCollectionViewCell *cell = (HFSProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HFSProductCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempdic = _productList[indexPath.row];
    
    [cell.productImgview sd_setImageWithURL:[NSURL URLWithString:tempdic[@"IMGURL"]]];
    cell.productnameLb.text =tempdic[@"NAME"];
    cell.priceLb.text =[NSString stringWithFormat:@"￥%@",tempdic[@"XJ"]] ;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLGoodsDetailsViewController * vc = [[MLGoodsDetailsViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (collectionView.bounds.size.width - 3 * CollectionViewCellMargin) / 2;
    float height = width / 290 * 408;
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(CollectionViewCellMargin, CollectionViewCellMargin, CollectionViewCellMargin, CollectionViewCellMargin);
}

#pragma mark- NNSXDelegate 筛选后重新call接口
- (void)blackAction:(NSDictionary*)paramdic{
    [UIView animateWithDuration:0.5 animations:^{
        if (_sxView.frame.origin.x == MAIN_SCREEN_WIDTH) {
            _sxView.frame = CGRectMake(60, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
            _blackControl.hidden = NO;
        }else{
            _sxView.frame = CGRectMake(MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH - 60, MAIN_SCREEN_HEIGHT);
            _blackControl.hidden = YES;
        }
        _sxView.keywords = searchText.text;
    }];
    filterparamDic = paramdic;
    [self getGoodsListByIndex:1];
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    [aTextfield resignFirstResponder];
    [self reloadData];
    return YES;
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

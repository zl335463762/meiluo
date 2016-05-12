//
//  MLSearchViewController.m
//  Matro
//
//  Created by hyk on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSearchViewController.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "HFSUtility.h"
#import "UIImage+HeinQi.h"
#import "UIColor+HeinQi.h"
#import "MLGoodsListViewController.h"
#import "SearchHistory.h"
#import <DWTagList/DWTagList.h>
#import <MagicalRecord/MagicalRecord.h>

@interface MLSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DWTagListDelegate>
{
    
    NSMutableArray *_historySearchTextArray;//搜索历史的数组，用于保存热门搜索历史
    
    DWTagList *_hotSearchTagList;//标签控件，标签的形式显示热门列表
    
    NSManagedObjectContext *_context;
    NSMutableArray *hotSearchArray;
}
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *hotSearchTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotSearchTagHeightConstraint;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;//用于显示历史记录的tableview
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvH;

@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;


@end
static CGFloat kHeight = 0;


@implementation MLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44)];
    _searchBar.placeholder = @"寻找你想要的商品";
    _searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    hotSearchArray = [NSMutableArray new];
    //弹出系统键盘
    [_searchBar becomeFirstResponder];
    
    //返回按钮
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Left_Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction :)];
    self.navigationItem.leftBarButtonItem = returnBtn;
    
    //扫描按钮
    //    UIBarButtonItem *scan = [[UIBarButtonItem alloc] init];
    //    scan.image = [UIImage imageNamed:@"shouyesaoyisao"];
    //
    //    self.navigationItem.rightBarButtonItem = scan;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_rootScrollView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    _context = [NSManagedObjectContext MR_defaultContext];
    
    //历史
    [self loadSearchHistory];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    //热门搜索

    self.clearBtn.layer.borderWidth =0.5;
    self.clearBtn.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    [self gethotKeywords];
}

//隐藏键盘
- (void) hideKeyboard {
    [_searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(DWTagList *)styleTagList:(DWTagList *)tagList {
    
    tagList.font = [UIFont systemFontOfSize:14.0f];
    tagList.borderColor = [UIColor colorWithHexString:@"#EBEBEB"];
    tagList.textColor = [UIColor colorWithHexString:@"#505050"];
    tagList.labelMargin = 6.0f;
    [tagList setTagBackgroundColor:[UIColor whiteColor]];
    tagList.cornerRadius = 1.0f;
    tagList.horizontalPadding = 6.0f;
    tagList.verticalPadding = 6.0f;
    
    return tagList;
}

-(void)gethotKeywords
{
    NSString *str = [NSString stringWithFormat:@"%@/ajax/CommonControl/Header.ashx?op=hotkeyword&spsl=9",@"http://www.matrojp.com"];
    
    [[HFSServiceClient sharedClient] GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSArray *dic = (NSArray *)responseObject;
            int i=0;
            if (dic && dic.count>0) {
                for (NSDictionary *tempidc in dic) {
                    if (i>20) {
                        break;
                    }
                    [hotSearchArray addObject:tempidc[@"KEYWORD"]];
                    i++;
                }
                _hotSearchTagList = [[DWTagList alloc]initWithFrame:CGRectMake(12, 0, MAIN_SCREEN_WIDTH - 24, 35)];
                _hotSearchTagList.tagDelegate = self;
                _hotSearchTagList = [self styleTagList:_hotSearchTagList];
                [_hotSearchTagList setTags:hotSearchArray];
                [_hotSearchTagView addSubview:_hotSearchTagList];
                _hotSearchTagHeightConstraint.constant = _hotSearchTagList.contentSize.height;
                [self.view layoutIfNeeded];
                _hotSearchTagList.frame = _hotSearchTagView.bounds;
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:2];
    }];
    
}


//加载搜索历史纪录
- (void)loadSearchHistory {
    
    NSArray *historySearchArray = [SearchHistory MR_findAllInContext:_context];
    _historySearchTextArray = [NSMutableArray array];
    for (SearchHistory *searchHistory in historySearchArray) {
        [_historySearchTextArray addObject:searchHistory.keywork];
    }
    _tbvH.constant = _historySearchTextArray.count * 30;
    [_historyTableView reloadData];
}

//清除搜索历史纪录
- (IBAction)clearSearchHistoryAction:(id)sender {
    
    [SearchHistory MR_truncateAllInContext:_context];
    [self loadSearchHistory];
}


- (void) hide {
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}

//返回的方法(就是把他隐藏起来)
-(void)returnAction:(UISearchBar *)searchBar {
    [self hide];
}

#pragma mark- UISearchBarDelegate
//点击键盘上的search按钮时调用
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    [searchBar resignFirstResponder];
    //    searchBar.showsCancelButton = NO;
    if (![searchTerm isEqualToString:@""])
    {
        
        SearchHistory *searchHistory = [SearchHistory MR_createEntityInContext:_context];
        searchHistory.keywork = searchBar.text;
        
        [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            [self loadSearchHistory];
        }];
        //隐藏就是关闭当前的搜索的页面
        [self hide];
        //将搜索框的值带回上一个页面
        [_delegate SearchText:searchTerm];

    }
}
//输入文本实时更新时调用
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    if (searchText.length == 0) {
        return;
    }
}

//点击搜索框时调用
- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //    searchBar.showsCancelButton = YES;
}

#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _historySearchTextArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.textLabel.text = _historySearchTextArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self hide];
    //点击当前的搜索历史，将当前的文字带回上一个页面
    [_delegate SearchText:_historySearchTextArray[indexPath.row]];
    
}

#pragma mark - DWTagListDelegate

- (void)selectedTag:(NSString *)tagName;{
    [self hide];
    SearchHistory *searchHistory = [SearchHistory MR_createEntityInContext:_context];
    searchHistory.keywork = tagName;
    
    [_context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [self loadSearchHistory];
    }];
    [_delegate SearchText:tagName];
    
}



- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}



///键盘显示事件
- (void)keyboardWasShown:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    //将视图上移计算好的偏移
    if (_historySearchTextArray.count>5) {
        [UIView animateWithDuration:0.1 animations:^{
            kHeight = kbHeight;
            CGSize size = self.rootScrollView.contentSize;
            self.rootScrollView.contentSize = CGSizeMake(size.width,size.height+kbHeight);
        }];
    }
    
}

///键盘消失事件
- (void)keyboardWillBeHidden:(NSNotification *)notify {
    //视图下沉恢复原状
    if (kHeight>0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGSize size = self.rootScrollView.contentSize;
            self.rootScrollView.contentSize = CGSizeMake(size.width,size.height-kHeight);
            kHeight = 0;
            
        }];
    }
 
}





@end

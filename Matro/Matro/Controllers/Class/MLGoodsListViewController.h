//
//  MLGoodsListViewController.h
//  Matro
//
//  Created by NN on 16/3/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLGoodsListViewController : MLBaseViewController

@property (nonatomic) NSString *searchString;//上一个页面传过来的搜索文字


@property (nonatomic,retain) NSDictionary *filterParam;

@end

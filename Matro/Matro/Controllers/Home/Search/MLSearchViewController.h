//
//  MLSearchViewController.h
//  Matro
//
//  Created by hyk on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@protocol SearchDelegate <NSObject>
- (void)SearchText:(NSString *)text;
@end

@interface MLSearchViewController : MLBaseViewController

@property (nonatomic, weak) UIViewController *activeViewController;

@property (assign,nonatomic,readwrite)id <SearchDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

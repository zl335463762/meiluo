//
//  MLServiceMainController.m
//  Matro
//
//  Created by 黄裕华 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLServiceMainController.h"
#import "MLReturnsViewController.h"
#import "MLAfterSaleViewController.h"

@interface MLServiceMainController ()

@end

@implementation MLServiceMainController

- (instancetype)init
{
    if (self = [super init])
    {
        self.menuViewStyle                   = WMMenuViewStyleLine;
        self.titleColorSelected              = RGBA(174, 142, 93, 1);
        self.titleColorNormal                = RGBA(14, 14, 14, 1);
        self.progressColor                   = RGBA(174, 142, 93, 1);
        self.titleSizeSelected               = 16;
        self.pageAnimatable                  = YES;
        self.titleSizeNormal                 = 16;
        self.menuHeight                      = 37;
        self.menuItemWidth                   = MAIN_SCREEN_WIDTH/2;
        self.postNotification                = YES;
        self.itemMargin                      = 0.f;
        self.bounces                         = NO;
        self.menuBGColor                     = [UIColor whiteColor];
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 2; i++) {
            Class vcClass;
            NSString *title;
            switch (i%2) {
                case 0:
                    vcClass = [MLReturnsViewController class];
                    title = @"申请退货";
                    break;
                case 1:
                    vcClass = [MLAfterSaleViewController class];
                    title = @"售后记录";
                    break;
                default:
                    break;
            }
            [viewControllers addObject:vcClass];
            [titles addObject:title];
        }
        self.viewControllerClasses = viewControllers;
        self.titles = titles;
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务";
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    self.viewFrame = CGRectMake(0, 8, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-10);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

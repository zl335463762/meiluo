//
//  MNNModifyNameViewController.h
//  Matro
//
//  Created by benssen on 16/3/28.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@class MNNModifyNameViewController;

@protocol MNNModifyNameViewControllerDelegate <NSObject>

- (void)MNNModifyNameViewController:(MNNModifyNameViewController*)ViewControlle userName:(NSString *)userName;

@end


@interface MNNModifyNameViewController : MLBaseViewController

@property (nonatomic,weak)id<MNNModifyNameViewControllerDelegate>delegate;

@end

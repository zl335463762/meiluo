//
//  MLFeedbackViewController.m
//  Matro
//
//  Created by 陈文娟 on 16/5/5.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLFeedbackViewController.h"

@interface MLFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *optionView;
@property (weak, nonatomic) IBOutlet UILabel *viewHolder;

@end

@implementation MLFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _contentView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    
    _contentView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
{
    
    _viewHolder.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        _viewHolder.hidden = NO;
        
    }
    
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

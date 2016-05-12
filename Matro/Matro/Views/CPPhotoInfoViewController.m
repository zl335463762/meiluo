//
//  PhotoInfoViewController.m
//  AlbumDome
//
//  Created by GK-Mac on 15/4/15.
//  Copyright (c) 2015年 HeinQi. All rights reserved.
//

#import "CPPhotoInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HFSConstants.h"

//#define SelfViewWidth   [UIScreen mainScreen].bounds.size.width
//#define SelfViewHeight  [UIScreen mainScreen].bounds.size.height

@interface CPPhotoInfoViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>{
    BOOL isChanger;//YES放大NO缩小
    UIActionSheet *imageActionSheet;
}
@property (nonatomic) UIScrollView *bgScrollView;
@property (nonatomic) UIButton *shareButton;
@property (nonatomic) UIImageView *bigPhotoImageView;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (strong, nonatomic) IBOutlet UILabel *photoInAlbumLabel;
@property (strong, nonatomic) IBOutlet UIView *photoBgView;

@end

@implementation CPPhotoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgScrollView = [[UIScrollView alloc] init];
    self.bgScrollView.frame = CGRectMake( 0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT );
    //去掉滚动条
    self.bgScrollView.showsVerticalScrollIndicator = FALSE;
    self.bgScrollView.showsHorizontalScrollIndicator = FALSE;
    self.bgScrollView.delegate = self;
    self.bgScrollView.bounces = NO;
    self.bgScrollView.pagingEnabled = YES;
    
    [self loadImageAction];
    
    [self.photoBgView addSubview:self.bgScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)lastPhotoAction:(id)sender {
//    if (self.bigPhotoImageNum - 1 >= 0) {
//        [self loadImageAction:self.bigPhotoImageNum -= 1];
//    }else{
//        self.bigPhotoImageNum = self.bigPhotoImageArray.count - 1;
//        [self loadImageAction:self.bigPhotoImageNum];
//    }
//}
//
//- (IBAction)nextPhotoAction:(id)sender {
//    if (self.bigPhotoImageNum + 1 < self.bigPhotoImageArray.count) {
//        [self loadImageAction:self.bigPhotoImageNum += 1];
//    }else{
//        self.bigPhotoImageNum = 0;
//        [self loadImageAction:self.bigPhotoImageNum];
//    }
//}

- (void)hiddenControl:(BOOL)hidden{
    if (hidden) {
        self.photoInAlbumLabel.hidden = YES;
//        self.photoInAlbumLabel.hidden = YES;
    }else{
        self.photoInAlbumLabel.hidden = NO;
//        self.photoInAlbumLabel.hidden = NO;
    }
}

- (void)loadImageAction {
//    [self.bigPhotoImageView removeFromSuperview];
    //开始动画
//    self.bigPhotoImageView = [[UIImageView alloc] init];
//    [self.bgScrollView addSubview: self.bigPhotoImageView];
    //    传单张image
    
    for (int i = 0; i < self.bigPhotoImageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.bigPhotoImageArray[i][@"URL"]] placeholderImage:[UIImage imageNamed:@"imageloading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGSize maxSize = CGSizeMake(MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
            CGFloat widthRatio = maxSize.width / image.size.width;
            CGFloat heightRatio = maxSize.height / image.size.height;
            CGFloat ratio = MIN(MIN(widthRatio, heightRatio), 1);
            
            CGFloat origin_x = MAX((MAIN_SCREEN_WIDTH - imageView.image.size.width * ratio)/2.0, 0);
            CGFloat origin_y = fabs(MAIN_SCREEN_HEIGHT - imageView.image.size.height * ratio)/2.0;
            
            imageView.frame = CGRectMake(origin_x + MAIN_SCREEN_WIDTH * i, origin_y, imageView.image.size.width * ratio, imageView.image.size.height * ratio);
            [self.bgScrollView addSubview:imageView];
        }];
    }
    
    self.bgScrollView.contentSize = CGSizeMake(self.bigPhotoImageArray.count * MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT) ;
    
    if (self.bigPhotoImageArray.count > 0) {
//
//        UIImageView * imageview =[[UIImageView alloc]init];
//        [imageview sd_setImageWithURL:[NSURL URLWithString:self.bigPhotoImageArray[imagePage]] placeholderImage:[UIImage imageNamed:@"imageloading"]];
//        
//        self.bigPhotoImage = imageview.image;
        self.photoInAlbumLabel.text = [NSString stringWithFormat:@"%d/%ld", 1 ,self.bigPhotoImageArray.count];//从1开始标号
        [self hiddenControl:NO];
    }else{
        [self hiddenControl:YES];
    }
//
//    [self loadImage:self.bigPhotoImage];
//
//    self.bigPhotoImageView.userInteractionEnabled = YES;
//    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTapAction)];
    [tap setNumberOfTapsRequired:1];
    [self.bgScrollView addGestureRecognizer:tap];
//
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoDoubleTapAction)];
//    [doubleTap setNumberOfTapsRequired:2];
//    [self.bigPhotoImageView addGestureRecognizer:doubleTap];
//    
//    [tap requireGestureRecognizerToFail:doubleTap];
//    
////    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(photoLongPressAction:)];
////    [self.bigPhotoImageView addGestureRecognizer:longPress];
//    
//    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPhotoAction:)];
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastPhotoAction:)];
//    
//    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    [self.bigPhotoImageView addGestureRecognizer:self.leftSwipeGestureRecognizer];
//    [self.bigPhotoImageView addGestureRecognizer:self.rightSwipeGestureRecognizer];
//    
//    isChanger = YES;

}

//- (void)loadImage:(UIImage *)postImage{
//    UIImage * image = postImage;
//    
//    // 重置UIImageView的Frame，让图片居中显示
//    CGFloat origin_x = fabs(self.bgScrollView.frame.size.width - image.size.width)/2.0;
//    CGFloat origin_y = fabs(self.bgScrollView.frame.size.height - image.size.height)/2.0;
//    self.bigPhotoImageView.frame = CGRectMake(origin_x, origin_y, image.size.width,image.size.height);
//    [self.bigPhotoImageView setImage:image];
//    
//    CGSize maxSize = self.bgScrollView.frame.size;
//    CGFloat widthRatio = maxSize.width/image.size.width;
//    CGFloat heightRatio = maxSize.height/image.size.height;
//    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
//    
//    [self.bgScrollView setMinimumZoomScale:initialZoom];
//    [self.bgScrollView setMaximumZoomScale:5];
//    // 设置UIScrollView初始化缩放级别
//    
//    [self.bgScrollView setZoomScale:initialZoom];
//    
//}

#pragma mark- UIScrollViewDelegate
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.bigPhotoImageView;
//    
//}
//
//// 让UIImageView在UIScrollView缩放后居中显示
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
//    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
//    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    self.bigPhotoImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                                scrollView.contentSize.height * 0.5 + offsetY);
//    isChanger = NO;
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    self.photoInAlbumLabel.text = [NSString stringWithFormat:@"%d/%ld", (int)(scrollView.contentOffset.x / MAIN_SCREEN_WIDTH) + 1 ,self.bigPhotoImageArray.count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- GestureRecognizerAction
- (void)photoTapAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoDoubleTapAction{
    if (isChanger) {
        self.bgScrollView.zoomScale = 5;
        [self hiddenControl:YES];
        isChanger = NO;
    }else{
        self.bgScrollView.zoomScale = 0;
        [self hiddenControl:NO];
        isChanger = YES;
    }
}


@end

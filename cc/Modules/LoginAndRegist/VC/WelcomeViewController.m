//
//  WelcomeViewController.m
//  cc
//
//  Created by wy on 2018/5/6.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import "BaseNavViewController.h"
#import "MainTabBarController.h"
@interface WelcomeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(KScreenWidth*3, KScreenHeight);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO; self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    NSArray *imgAry = @[@"yindao1.jpg",@"yindao2.jpg",@"yindao3.jpg"];
    MJWeakSelf
    for (NSInteger i = 0; i<imgAry.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight)];
        imgView.image = [UIImage imageNamed:imgAry[i]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.autoresizesSubviews = YES;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        [self.scrollView addSubview:imgView];
        
        if (i == 2) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            ViewBorderRadius(btn, 10, 0.6, [UIColor whiteColor]);
            btn.frame = CGRectMake(KScreenWidth/2-50, KScreenHeight-80, 100, 40);
            btn.titleLabel.font = Font_14;
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           
            imgView.userInteractionEnabled = YES;
            [imgView addSubview:btn];
           
            [btn addTapBlock:^(UIButton *btn) {
                
                [weakSelf enter];
                
            }];
        }
    }
    
    
    UIButton *hidenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   // ViewBorderRadius(hidenBtn, 10, 0.6, [UIColor whiteColor]);
    hidenBtn.frame = CGRectMake(KScreenWidth-80, 30, 70, 30);
    hidenBtn.titleLabel.font = Font_14;
    [hidenBtn setTitle:@"跳过 >>" forState:UIControlStateNormal];
    [hidenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:hidenBtn];
    
    [hidenBtn addTapBlock:^(UIButton *btn) {
          [weakSelf enter];
    }];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(KScreenWidth/2, KScreenHeight-80, 100, 50)];
    [self.pageControl setCurrentPage:0];
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];//未选中的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];//选中时的颜色
    
    [self.view addSubview:self.pageControl];
}


- (void)enter {
    BOOL flag = [SPUtil boolForKey:k_app_autologin];
    if (flag) {
        MainTabBarController *mainTabbar = [[MainTabBarController alloc] init];
        mainTabbar.selectIndex = 0;
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTabbar;
    }else {
        LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        
        BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }
}
#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算pagecontroll相应地页(滚动视图可以滚动的总宽度/单个滚动视图的宽度=滚动视图的页数)
    NSInteger currentPage = (int)(scrollView.contentOffset.x) / (int)(self.view.frame.size.width);
    self.pageControl.currentPage = currentPage;//将上述的滚动视图页数重新赋给当前视图页数,进行分页
    if (currentPage == 2) {
        self.pageControl.hidden = YES;
    }else {
        self.pageControl.hidden = NO;
    }
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

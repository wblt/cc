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
@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    MJWeakSelf
    for (NSInteger i = 0; i<2; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, KScreenHeight)];
        imgView.image = [UIImage imageNamed:@""];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.autoresizesSubviews = YES;
        imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        [self.scrollView addSubview:imgView];
        
        if (i == 1) {
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
    ViewBorderRadius(hidenBtn, 10, 0.6, [UIColor whiteColor]);
    hidenBtn.frame = CGRectMake(KScreenWidth-70, 30, 60, 30);
    hidenBtn.titleLabel.font = Font_14;
    [hidenBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [hidenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollView addSubview:hidenBtn];
    
    [hidenBtn addTapBlock:^(UIButton *btn) {
          [weakSelf enter];
    }];
    
    self.scrollView.contentSize = CGSizeMake(KScreenWidth*2, KScreenHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
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

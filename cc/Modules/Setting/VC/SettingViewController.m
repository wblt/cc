//
//  SettingViewController.m
//  cc
//
//  Created by wy on 2018/4/15.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginVC.h"
#import "BaseNavViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *buildNumLab;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    [self setup];
}

- (void)setup {
    ViewBorderRadius(_logoutBtn, 8, 0.6, UIColorFromHex(0x4B5461));
	
	// 获取系统版本号
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	CFShow(CFBridgingRetain(infoDictionary));
	
	 NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	_buildNumLab.text = app_Version;
}

- (IBAction)logoutAction:(id)sender {
    
    [self AlertWithTitle:@"温馨提示" message:@"退出登录" andOthers:@[@"确定",@"取消"] animated:YES action:^(NSInteger index) {
        
        if (index == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 退出登录
                [SPUtil setBool:NO forKey:k_app_login];
				
				
                LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
                BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            });
           
        }
    }];
    
  
    
    
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

//
//  MineViewController.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineViewController.h"
#import "SettingViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    [self setup];
}

- (void)setup {
    UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newsImgView.userInteractionEnabled = YES;
    newsImgView.image = [UIImage imageNamed:@"setting_icon"];
    UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newsImgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingAction:)];
    [newsImgView addGestureRecognizer:tap];
}

- (void)settingAction:(UITapGestureRecognizer *)tap {
    SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
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

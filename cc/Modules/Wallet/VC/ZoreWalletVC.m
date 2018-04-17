//
//  ZoreWalletVC.m
//  cc
//
//  Created by wy on 2018/4/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ZoreWalletVC.h"

@interface ZoreWalletVC ()
@property (weak, nonatomic) IBOutlet UILabel *yesterDayNumLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *leftNumLab;
@property (weak, nonatomic) IBOutlet UILabel *rightNumLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteNumLab;
@property (weak, nonatomic) IBOutlet UILabel *totalAllLab;

@end

@implementation ZoreWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"释放记录";
    [self setup];
}

- (void)setup {
    
}

- (IBAction)lookAllAction:(id)sender {
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

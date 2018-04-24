//
//  MoneyTransferViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MoneyTransferViewController.h"

@interface MoneyTransferViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *shcNumLab;
@property (weak, nonatomic) IBOutlet UILabel *powerNumLab;
@property (weak, nonatomic) IBOutlet UILabel *inUseNumLab;

@end

@implementation MoneyTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"财务转账";
	[self setup];
}

- (void)setup {
	ViewBorderRadius(_submitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
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

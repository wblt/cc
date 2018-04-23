//
//  ZeroWalletVC.m
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ZeroWalletVC.h"
#import "ReleaseRecordViewController.h"

@interface ZeroWalletVC ()
@property (weak, nonatomic) IBOutlet UILabel *todayReleaseLab;
@property (weak, nonatomic) IBOutlet UILabel *bigLab;
@property (weak, nonatomic) IBOutlet UILabel *smallLab;
@property (weak, nonatomic) IBOutlet UILabel *intelligentLab;
@property (weak, nonatomic) IBOutlet UILabel *sportPointLab;
@property (weak, nonatomic) IBOutlet UILabel *nodeLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *totalLab;

@end

@implementation ZeroWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"释放记录";
	
	[self addViewTap];
	[self setup];
}

- (void)setup {
	ViewBorderRadius(_bgView, 10, 0.6, UIColorFromHex(0x4B5461));
}

- (void)addViewTap {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(lookAction)];
	_totalLab.userInteractionEnabled = YES;
	[_totalLab addGestureRecognizer:tap];
}

- (void)lookAction {
	ReleaseRecordViewController *vc = [[ReleaseRecordViewController alloc] init];
	
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

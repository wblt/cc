//
//  CompoundSettingViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "CompoundSettingViewController.h"

@interface CompoundSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIImageView *autoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *stopImgView;
@property (weak, nonatomic) IBOutlet UILabel *tipslab;
@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;

@end

@implementation CompoundSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"复利";
	[self setup];
	[self addViewTap];
}


- (void)setup {
	ViewBorderRadius(_sumbitBtn, 8, 0.6, UIColorFromHex(0x4B5461));
	
	//_tipslab.attributedText = [Util setAllText:@"开启自动复利：每天系统结算算力以后，会自动将释放钱包中的余额转入算力钱包进行循环复利" andSpcifiStr:@"开启自动复利：" withColor:UIColorFromHex(0xCCB17E) specifiStrFont:Font_13];
	
	_bgView1.backgroundColor = [UIColor darkGrayColor];
	_autoImgView.hidden = NO;
	
	_bgView2.backgroundColor = self.view.backgroundColor;
	_stopImgView.hidden = YES;
}

- (void)addViewTap {
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
	[_bgView1 addGestureRecognizer:tap1];
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
	[_bgView2 addGestureRecognizer:tap2];
}

- (void)tapAction1 {
	_bgView1.backgroundColor = [UIColor darkGrayColor];
	_bgView2.backgroundColor = self.view.backgroundColor;
	
	_autoImgView.hidden = NO;
	_stopImgView.hidden = YES;
}

- (void)tapAction2 {
	_bgView1.backgroundColor = self.view.backgroundColor;
	_bgView2.backgroundColor = [UIColor darkGrayColor];
	_autoImgView.hidden = YES;
	_stopImgView.hidden = NO;
}

- (IBAction)submitAction:(id)sender {
	
	if (_autoImgView.hidden) {
		[SVProgressHUD showSuccessWithStatus:@"停止复利"];
		
	}else {
		[SVProgressHUD showSuccessWithStatus:@"自动复利"];
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

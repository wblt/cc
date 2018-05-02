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
	[self requestData];
	[self setup];
	[self addViewTap];
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_IFFL];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSDictionary *dic = data[@"pd"];
		
		if ([dic[@"IFFL"] isEqualToString:@"1"]) {
				_autoImgView.hidden = NO;
				_stopImgView.hidden = YES;
		}else {
			_autoImgView.hidden = YES;
			_stopImgView.hidden = NO;
		}
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)setup {
	ViewBorderRadius(_sumbitBtn, 8, 0.6, UIColorFromHex(0x4B5461));
	
	//_tipslab.attributedText = [Util setAllText:@"开启自动复利：每天系统结算算力以后，会自动将释放钱包中的余额转入算力钱包进行循环复利" andSpcifiStr:@"开启自动复利：" withColor:UIColorFromHex(0xCCB17E) specifiStrFont:Font_13];
//	_autoImgView.hidden = NO;
//	_stopImgView.hidden = YES;
}

- (void)addViewTap {
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction1)];
	[_bgView1 addGestureRecognizer:tap1];
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
	[_bgView2 addGestureRecognizer:tap2];
}

- (void)tapAction1 {
	_autoImgView.hidden = NO;
	_stopImgView.hidden = YES;
}

- (void)tapAction2 {
	_autoImgView.hidden = YES;
	_stopImgView.hidden = NO;
}

- (IBAction)submitAction:(id)sender {
	
	NSString *iffl = @"";
	if (_autoImgView.hidden) {
//		[SVProgressHUD showSuccessWithStatus:@"停止复利"];
		iffl = @"0";
	}else {
//		[SVProgressHUD showSuccessWithStatus:@"自动复利"];
		iffl = @"1";
	}
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_CGFl];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	[params addParameter:@"IFFL" value:iffl];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"复利设置" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		
		NSDictionary *dic = data[@"pd"];
		
		if ([dic[@"IFFL"] isEqualToString:@"1"]) {
			[SVProgressHUD showSuccessWithStatus:@"设置自动复利成功"];
		}else if ([dic[@"IFFL"] isEqualToString:@"0"]) {
			[SVProgressHUD showSuccessWithStatus:@"设置停止复利成功"];
		}
//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//			[self.navigationController popViewControllerAnimated:YES];
//		});
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
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

//
//  CGPhoneNumViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "CGPhoneNumViewController.h"
#import "CQCountDownButton.h"

@interface CGPhoneNumViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;

@property(nonatomic,strong)CQCountDownButton *countDownButton;

@end

@implementation CGPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"手机号码";
	[self setup];
}

- (void)setup {
	ViewBorderRadius(_submitBtn, 8, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView1, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView2, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView3, 10, 0.6, UIColorFromHex(0x4B5461));
	
	
	__weak __typeof__(self) weakSelf = self;
	
	self.countDownButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
		//------- 按钮点击 -------//
		if (_phoneTextField.text.length == 0 || ![Util valiMobile:_phoneTextField.text]) {
			[SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
			weakSelf.countDownButton.enabled = YES;
			return ;
		}
//		[SVProgressHUD showWithStatus:@"正在获取验证码..."];
//		RequestParams *params = [[RequestParams alloc] initWithParams:API_REGIST_CODE];
//		[params addParameter:@"ACCOUNT" value:_phoneTextField.text];
//		[params addParameter:@"digestStr" value:[NSString stringWithFormat:@"%@shc",_phoneTextField.text].MD5Hash];
//
//		[[NetworkSingleton shareInstace] httpPost:params withTitle:@"获取注册短信验证码" successBlock:^(id data) {
//			NSString *code = data[@"code"];
//			if (![code isEqualToString:@"1000"]) {
//				[SVProgressHUD showErrorWithStatus:data[@"message"]];
//				weakSelf.countDownButton.enabled = YES;
//				return ;
//			}
//			[SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
//			// 获取到验证码后开始倒计时
//			[weakSelf.countDownButton startCountDown];
//		} failureBlock:^(NSError *error) {
//			[SVProgressHUD showErrorWithStatus:@"网络异常"];
//			weakSelf.countDownButton.enabled = YES;
//		}];
	} countDownStart:^{
		//------- 倒计时开始 -------//
		NSLog(@"倒计时开始");
	} countDownUnderway:^(NSInteger restCountDownNum) {
		//------- 倒计时进行中 -------//
		[weakSelf.countDownButton setTitle:[NSString stringWithFormat:@"再次获取(%ld秒)", restCountDownNum] forState:UIControlStateNormal];
	} countDownCompletion:^{
		//------- 倒计时结束 -------//
		[weakSelf.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
		NSLog(@"倒计时结束");
	}];
	ViewBorderRadius(self.countDownButton, 6, 0.6, UIColorFromHex(0x4B5461));
	
	[_codeBgView addSubview:self.countDownButton];
	self.countDownButton.frame = CGRectMake(0, 0, 100, 30);
	[self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
	self.countDownButton.titleLabel.font = Font_14;
	self.countDownButton.backgroundColor = [UIColor clearColor];
	[self.countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.countDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	
}

- (IBAction)submitAction:(id)sender {
	
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

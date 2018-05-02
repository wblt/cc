//
//  SetAQPwdNumViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "SetAQPwdNumViewController.h"
#import "CQCountDownButton.h"

@interface SetAQPwdNumViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiedl;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UITextField *aqPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *aqSurePwdtextField;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property(nonatomic,strong)CQCountDownButton *countDownButton;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@end

@implementation SetAQPwdNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"安全密码";
	[self setup];
}


- (void)setup {
	ViewBorderRadius(_editBtn, 8, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView1, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView2, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView3, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView4, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView5, 10, 0.6, UIColorFromHex(0x4B5461));
	
	__weak __typeof__(self) weakSelf = self;
	
	self.countDownButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
		if (_phoneTextField.text.length == 0 || ![Util valiMobile:_phoneTextField.text] || _userNameTextField.text.length == 0) {
			[SVProgressHUD showErrorWithStatus:@"请输入正确的手机号及用户名"];
			weakSelf.countDownButton.enabled = YES;
		}else {
			[SVProgressHUD showWithStatus:@"正在获取验证码..."];
			RequestParams *params = [[RequestParams alloc] initWithParams:API_AQPWD_CODE];
			[params addParameter:@"USER_NAME" value:_userNameTextField.text];
			[params addParameter:@"ACCOUNT" value:_phoneTextField.text];
			[params addParameter:@"digestStr" value:[NSString stringWithFormat:@"%@shc",_phoneTextField.text].MD5Hash];
			
			[[NetworkSingleton shareInstace] httpPost:params withTitle:@"安全密码短信验证码" successBlock:^(id data) {
				NSString *code = data[@"code"];
				if (![code isEqualToString:@"1000"]) {
					[SVProgressHUD showErrorWithStatus:data[@"message"]];
					weakSelf.countDownButton.enabled = YES;
					return ;
				}
				[SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
				// 获取到验证码后开始倒计时
				[weakSelf.countDownButton startCountDown];
			} failureBlock:^(NSError *error) {
				[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
				weakSelf.countDownButton.enabled = YES;
			}];
		}
		
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

- (IBAction)EditAction:(id)sender {
	if (_userNameTextField.text.length <= 0 ||_phoneTextField.text.length <= 0 || _aqPwdTextField.text.length <=0 || _codeTextFiedl.text.length <=0 || _aqSurePwdtextField.text.length <=0 ) {
		[SVProgressHUD showInfoWithStatus:@"请将信息填写完整"];
		return;
	}
	
	if (_aqPwdTextField.text.length != 6) {
		[SVProgressHUD showInfoWithStatus:@"请输入6位数字安全密码"];
		return;
	}
	
	if (![_aqPwdTextField.text isEqualToString:_aqSurePwdtextField.text]) {
		[SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
		return;
	}
	
	if (![Util valiMobile:_phoneTextField.text]) {
		[SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
		return;
	}
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_ANPASSW];
	[params addParameter:@"USER_NAME" value:_userNameTextField.text];
	[params addParameter:@"SJYZM" value:_codeTextFiedl.text];
	[params addParameter:@"NEW_PAS" value:_aqPwdTextField.text];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"修改安全密码" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		[SVProgressHUD showSuccessWithStatus:@"修改成功"];
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

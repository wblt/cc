//
//  PowerCGViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "PowerCGViewController.h"
#import "PasswordAlertView.h"
#import <IQKeyboardManager.h>
#import "SetAQPwdNumViewController.h"

@interface PowerCGViewController ()<PasswordAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;
@property (weak, nonatomic) IBOutlet UILabel *powerLab;
@property (weak, nonatomic) IBOutlet UILabel *isUserLab;
@property (weak, nonatomic) IBOutlet UILabel *shcLab;
@property (weak, nonatomic) IBOutlet UILabel *scaleLab;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (nonatomic,strong) PasswordAlertView *alertView;

@end

@implementation PowerCGViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//TODO: 页面appear 禁用
	[[IQKeyboardManager sharedManager] setEnable:NO];
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO; // 控制点击背景是否收起键盘
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	//TODO: 页面Disappear 启用
	[[IQKeyboardManager sharedManager] setEnable:YES];
	[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"能量兑换";
	[self requestData];
	[self setup];
}

- (void)setup {
		ViewBorderRadius(_sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
	
	_alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
	_alertView.delegate = self;
	_alertView.titleLable.text = @"请输入安全密码";
	_alertView.tipsLalbe.text = @"您输入的密码不正确！";
}


- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_CGENERGYMES];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"能量兑换页面" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSDictionary *pd = data[@"pd"];
		_powerLab.text = [NSString stringWithFormat:@"%@",pd[@"W_ENERGY"]];
		_isUserLab.text = [NSString stringWithFormat:@"%@",pd[@"T_MONEY"]];
		_shcLab.text = [NSString stringWithFormat:@"%@",pd[@"D_CURRENCY"]];
		_scaleLab.text = [NSString stringWithFormat:@"%@",pd[@"W_BL"]];
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"网络异常"];
	}];
}

- (IBAction)sumbitAction:(id)sender {
	if (_numTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入数量"];
		return;
	}
	
	//判断是否设置安全密码     弹出资金密码
	UserInfoModel *model =[[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	if ([model.IFPAS isEqualToString:@"0"]) {
		[SVProgressHUD showInfoWithStatus:@"未设置安全密码"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			// 跳转到设置安全密码页面
			SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		});
	}else {
		
		[_alertView show];
	}
	
	
	
}


-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
	NSLog(@"完成了密码输入,密码为：%@",password);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[_alertView passwordCorrect];
		RequestParams *params = [[RequestParams alloc] initWithParams:API_CHANGEENERGY];
		[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
		[params addParameter:@"PASSW" value:password];
		[params addParameter:@"S_NUM" value:_numTextField.text];
		
		[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
			NSString *code = data[@"code"];
			if (![code isEqualToString:@"1000"]) {
				[SVProgressHUD showErrorWithStatus:data[@"message"]];
				return ;
			}
			[SVProgressHUD showSuccessWithStatus:@"兑换成功"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self requestData];
			});
		} failureBlock:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:@"网络异常"];
		}];
	});
}

-(void)PasswordAlertViewDidClickCancleButton{
	NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
	NSLog(@"点击了忘记密码按钮");
	SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
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

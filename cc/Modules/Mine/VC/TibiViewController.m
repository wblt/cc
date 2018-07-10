//
//  TibiViewController.m
//  cc
//
//  Created by yanghuan on 2018/7/10.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "TibiViewController.h"
#import "PasswordAlertView.h"
#import <IQKeyboardManager.h>
#import "SetAQPwdNumViewController.h"
#import "ExtractRecordVC.h"

@interface TibiViewController ()<PasswordAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (nonatomic,strong) PasswordAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation TibiViewController

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
	self.navigationItem.title = @"提币申请";
	[self addNavBtn];
	[self setup];
}

- (void)setup {
	
	ViewBorderRadius(_submitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
	
	_alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
	_alertView.delegate = self;
	_alertView.titleLable.text = @"请输入安全密码";
	_alertView.tipsLalbe.text = @"您输入的密码不正确！";
	
}

- (void)addNavBtn {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(0, 0, 85, 30);
	[btn setTitle:@"提币记录" forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	btn.titleLabel.font = Font_15;
	
	[btn addTapBlock:^(UIButton *btn) {
		// 查看提币记录
		ExtractRecordVC *vc = [[ExtractRecordVC alloc] initWithNibName:@"ExtractRecordVC" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
		
	}];
	
	UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[self.navigationItem setRightBarButtonItem:anotherButton2];
	
}

- (IBAction)submitAction:(id)sender {
	if (_addressTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入提取钱包地址"];
		return;
	}
	
	if (_numTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入提取数量"];
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
	
	//这里必须延迟一下  不然看不到最后一个黑点显示整个视图就消失了
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[_alertView passwordCorrect];
		//  开始转换请求
		RequestParams *params = [[RequestParams alloc] initWithParams:API_tequila];
		[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
		[params addParameter:@"W_ADDRESS" value:_addressTextField.text];
		[params addParameter:@"S_MONEY" value:_numTextField.text];
		[params addParameter:@"PASSW" value:password];
		
		
		[[NetworkSingleton shareInstace] httpPost:params withTitle:@"提币申请" successBlock:^(id data) {
			NSString *code = data[@"code"];
			if (![code isEqualToString:@"1000"]) {
				[SVProgressHUD showErrorWithStatus:data[@"message"]];
				return ;
			}
			[SVProgressHUD showSuccessWithStatus:@"提交成功"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self.navigationController popViewControllerAnimated:YES];
			});
		} failureBlock:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
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

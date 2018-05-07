//
//  MoneyTransferViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MoneyTransferViewController.h"
#import "PasswordAlertView.h"
#import <IQKeyboardManager.h>
#import "UserInfoModel.h"
#import "SetAQPwdNumViewController.h"

@interface MoneyTransferViewController ()<PasswordAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *shcNumLab;
@property (weak, nonatomic) IBOutlet UILabel *powerNumLab;
@property (weak, nonatomic) IBOutlet UILabel *inUseNumLab;
@property (nonatomic,strong) PasswordAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIView *typeBgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic,copy)NSString *type; // 0 零钱  1 区块SHC

@end

@implementation MoneyTransferViewController

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
	self.navigationItem.title = @"财务转账";
    
    _type = @"0";
    
	[self setup];
    [self addTapView];
	[self requestData];
   
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_SENDMES];
	
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"可发送内容" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		
//		{
//			"code": "1000",
//			"pd": {
//				"W_ENERGY": 0,
//				"D_CURRENCY": 888888,
//				"USER_NAME": haha,
//				"T_MONEY": 88888888881
//			},
//			"message": "请求成功"
//		}
		NSDictionary *dic = data[@"pd"];
		_shcNumLab.text =  [NSString stringWithFormat:@"%@",dic[@"D_CURRENCY"]];
		_inUseNumLab.text = [NSString stringWithFormat:@"%@",dic[@"QK_CURRENCY"]];
		_powerNumLab.text = [NSString stringWithFormat:@"%@",dic[@"W_ENERGY"]];
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)setup {
	ViewBorderRadius(_submitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
	
	_alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
	_alertView.delegate = self;
	_alertView.titleLable.text = @"请输入安全密码";
	_alertView.tipsLalbe.text = @"您输入的密码不正确！";
	
}

- (void)addTapView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeAction)];
    [_typeBgView addGestureRecognizer:tap];
}

- (void)chooseTypeAction {
    ////这里是摄像头可以使用的处理逻辑
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送至零钱", @"发送区块SHC", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {/**发送至零钱*/
        _typeLab.text = @"发送零钱";
        _type = @"0";
    }else if (buttonIndex == 1){/**发送区块SHC*/
        _typeLab.text = @"发送区块SHC";
        _type = @"1";
    }
}

- (IBAction)sumbitAction:(id)sender {
	
	if (_numTextField.text ==0 ) {
		[SVProgressHUD showInfoWithStatus:@"请输入数量"];
		return;
	}
	
	if (_addressTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入钱包地址"];
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
		RequestParams *params = [[RequestParams alloc] initWithParams:API_SEND];
		[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
		[params addParameter:@"W_ADDRESS" value:_addressTextField.text];
		[params addParameter:@"S_MONEY" value:_numTextField.text];
		[params addParameter:@"PASSW" value:password];
        [params addParameter:@"CURRENCY_TYPE" value:_type];
		
		[[NetworkSingleton shareInstace] httpPost:params withTitle:@"发送SHC" successBlock:^(id data) {
			NSString *code = data[@"code"];
			if (![code isEqualToString:@"1000"]) {
				[SVProgressHUD showErrorWithStatus:data[@"message"]];
				return ;
			}
			[SVProgressHUD showSuccessWithStatus:@"转账成功"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				//[self requestData];
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

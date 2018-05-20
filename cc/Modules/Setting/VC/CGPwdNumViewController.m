//
//  CGPwdNumViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "CGPwdNumViewController.h"

@interface CGPwdNumViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *xinPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;

@end

@implementation CGPwdNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"登录密码";
	[self setup];
}

- (void)setup {
	ViewBorderRadius(_sumbitBtn, 8, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView1, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView2, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView3, 10, 0.6, UIColorFromHex(0x4B5461));
	
}
- (IBAction)submitAction:(id)sender {
	
	if (_userTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"用户名不能为空"];
		return;
	}
	
	
	if (_oldPwdTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"当前密码不能为空"];
		return;
	}
	
	
	if (_xinPwdTextField.text.length == 0) {
		[SVProgressHUD showInfoWithStatus:@"新密码不能为空"];
		return;
	}
	
	
	if (_xinPwdTextField.text.length < 6 ||  _xinPwdTextField.text.length >15) {
		[SVProgressHUD showInfoWithStatus:@"请设置6-15位数字、字母密码"];
		return;
	}
	
	RequestParams *params = [[RequestParams alloc] initWithParams:API_CGPASSWORD];
	[params addParameter:@"USER_NAME" value:_userTextField.text];
	[params addParameter:@"OLD_PAS" value:_oldPwdTextField.text];
	[params addParameter:@"NEW_PAS" value:_xinPwdTextField.text];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
        [SPUtil setObject:_xinPwdTextField.text forKey:k_app_security];
		[SVProgressHUD showSuccessWithStatus:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
		
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

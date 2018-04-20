//
//  LoginVC.m
//  cc
//
//  Created by yanghuan on 2018/4/11.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "LoginVC.h"
#import "MQVerCodeImageView.h"
#import "MainTabBarController.h"
#import "RegistViewController.h"
#import "ForgetPwdViewController.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property(nonatomic,strong)MQVerCodeImageView *codeImageView;
@property(nonatomic,copy)NSString *imageCodeStr;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"登陆";
    
    [self setup];
}

- (void)setup {
    ViewBorderRadius(_loginBtn, 8, 0.6, UIColorFromHex(0xCCB17E));
    
    _codeImageView = [[MQVerCodeImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    _codeImageView.bolck = ^(NSString *imageCodeStr){
        //打印生成的验证码
        _imageCodeStr = imageCodeStr;
        DLog(@"imageCodeStr = %@",imageCodeStr)
    };
    //验证码字符是否可以斜着
    _codeImageView.isRotation = YES;
    [_codeImageView freshVerCode];
    [_codeBgView addSubview: _codeImageView];
    //点击刷新
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_codeImageView addGestureRecognizer:tap];
    
    _phoneTextField.text = [SPUtil objectForKey:k_app_userNumber];
    _pwdTextField.text = [SPUtil objectForKey:k_app_passNumber];
}

- (IBAction)loginAction:(UIButton *)sender {
    if (_phoneTextField.text.length <= 0 || _pwdTextField.text.length <=0 ) {
        [SVProgressHUD showInfoWithStatus:@"请填写账号密码"];
        return;
    }
    
    if (![Util valiMobile:_phoneTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
	
	if (_pwdTextField.text.length <6) {
		[SVProgressHUD showInfoWithStatus:@"请输入6位以上密码"];
		return;
	}
	
	if (_codeTextField.text.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"请输入验证码"];
		return;
	}
	
    if (![_imageCodeStr.uppercaseString isEqualToString:_codeTextField.text.uppercaseString]) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        [_codeImageView freshVerCode];
        return;
    }
    
    // 进入页面
    MainTabBarController *mainTabbar = [[MainTabBarController alloc] init];
    mainTabbar.selectIndex = 0;
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabbar;
    if (_rememberBtn.selected) {
        [SPUtil setObject:_pwdTextField.text forKey:k_app_passNumber];
        [SPUtil setObject:_phoneTextField.text forKey:k_app_userNumber];
    }
    if (_autoLoginBtn.selected) {
       [SPUtil setBool:YES forKey:k_app_login];
    }
}


- (IBAction)registAction:(UIButton *)sender {
    RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)forgetPwdAction:(UIButton *)sender {
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)remeberAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}
- (IBAction)autoLoginAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    [_codeImageView freshVerCode];
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

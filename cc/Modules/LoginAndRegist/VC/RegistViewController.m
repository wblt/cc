//
//  RegistViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/11.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "RegistViewController.h"
#import "CQCountDownButton.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *invitattextField;

@property (weak, nonatomic) IBOutlet UITextField *phonetextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property(nonatomic,strong)CQCountDownButton *countDownButton;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册";
    [self setup];
}

- (void)setup {
    ViewBorderRadius(_registBtn, 8, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_bgView1, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_bgView2, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_bgView3, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_bgView4, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_bgView5, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_bgView6, 10, 0.6, UIColorFromHex(0x4B5461));
    
    __weak __typeof__(self) weakSelf = self;
    
    self.countDownButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
        //------- 按钮点击 -------//
        if (_phonetextField.text.length == 0 || ![Util valiMobile:_phonetextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            weakSelf.countDownButton.enabled = YES;
            return ;
        }
        [SVProgressHUD showWithStatus:@"正在获取验证码..."];
        RequestParams *params = [[RequestParams alloc] initWithParams:API_REGIST_CODE];
        [params addParameter:@"ACCOUNT" value:_phonetextField.text];
        [params addParameter:@"digestStr" value:[NSString stringWithFormat:@"%@shc",_phonetextField.text].MD5Hash];
        
        [[NetworkSingleton shareInstace] httpPost:params withTitle:@"获取注册短信验证码" successBlock:^(id data) {
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
             [SVProgressHUD showErrorWithStatus:@"网络异常"];
            weakSelf.countDownButton.enabled = YES;
        }];
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
    self.countDownButton.backgroundColor = UIColorFromHex(0x020919);
    [self.countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
}

- (IBAction)readAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)protocolAction:(UIButton *)sender {
    //跳转到协议界面
    
}

- (IBAction)registAction:(UIButton *)sender {
    
    if (_userNameTextField.text.length <= 0 || _phonetextField.text.length <= 0 || _pwdTextField.text.length <=0 || _codeTextField.text.length <=0 || _surePwdTextField.text.length <=0 ) {
        [SVProgressHUD showInfoWithStatus:@"请将信息填写完整"];
        return;
    }
	
	if (_pwdTextField.text.length < 6) {
		[SVProgressHUD showInfoWithStatus:@"请输入6位以上密码"];
		return;
	}
	
	if (_invitattextField.text.length <= 0) {
		[SVProgressHUD showInfoWithStatus:@"请输入邀请码"];
		return;
	}
    
    if (![_pwdTextField.text isEqualToString:_surePwdTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
		return;
    }
    
    if (![Util valiMobile:_phonetextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (!_readBtn.selected) {
         [SVProgressHUD showInfoWithStatus:@"请阅读并同意注册协议"];
        return;
    }
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_REGIST];
    [params addParameter:@"USER_NAME" value:_userNameTextField.text];
    [params addParameter:@"PASSWORD" value:_pwdTextField.text];
    [params addParameter:@"ACCOUNT" value:_phonetextField.text];
    [params addParameter:@"SJYZM" value:_codeTextField.text];
    [params addParameter:@"YQ_CODE" value:_invitattextField.text];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        //保存用户信息
        [SPUtil setObject:_userNameTextField.text forKey:k_app_userNumber];
        // 回到登录界面、 或者直接进入
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
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

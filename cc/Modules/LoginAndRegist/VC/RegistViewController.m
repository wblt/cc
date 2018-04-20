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
    ViewBorderRadius(_registBtn, 8, 0.6, UIColorFromHex(0xCCB17E));
    
    __weak __typeof__(self) weakSelf = self;
    
    self.countDownButton = [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
        //------- 按钮点击 -------//
        [SVProgressHUD showWithStatus:@"正在获取验证码..."];
        // 请求数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int a = arc4random() % 2;
            if (a == 0) {
                // 获取成功
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                // 获取到验证码后开始倒计时
                [weakSelf.countDownButton startCountDown];
            } else {
                // 获取失败
                [SVProgressHUD showErrorWithStatus:@"获取失败，请重试"];
                weakSelf.countDownButton.enabled = YES;
            }
        });
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
    ViewBorderRadius(self.countDownButton, 6, 0.6, UIColorFromHex(0xCCB17E));
    
    [_codeBgView addSubview:self.countDownButton];
    self.countDownButton.frame = CGRectMake(0, 0, 100, 30);
    [self.countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.countDownButton.titleLabel.font = Font_14;
    self.countDownButton.backgroundColor = UIColorFromHex(0x484848);
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
    // 回到登录界面、 或者直接进入
    [self.navigationController popViewControllerAnimated:YES];
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

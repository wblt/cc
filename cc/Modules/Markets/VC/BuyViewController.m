//
//  BuyViewController.m
//  cc
//
//  Created by wy on 2018/5/1.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "BuyViewController.h"
#import "PasswordAlertView.h"
#import "SetAQPwdNumViewController.h"
#import <IQKeyboardManager.h>
@interface BuyViewController ()<PasswordAlertViewDelegate,UITextFieldDelegate>{
    UILabel *sellPriceLab;
    UITextField *sellNumTextField;
    UILabel *sellTotalPriceLab;
    
    NSString *power;
}
@property (nonatomic,strong) PasswordAlertView *alertView;

@end

@implementation BuyViewController


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
    [self setup];
    [self addSellViewToScrollerView];
}

- (void)setup {
    _alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
    _alertView.delegate = self;
    _alertView.titleLable.text = @"请输入安全密码";
    _alertView.tipsLalbe.text = @"您输入的密码不正确！";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (sellNumTextField.text.length >0 ) {
        
        float money =   [sellNumTextField.text floatValue] * [self.model.BUSINESS_PRICE floatValue];
        sellTotalPriceLab.text = [NSString stringWithFormat:@"总价:%.02f",money];
    }else {
        sellTotalPriceLab.text = @"总价:0";
    }
    
}

-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    NSLog(@"完成了密码输入,密码为：%@",password);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView passwordCorrect];
      
        RequestParams *params = [[RequestParams alloc] initWithParams:API_buy];
        [params addParameter:@"TRADE_ID" value:self.model.TRADE_ID];
        [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
        [params addParameter:@"D_CURRENCY" value:sellNumTextField.text];
        [params addParameter:@"PASSW" value:password];
        
        [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
            NSString *code = data[@"code"];
            if (![code isEqualToString:@"1000"]) {
                [SVProgressHUD showErrorWithStatus:data[@"message"]];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:@"购买成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
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

- (void)addSellViewToScrollerView {
    UIView *sellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
    
    UILabel *sellPriceTipsLab = [[UILabel alloc] init];
    sellPriceTipsLab.text = @"卖单价格";
    sellPriceTipsLab.font = Font_13;
    sellPriceTipsLab.textColor = [UIColor whiteColor];
    [sellView addSubview:sellPriceTipsLab];
    
    sellPriceLab = [[UILabel alloc] init];
    sellPriceLab.text = [NSString stringWithFormat:@"%@",self.model.BUSINESS_PRICE];
    sellPriceLab.font = Font_13;
    sellPriceLab.textColor = [UIColor whiteColor];
    sellPriceLab.textAlignment = NSTextAlignmentRight;
    [sellView addSubview:sellPriceLab];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor grayColor];
    [sellView addSubview:line1];
    
    UILabel *numTipsLab = [[UILabel alloc] init];
    numTipsLab.text = @"卖单数量";
    numTipsLab.font = Font_13;
    numTipsLab.textColor = [UIColor whiteColor];
    [sellView addSubview:numTipsLab];
    
    UILabel *numLab = [[UILabel alloc] init];
    numLab.text = [NSString stringWithFormat:@"%@",self.model.BUSINESS_COUNT];
    numLab.font = Font_13;
    numLab.textColor = [UIColor whiteColor];
    numLab.textAlignment = NSTextAlignmentRight;
    [sellView addSubview:numLab];
    
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor grayColor];
    [sellView addSubview:line2];
    
    UILabel *sellNumTipsLab = [[UILabel alloc] init];
    sellNumTipsLab.text = @"买入数量";
    sellNumTipsLab.font = Font_13;
    sellNumTipsLab.textColor = [UIColor whiteColor];
    [sellView addSubview:sellNumTipsLab];
    
    sellNumTextField = [[UITextField alloc] init];
    sellNumTextField.placeholder = @"请输入挂卖数量(整数且1的倍数)";
    sellNumTextField.font = Font_13;
    sellNumTextField.delegate = self;
    sellNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    sellNumTextField.textColor = [UIColor whiteColor];
    sellNumTextField.textAlignment = NSTextAlignmentRight;
    [sellNumTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [sellView addSubview:sellNumTextField];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = [UIColor grayColor];
    [sellView addSubview:line3];
    
    sellTotalPriceLab = [[UILabel alloc] init];
    sellTotalPriceLab.text = @"总价：0";
    sellTotalPriceLab.font = Font_13;
    sellTotalPriceLab.textColor = [UIColor whiteColor];
    [sellView addSubview:sellTotalPriceLab];
    
    UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
    [sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
    sumbitBtn.titleLabel.font = Font_14;
    [sellView addSubview:sumbitBtn];
    [sumbitBtn addTapBlock:^(UIButton *btn) {
        if (sellNumTextField.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入单价"];
            return;
        }
        
        if (sellNumTextField.text.integerValue > self.model.BUSINESS_COUNT.integerValue) {
            [SVProgressHUD showErrorWithStatus:@"超过可买数量"];
            return ;
        }
        
        UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
        
        if ([model.IFPAS isEqualToString:@"1"]) {
            [_alertView show];
        }else {
            [SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }
        
        
    }];
    
    [self.view addSubview:sellView];
    
    [sellPriceTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(30);
        make.top.equalTo(sellView).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    
    [sellPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(30);
        make.right.equalTo(sellView).offset(-30);
        make.top.equalTo(sellView).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(20);
        make.right.equalTo(sellView).offset(-20);
        make.top.equalTo(sellPriceTipsLab.mas_bottom).offset(10);
        make.height.mas_equalTo(0.6);
    }];
    
    [numTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(30);
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(30);
        make.right.equalTo(sellView).offset(-30);
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(20);
        make.right.equalTo(sellView).offset(-20);
        make.top.equalTo(numTipsLab.mas_bottom).offset(10);
        make.height.mas_equalTo(0.6);
    }];
    
    [sellNumTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(30);
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [sellNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellNumTipsLab.mas_right).offset(10);
        make.right.equalTo(sellView).offset(-30);
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(20);
        make.right.equalTo(sellView).offset(-20);
        make.top.equalTo(sellNumTipsLab.mas_bottom).offset(10);
        make.height.mas_equalTo(0.6);
    }];
    
    [sellTotalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellView).offset(30);
        make.top.equalTo(line3.mas_bottom).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    [sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sellTotalPriceLab.mas_bottom).offset(10);
        make.left.equalTo(sellView).offset(20);
        make.right.equalTo(sellView).offset(-20);
        make.height.mas_equalTo(50);
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

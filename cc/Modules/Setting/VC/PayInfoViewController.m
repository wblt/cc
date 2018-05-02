//
//  PayInfoViewController.m
//  cc
//
//  Created by wy on 2018/4/29.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "PayInfoViewController.h"

@interface PayInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankZhiTextField;
@property (weak, nonatomic) IBOutlet UITextField *weixinTextField;
@property (weak, nonatomic) IBOutlet UITextField *zhifubaoTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation PayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付信息";
    [self requestData];
    [self setup];
}

- (void)setup {
    ViewBorderRadius(_submitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
    
}

- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_payMes];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"查询支付信息" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        if ([data[@"pd"] isEqual:[NSNull null]] || data[@"pd"] == nil) {
            return;
        }
         NSDictionary *pd  = data[@"pd"];
         _bankNameTextField.text = [NSString stringWithFormat:@"%@",pd[@"BANK_NAME"]];
         _bankNumTextField.text = [NSString stringWithFormat:@"%@",pd[@"BANK_NO"]];
         _bankZhiTextField.text = [NSString stringWithFormat:@"%@",pd[@"BANK_ADDR"]];
         _zhifubaoTextField.text = [NSString stringWithFormat:@"%@",pd[@"ALIPAY"]];
         _nameTextField.text = [NSString stringWithFormat:@"%@",pd[@"BANK_USERNAME"]];
         _weixinTextField.text = [NSString stringWithFormat:@"%@",pd[@"WCHAT"]];
 
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (IBAction)submitAction:(id)sender {
    
    if (_weixinTextField.text.length >0 || _zhifubaoTextField.text.length >0 || (_bankNumTextField.text.length >0 && _bankZhiTextField.text.length >0 && _bankNameTextField.text.length >0 && _nameTextField.text.length >0)) {
        
        
        RequestParams *params = [[RequestParams alloc] initWithParams:API_cgPayMes];
        [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
        [params addParameter:@"BANK_NAME" value:_bankNameTextField.text];
        [params addParameter:@"BANK_NO" value:_bankNumTextField.text];
        [params addParameter:@"BANK_USERNAME" value:_nameTextField.text];
        [params addParameter:@"BANK_ADDR" value:_bankZhiTextField.text];
        [params addParameter:@"WCHAT" value:_weixinTextField.text];
        [params addParameter:@"ALIPAY" value:_zhifubaoTextField.text];
        
        [[NetworkSingleton shareInstace] httpPost:params withTitle:@"修改支付信息" successBlock:^(id data) {
            NSString *code = data[@"code"];
            if (![code isEqualToString:@"1000"]) {
                [SVProgressHUD showErrorWithStatus:data[@"message"]];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            
        } failureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
        }];
        
        
        
    }else {
        [SVProgressHUD showInfoWithStatus:@"请填写至少一种信息"];
    }
    
    
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

//
//  OrderDetailsViewController.m
//  cc
//
//  Created by wy on 2018/5/1.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "SetAQPwdNumViewController.h"
#import <IQKeyboardManager.h>
#import "PasswordAlertView.h"

@interface OrderDetailsViewController ()<PasswordAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sellNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;
@property (weak, nonatomic) IBOutlet UILabel *bankUserLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiNameLab;
@property (weak, nonatomic) IBOutlet UILabel *weixinLab;
@property (weak, nonatomic) IBOutlet UILabel *zhifubaoLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic,strong) PasswordAlertView *alertView;
@property (nonatomic,strong)NSString *type;// 1 取消 2 确认付款
@end

@implementation OrderDetailsViewController

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
    self.navigationItem.title = @"订单详情";
    _cancelBtn.hidden = YES;
    _payBtn.hidden =YES;
    [self requestData];
    [self setup];
}

- (void)setup {
    ViewBorderRadius(_cancelBtn, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_payBtn, 10, 0.6, UIColorFromHex(0x4B5461));
    
    _alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
    _alertView.delegate = self;
    _alertView.titleLable.text = @"请输入安全密码";
    _alertView.tipsLalbe.text = @"您输入的密码不正确！";
}

- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_orderDetail];
    [params addParameter:@"TRADE_ID" value:self.model.TRADE_ID];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"订单详情" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSDictionary *pd = data[@"pd"];
        _weixinLab.text = [NSString stringWithFormat:@"%@",pd[@"WCHAT"]];
        _zhifubaoLab.text = [NSString stringWithFormat:@"%@",pd[@"ALIPAY"]];
        _totalLab.text = [NSString stringWithFormat:@"%@",pd[@"TOTAL_MONEY"]];
        _sellNameLab.text = [NSString stringWithFormat:@"%@",pd[@"USER_NAME"]];
        _priceLab.text = [NSString stringWithFormat:@"%@",pd[@"BUSINESS_PRICE"]];
        _timeLab.text = [NSString stringWithFormat:@"%@",pd[@"CREATE_TIME"]];
        _numLab.text = [NSString stringWithFormat:@"%@",pd[@"BUSINESS_COUNT"]];
        _bankNumLab.text =  [NSString stringWithFormat:@"%@",pd[@"BANK_NO"]];
        _bankNameLab.text = [NSString stringWithFormat:@"%@",pd[@"BANK_NAME"]];
        _bankUserLab.text = [NSString stringWithFormat:@"%@",pd[@"BANK_USERNAME"]];
        _zhiNameLab.text =  [NSString stringWithFormat:@"%@",pd[@"BANK_ADDR"]];
        NSString *status = [NSString stringWithFormat:@"%@",pd[@"STATUS"]];

        if ([status isEqualToString:@"0"]) {
            _orderStatusLab.text = @"待审核";
        }else if ([status isEqualToString:@"1"])  {
            _orderStatusLab.text = @"审核通过";
        }else if ([status isEqualToString:@"2"])  {
            _orderStatusLab.text = @"部分成交";
        }else if ([status isEqualToString:@"3"])  {
            _orderStatusLab.text = @"待付款";
            _cancelBtn.hidden = NO;
            _payBtn.hidden = NO;
        }else if ([status isEqualToString:@"4"])  {
            _orderStatusLab.text = @"已付款";
        }else if ([status isEqualToString:@"5"])  {
            _orderStatusLab.text = @"已成交";
        }else if ([status isEqualToString:@"6"])  {
            _orderStatusLab.text = @"已取消";
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

- (IBAction)cancelAction:(id)sender {
    _type = @"1";
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
}

- (IBAction)payAction:(id)sender {
    _type = @"2";
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
}

-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
        if ([model.PASSW isEqualToString:password]) {
            [_alertView passwordCorrect];
            
            if ([_type isEqualToString:@"1"]) { //取消订单
                [self cancelOrderAction:self.model];
            }else { //确认付款
                 [self payOrder:self.model];
            }
            
            
        }else {
            [_alertView passwordError];
        }
        
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

- (void)cancelOrderAction:(OrderModel *)order {
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_orderCancle];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    [params addParameter:@"TYPE" value:@"0"]; // 取消买单
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

- (void)payOrder:(OrderModel *)order {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_pay];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    [params addParameter:@"STATUS" value:@"4"];
    
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"确认付款成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

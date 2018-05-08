//
//  MyOrderViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MyOrderViewController.h"
#import "PasswordAlertView.h"
#import "OrderListTabCell.h"
#import "OrderModel.h"
#import "SetAQPwdNumViewController.h"
#import <IQKeyboardManager.h>
#import "OrderDetailsViewController.h"
static NSString *Identifier = @"cell";

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,PasswordAlertViewDelegate,OrderListTabCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (nonatomic,strong) PasswordAlertView *alertView;

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,copy)NSString *QUERY_ID;//如果QUERY_ID = 0，则获取最新数据.
@property (nonatomic,copy)NSString *TYPE; //1：向下拉；QUERY_ID =0,该值没意义2：向上拉(必填)
@property (nonatomic,copy)NSString *orderType; // 1 买单，2 卖单
@property (nonatomic,strong)OrderModel *currentModel;
@end

@implementation MyOrderViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO; // 控制点击背景是否收起键盘
    _QUERY_ID = @"0";
    _TYPE = @"1";
    [self.data removeAllObjects];
    [self.tableView reloadData];
    if ([_orderType isEqualToString:@"1"]) {
        [self requetBuyData];
    }else {
        [self requetSellData];
    }
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
	self.navigationItem.title = @"我的订单";
    self.data = [NSMutableArray array];
    _orderType = @"1";
    
    _QUERY_ID = @"0";
    _TYPE = @"1";
	[self setup];
    [self requetBuyData];
}

- (void)refreshData {
    [self.data removeAllObjects];
    [self.tableView reloadData];
    _QUERY_ID = @"0";
    _TYPE = @"1";
    
    if ([_orderType isEqualToString:@"1"]) {
        [self requetBuyData];
    }else {
        [self requetSellData];
    }
}

- (void)requetBuyData {
    [super refreshData];
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_buyList];
    [params addParameter:@"QUERY_ID" value:_QUERY_ID];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"TYPE" value:_TYPE];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
        if (pd.count == 0 && [_QUERY_ID isEqualToString:@"0"]) {
            [self showImagePage:YES withIsError:NO];
            return;
        }
        for (NSDictionary *dic in pd) {
            OrderModel *model = [OrderModel mj_objectWithKeyValues:dic];
            [self.data addObject:model];
            if (pd.lastObject == dic) {
                _QUERY_ID = [NSString stringWithFormat:@"%@",model.TRADE_ID];
            }
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)requetSellData {
    [super refreshData];
    RequestParams *params = [[RequestParams alloc] initWithParams:API_sellList];
    [params addParameter:@"QUERY_ID" value:_QUERY_ID];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"TYPE" value:_TYPE];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSArray *pd = data[@"pd"];
        if (pd.count == 0 && [_QUERY_ID isEqualToString:@"0"]) {
            [self showImagePage:YES withIsError:NO];
            return;
        }
        for (NSDictionary *dic in pd) {
            OrderModel *model = [OrderModel mj_objectWithKeyValues:dic];
            [self.data addObject:model];
            if (pd.lastObject == dic) {
                _QUERY_ID = [NSString stringWithFormat:@"%@",model.TRADE_ID];
            }
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)cancelOrderAction:(OrderModel *)order {
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_orderCancle];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    if ([_orderType isEqualToString: @"1"]) {
        [params addParameter:@"TYPE" value:@"0"]; // 取消买单
    }else {
         [params addParameter:@"TYPE" value:@"1"];//取消卖单
    }
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        self.currentModel.STATUS = @"6";
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)surePayOrder:(OrderModel *)order {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_surePay];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"确认收款成功"];
        self.currentModel.STATUS = @"5";
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}


- (IBAction)lookBuyOrderAction:(UIButton *)sender {
	if (!sender.selected) {
		sender.selected = !sender.selected;
	}
	_sellBtn.selected = NO;
    
    // 防止重复请求
    if ([_orderType isEqualToString:@"1"]) {
        return;
    }
    
    _orderType = @"1";
    
    _QUERY_ID = @"0";
    _TYPE = @"1";
    [self.data removeAllObjects];
    [self requetBuyData];
}

- (IBAction)lookSellOrderAction:(UIButton *)sender {
	if (!sender.selected) {
		sender.selected = !sender.selected;
	}
	_buyBtn.selected = NO;
    
    // 防止重复请求
    if ([_orderType isEqualToString:@"2"]) {
        return;
    }
    _orderType = @"2";
    
    _QUERY_ID = @"0";
    _TYPE = @"1";
    [self.data removeAllObjects];
    [self requetSellData];
}

- (void)setup {
	_buyBtn.selected = YES;
	_sellBtn.selected = NO;
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerNib:[UINib nibWithNibName:@"OrderListTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
	
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _QUERY_ID = @"0";
        _TYPE = @"1";
        
        [self.data removeAllObjects];
        [self.tableView reloadData];
        if ([_orderType isEqualToString:@"1"]) {
             [self requetBuyData];
        }else {
            [self requetSellData];
        }
       
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个 block
        _TYPE = @"2";
        if ([_orderType isEqualToString:@"1"]) {
            [self requetBuyData];
        }else {
            [self requetSellData];
        }
    }];
    
	_alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
	_alertView.delegate = self;
	_alertView.titleLable.text = @"请输入安全密码";
	_alertView.tipsLalbe.text = @"您输入的密码不正确！";
	
}

# pragma mark tableView delegate dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	OrderListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	ViewBorderRadius(cell.matchBtn, 6, 0.6,UIColorFromHex(0x4B5461));
	ViewBorderRadius(cell.bgView, 6, 0.6,UIColorFromHex(0x4B5461));
	cell.index = indexPath.row;
	cell.delegate = self;
    cell.ordertype = _orderType;
	[cell.matchBtn setTitle:@"可取消" forState:UIControlStateNormal];
    cell.order = self.data[indexPath.row];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
	
}

- (void)OrderListTabCellMacth:(NSInteger)index orderType:(NSString *)type{
    OrderDetailsViewController *vc = [[OrderDetailsViewController alloc] initWithNibName:@"OrderDetailsViewController" bundle:nil];
    vc.model = self.data[index];
    if ([type isEqualToString:@"2"]) {
        vc.type = @"1";//卖单进入
    }else {
        vc.type = @"0"; //买单进入
    }
    [self.navigationController pushViewController:vc animated:YES];
	
//    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
//
//    if ([type isEqualToString:@"2"]) { // 卖单   取消订单
//        if ([model.IFPAS isEqualToString:@"1"]) {
//            [_alertView show];
//            self.currentModel = self.data[index];
//        }else {
//            [SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
//                [self.navigationController pushViewController:vc animated:YES];
//            });
//        }
//    }else { // 买单查看 订单详情
//        OrderDetailsViewController *vc = [[OrderDetailsViewController alloc] initWithNibName:@"OrderDetailsViewController" bundle:nil];
//        vc.model = self.data[index];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
   
}

-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
        if ([model.PASSW isEqualToString:password]) {
            [_alertView passwordCorrect];
            // 4 就是已付款款 状态   需要去确认收款
            if ([self.currentModel.STATUS isEqualToString:@"4"]) {
                [self surePayOrder:self.currentModel];
            }else {//其他都是可取消状态
                [self cancelOrderAction:self.currentModel];
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

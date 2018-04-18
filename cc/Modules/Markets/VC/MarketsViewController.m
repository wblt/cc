//
//  MarketsViewController.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MarketsViewController.h"
#import "OrderListTabCell.h"
#import "PasswordAlertView.h"
#import <IQKeyboardManager.h>
static NSString *Identifier = @"cell";

@interface MarketsViewController ()<UITableViewDelegate,UITableViewDataSource,PasswordAlertViewDelegate,OrderListTabCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) PasswordAlertView *alertView;
@end

@implementation MarketsViewController

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
    self.navigationItem.title = @"市场";
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self setup];
}

- (void)setup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
    
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
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
    ViewBorderRadius(cell.matchBtn, 6, 0.6,UIColorFromHex(0xCCB17E));
	cell.index = indexPath.row;
	cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
    
}

- (void)OrderListTabCellMacth:(NSInteger)index {
	
	[_alertView show];
	
//	BOOL flag = [SPUtil boolForKey:k_app_security];
//	if (flag) {
//		DLog(@"匹配第几个%ld",index);
//		[SVProgressHUD showSuccessWithStatus:@"匹配一下~"];
//	}else {
//		[_alertView show];
//	}
	
}
-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    NSLog(@"完成了密码输入,密码为：%@",password);
    if ([password isEqualToString:@"111111"]) {
        NSLog(@"密码正确！");
        
        //这里必须延迟一下  不然看不到最后一个黑点显示整个视图就消失了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView passwordCorrect];
			
			[SPUtil setBool:YES forKey:k_app_security];// 设置输入了安全密码
			
        });
        
    }else{
        
        //这里必须延迟一下  不然看不到最后一个黑点显示整个视图就消失了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView passwordError];
        });
    }
}

-(void)PasswordAlertViewDidClickCancleButton{
    NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
    NSLog(@"点击了忘记密码按钮");
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

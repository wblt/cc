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
#import "DealViewController.h"
#import "PNChart.h"

static NSString *Identifier = @"cell";

@interface MarketsViewController ()<UITableViewDelegate,UITableViewDataSource,PasswordAlertViewDelegate,OrderListTabCellDelegate,PNChartDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) PasswordAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBuyView;
@property (weak, nonatomic) IBOutlet UIView *bottomSellView;
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
@property (nonatomic) PNLineChart * lineChart;

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
	_buyBtn.selected = YES;
	_sellBtn.selected = NO;
	_bottomSellView.hidden = YES;
	_bottomBuyView.hidden = YES;
    
	[self addNavBtn];
    [self setup];
	[self addChartView];
	
}
	
- (void)addChartView {
	
//	//For Line Chart
//	self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 200.0)];
//	self.lineChart.showCoordinateAxis = YES;
//	self.lineChart.yLabelFormat = @"%1.1f";
//	self.lineChart.xLabelFont = Font_12;
//	self.lineChart.yLabelColor = [UIColor whiteColor];
//	self.lineChart.xLabelColor = [UIColor whiteColor];
//	self.lineChart.backgroundColor = [UIColor clearColor];
//	self.lineChart.showGenYLabels = YES;
//	self.lineChart.showYGridLines = YES;
//	[self.lineChart setXLabels:@[@"4.22", @"4.23", @"4.24", @"4.25", @"4.26", @"4.27", @"4.28"]];
//
//	self.lineChart.yFixedValueMax = 10.0;
//	self.lineChart.yFixedValueMin = -0.5;
//	[self.lineChart setYLabels:@[
//							 								 @"0",
//							 								 @"2",
//							 								 @"4",
//							 								 @"6",
//							 								 @"8",
//							 								 @"10",
//							 								 ]
//							 	 ];
//
//	// Line Chart No.1
//	NSArray * data01Array = @[@2, @4, @1, @3, @7, @5, @9];
//	PNLineChartData *data01 = [PNLineChartData new];
//	data01.color = PNFreshGreen;
//	data01.itemCount = self.lineChart.xLabels.count;
//	data01.dataTitle = @"走势图";
//	data01.showPointLabel = YES;
//	data01.pointLabelColor = [UIColor whiteColor];
//	data01.pointLabelFont = [UIFont systemFontOfSize:8];
//	data01.inflexionPointStyle = PNLineChartPointStyleCircle;
//	data01.inflexionPointColor = [UIColor whiteColor];
//	data01.getData = ^(NSUInteger index) {
//		CGFloat yValue = [data01Array[index] floatValue];
//		return [PNLineChartDataItem dataItemWithY:yValue-0.5 andRawY:yValue];
//	};
//	self.lineChart.chartData = @[data01];
//	[self.chartBgView addSubview:self.lineChart];
//
//	self.lineChart.legendStyle = PNLegendItemStyleStacked;
//	self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
//	self.lineChart.legendFontColor = [UIColor whiteColor];
//	UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
//	[legend setFrame:CGRectMake(30, 240, legend.frame.size.width, legend.frame.size.width)];
//	[self.chartBgView addSubview:legend];
//
//	[self.lineChart strokeChart];
	
}
	
- (IBAction)buyAction:(UIButton *)sender {
	if (!sender.selected) {
		sender.selected = !sender.selected;
	}
	_sellBtn.selected = NO;
//    _bottomBuyView.hidden = NO;
//    _bottomSellView.hidden = YES;
}

- (IBAction)sellAction:(UIButton *)sender {
	if (!sender.selected) {
		sender.selected = !sender.selected;
	}
	_buyBtn.selected = NO;
//    _bottomBuyView.hidden = YES;
//    _bottomSellView.hidden = NO;
}


- (void)addNavBtn {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(0, 0, 40, 30);
	[btn setTitle:@"挂单" forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	btn.titleLabel.font = Font_15;
	
	[btn addTapBlock:^(UIButton *btn) {
		// 去挂单
		DealViewController *vc =[[DealViewController alloc] initWithNibName:@"DealViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
		
	}];
	
	UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
	[self.navigationItem setRightBarButtonItem:anotherButton2];
	
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
    ViewBorderRadius(cell.matchBtn, 6, 0.6,UIColorFromHex(0x4B5461));
    ViewBorderRadius(cell.bgView, 6, 0.6,UIColorFromHex(0x4B5461));
	cell.index = indexPath.row;
	cell.delegate = self;
	[cell.matchBtn setTitle:@"可匹配" forState:UIControlStateNormal];
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


- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex {
	NSLog(@"Click Key on line %f, %f line index is %d and point index is %d", point.x, point.y, (int) lineIndex, (int) pointIndex);
}
	
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex {
	NSLog(@"Click on line %f, %f, line index is %d", point.x, point.y, (int) lineIndex);
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

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
#import "AAChartKit.h"

static NSString *Identifier = @"cell";

@interface MarketsViewController ()<UITableViewDelegate,UITableViewDataSource,PasswordAlertViewDelegate,OrderListTabCellDelegate,PNChartDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) PasswordAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic,strong)AAChartView *aaChartView;

@property (nonatomic,strong)UIButton *dayBtn;
@property (nonatomic,strong)UIButton *weekBtn;

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
    
	[self addNavBtn];
    [self setup];
	[self addChartView];
	
}

- (void)requesKData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_depth];
    [params addParameter:@"TYPE" value:@"0"];
    [params addParameter:@"NUM" value:@"7"];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSDictionary *pd = data[@"pd"];
        
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}
	
- (void)addChartView {
    CGFloat chartViewWidth  = KScreenWidth;
    CGFloat chartViewHeight = 200;
    self.aaChartView = [[AAChartView alloc]init];
   
    self.aaChartView.frame = CGRectMake(0, 30, chartViewWidth, chartViewHeight);
    ////禁用 AAChartView 滚动效果(默认不禁用)
    self.aaChartView.scrollEnabled = NO;
    [self.chartBgView addSubview:self.aaChartView];
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    
    AAMarker *marker = AAObject(AAMarker)
    .fillColorSet(@"#FFFFFF");
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeLine)//设置图表的类型
    .backgroundColorSet(@"#020919")
    .symbolSet(AAChartSymbolTypeCircle)
    .titleSet(@"")//设置图表标题
    .subtitleSet(@"单位¥")//设置图表副标题
    .subtitleFontSizeSet(@13)
    .subtitleAlignSet(AAChartSubtitleAlignTypeRight)
    .subtitleFontColorSet(@"#FFFFFF")
    .categoriesSet(@[@"4.22",@"4.23",@"4.24",@"4.25", @"4.26",@"4.27",@"4.28"])//图表横轴的内容
    .yAxisTitleSet(@"")//设置图表 y 轴的单位
    .dataLabelEnabledSet(YES)
    .yAxisTickPositionsSet(@[@(0),@(2),@(4),@(6),@(8),@(10)])
    .yAxisMaxSet(@10)
    .yAxisMinSet(@0)
    .yAxisLabelsFontColorSet(@"#FFFFFF")
    .xAxisLabelsFontColorSet(@"#FFFFFF")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"走势图")
                 .colorSet(@"#51B24D")
                 .negativeColorSet(@"#AFAg01")
                 .dataSet(@[@1.0, @3.9, @2.5, @9, @4, @8, @2])
                 .markerSet(marker),
                 ])
    
    ;
    
    [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
    
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
    
    self.dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dayBtn.frame = CGRectMake(20, 0, 40, 30);
    [self.dayBtn setTitle:@"日线" forState:UIControlStateNormal];
    [self.dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dayBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    self.dayBtn.selected = YES;
    self.dayBtn.titleLabel.font = Font_13;
    [self.chartBgView addSubview:self.dayBtn];
    MJWeakSelf
    [self.dayBtn addTapBlock:^(UIButton *btn) {
         weakSelf.dayBtn.selected = YES;
        weakSelf.weekBtn.selected = NO;
        
    }];
    
    
    self.weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weekBtn.frame = CGRectMake(70, 0, 40, 30);
    [self.weekBtn setTitle:@"周线" forState:UIControlStateNormal];
    [self.weekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    self.weekBtn.titleLabel.font = Font_13;
    self.weekBtn.selected = NO;
    [self.chartBgView addSubview:self.weekBtn];
    
    [self.weekBtn addTapBlock:^(UIButton *btn) {
        weakSelf.dayBtn.selected = NO;
        weakSelf.weekBtn.selected = YES;
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
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

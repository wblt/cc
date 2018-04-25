//
//  TransferRecordViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "TransferRecordViewController.h"
#import "RecordModel.h"
#import "ReceiveRecordTabCell.h"

static NSString *Identifier = @"cell";

@interface TransferRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;

@end

@implementation TransferRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"转账记录";
	self.data = [NSMutableArray array];
	[self setup];
	[self requestData];
}

- (void)refreshData {
	[self.data removeAllObjects];
	[self.tableView reloadData];
	[self requestData];
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_SENDDETAIL];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	[params addParameter:@"QUERY_ID" value:@"0"];
	[params addParameter:@"TYPE" value:@"1"];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"转账记录" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		NSArray *pd = data[@"pd"];
		if (pd.count == 0) {
			[self showImagePage:YES withIsError:NO];
			return;
		}
		for (NSDictionary *dic in pd) {
			RecordModel *model = [RecordModel mj_objectWithKeyValues:dic];
			[self.data addObject:model];
		}
		[self.tableView reloadData];
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"网络异常"];
	}];
}

- (void)setup {
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerNib:[UINib nibWithNibName:@"ReceiveRecordTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
}

# pragma mark tableView delegate dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 95;
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
	ReceiveRecordTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	ViewBorderRadius(cell.contentView, 6, 0.6,UIColorFromHex(0x4B5461));
	cell.sendModel = self.data[indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
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

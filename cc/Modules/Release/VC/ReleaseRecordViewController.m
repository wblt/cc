//
//  ReleaseRecordViewController.m
//  cc
//
//  Created by wy on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReleaseRecordViewController.h"
#import "AllRecodeTabCell.h"
#import "ReleaseModel.h"
static NSString *Identifier = @"cell";

@interface ReleaseRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,copy)NSString *QUERY_ID;//如果QUERY_ID = 0，则获取最新数据.
@property (nonatomic,copy)NSString *type; //1：向下拉；QUERY_ID =0,该值没意义2：向上拉(必填)

@end

@implementation ReleaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"全部记录";
    
    _QUERY_ID = @"0";
    _type = @"1";
    
	[self setup];
	self.data = [NSMutableArray array];
	[self requestData];
}

- (void)refreshData {
	[self.data removeAllObjects];
	[self.tableView reloadData];
	[self requestData];
}

// 获取释放记录
- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_RELEASEDTTAIIL];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"QUERY_ID" value:_QUERY_ID];
    [params addParameter:@"TYPE" value:_type];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"释放记录" successBlock:^(id data) {
        NSString *code = data[@"code"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
		NSArray *pd = data[@"pd"];
		if (pd.count == 0  && [_QUERY_ID isEqualToString:@"0"]) {
			[self showImagePage:YES withIsError:NO];
			return;
		}
		for (NSDictionary *dic in pd) {
			ReleaseModel *model = [ReleaseModel mj_objectWithKeyValues:dic];
			[self.data addObject:model];
            
            if (pd.lastObject == dic) {
                _QUERY_ID = [NSString stringWithFormat:@"%ld",model.ID];
            }
		}
		[self.tableView reloadData];
		

    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}


- (void)setup {
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerNib:[UINib nibWithNibName:@"AllRecodeTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _QUERY_ID = @"0";
        _type = @"1";
        
        [weakSelf.data removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf requestData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个 block
        _type = @"2";
        [weakSelf requestData];
    }];
}


# pragma mark tableView delegate dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 135;
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
	AllRecodeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	ViewBorderRadius(cell, 8, 0.6, UIColorFromHex(0x4B5461));
	cell.model = self.data[indexPath.row];
	
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

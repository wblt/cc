//
//  NewsVC.m
//  cc
//
//  Created by wy on 2018/4/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "NewsVC.h"
#import "NewsTabCell.h"
#import "NewsDetailsViewController.h"
#import "NoticeModel.h"
static NSString *Identifier = @"cell";

@interface NewsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;
@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"公告";
    self.data = [NSMutableArray array];
    
    [self setup];
    [self requestData];
}

- (void)setup {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
}

- (void)refreshData {
    [self.data removeAllObjects];
    [self requestData];
}

- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_NOTICE];
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"公告" successBlock:^(id data) {
         NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:@"message"];
            return ;
        }
        NSArray *pdAry = data[@"pd"];
        
        if (pdAry.count == 0) {
            [self showImagePage:YES withIsError:NO];
            return;
        }
        
        for (NSDictionary *dic in pdAry) {
            NoticeModel *model = [NoticeModel mj_objectWithKeyValues:dic];
            [self.data addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

# pragma mark tableView delegate dataSourse
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132;
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
    NewsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	ViewBorderRadius(cell.contentView, 6, 0.6,UIColorFromHex(0x4B5461));
    ViewBorderRadius(cell.lookLab, 6, 0.6,UIColorFromHex(0x4B5461));
	cell.model = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsDetailsViewController *vc =[[NewsDetailsViewController alloc] initWithNibName:@"NewsDetailsViewController" bundle:nil];
	
    vc.model = self.data[indexPath.row];
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

//
//  ReleaseRecordViewController.m
//  cc
//
//  Created by wy on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReleaseRecordViewController.h"
#import "AllRecodeTabCell.h"

static NSString *Identifier = @"cell";

@interface ReleaseRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReleaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"全部记录";
	[self setup];
}

// 获取释放记录
- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:@"123"];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"释放记录" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}


- (void)setup {
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerNib:[UINib nibWithNibName:@"AllRecodeTabCell" bundle:nil] forCellReuseIdentifier:Identifier];
}


# pragma mark tableView delegate dataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 8;
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

//
//  ReceiveRecordVC.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReceiveRecordVC.h"

@interface ReceiveRecordVC ()

@end

@implementation ReceiveRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"接收记录";
	[self requestData];
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_RECEIVEDETAIL];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	[params addParameter:@"QUERY_ID" value:@"0"];
	[params addParameter:@"TYPE" value:@"1"];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"接收记录" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"网络异常"];
	}];
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

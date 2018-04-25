//
//  PowerCGViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/24.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "PowerCGViewController.h"

@interface PowerCGViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;

@end

@implementation PowerCGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"能量兑换";
	[self requestData];
	[self setup];
}

- (void)setup {
		ViewBorderRadius(_sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
}


- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_CGENERGYMES];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"能量兑换页面" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"网络异常"];
	}];
}

- (IBAction)sumbitAction:(id)sender {
	
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

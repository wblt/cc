//
//  ZeroWalletVC.m
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ZeroWalletVC.h"
#import "ReleaseRecordViewController.h"

@interface ZeroWalletVC ()
@property (weak, nonatomic) IBOutlet UILabel *todayReleaseLab;
@property (weak, nonatomic) IBOutlet UILabel *bigLab;
@property (weak, nonatomic) IBOutlet UILabel *smallLab;
@property (weak, nonatomic) IBOutlet UILabel *intelligentLab;
@property (weak, nonatomic) IBOutlet UILabel *sportPointLab;
@property (weak, nonatomic) IBOutlet UILabel *nodeLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *totalLab;

@end

@implementation ZeroWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"释放记录";
	[self addViewTap];
	[self setup];
	[self requestData];
}

- (void)requestData {
	RequestParams *params = [[RequestParams alloc] initWithParams:API_RELEASE];
	[params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
	
	[[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
		NSString *code = data[@"code"];
		if (![code isEqualToString:@"1000"]) {
			[SVProgressHUD showErrorWithStatus:data[@"message"]];
			return ;
		}
		/*
		 "pd": {
		 "JD_CURRENCY": "3.00",
		 "STEP_CURRENCY": "4.00",
		 "BIG_CURRENCY": "1.53",
		 "CALCULATE_MONEY": "0.11",
		 "USER_NAME": "haha",
		 "CREATE_TIME": "2018-4-21",
		 "SMALL_CURRENCY": "0.00"
		 },
		 */
		NSDictionary *dic = data[@"pd"];
		self.todayReleaseLab.text = dic[@"CALCULATE_MONEY"];
		self.bigLab.text = dic[@"BIG_CURRENCY"];
		self.smallLab.text = dic[@"SMALL_CURRENCY"];
		self.intelligentLab.text = dic[@"STATIC_CURRENCY"];
		self.sportPointLab.text = dic[@"STEP_CURRENCY"];
		self.nodeLab.text = dic[@"JD_CURRENCY"];
		
	} failureBlock:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
	}];
}

- (void)setup {
	ViewBorderRadius(_bgView, 10, 0.6, UIColorFromHex(0x4B5461));
}

- (void)addViewTap {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(lookAction)];
	_totalLab.userInteractionEnabled = YES;
	[_totalLab addGestureRecognizer:tap];
}

- (void)lookAction {
	ReleaseRecordViewController *vc = [[ReleaseRecordViewController alloc] init];
	
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

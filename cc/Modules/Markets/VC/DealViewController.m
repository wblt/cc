//
//  DealViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/18.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "DealViewController.h"

@interface DealViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bugBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBuyView;
@property (weak, nonatomic) IBOutlet UIView *bottomSellView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"挂单";
	
	[self addViewToScrollerView];
}

- (void)addViewToScrollerView {
	UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
	
	UILabel *hightLab = [[UILabel alloc] init];
	hightLab.text = @"1.234";
	hightLab.textColor = UIColorFromHex(0xCCB17E);
	hightLab.font = Font_13;
	[buyView addSubview:hightLab];
	
	UILabel *hightTipsLab = [[UILabel alloc] init];
	hightLab.text = @"最高价";
	hightLab.font = Font_13;
	[buyView addSubview:hightTipsLab];
	
	UILabel *lowerLab = [[UILabel alloc] init];
	hightLab.text = @"1.234";
	hightLab.textColor = UIColorFromHex(0xCCB17E);
	hightLab.font = Font_13;
	[buyView addSubview:lowerLab];
	
	UILabel *lowerTipsLab = [[UILabel alloc] init];
	hightLab.text = @"最低价";
	hightLab.font = Font_13;
	[buyView addSubview:lowerTipsLab];
	
	UIView *line1 = [[UIView alloc] init];
	[buyView addSubview:line1];
	
	UILabel *priceTipsLab = [[UILabel alloc] init];
	priceTipsLab.text = @"买单价格";
	priceTipsLab.font = Font_13;
	[buyView addSubview:priceTipsLab];
	
	UITextField *priceTextField = [[UITextField alloc] init];
	priceTextField.placeholder = @"请输入价格1.999~2.333的价格";
	
	
	UIView *line2 = [[UIView alloc] init];
	[buyView addSubview:line2];
	
	UILabel *numTipsLab = [[UILabel alloc] init];
	numTipsLab.text = @"数量";
	numTipsLab.font = Font_13;
	[buyView addSubview:numTipsLab];
	
	UITextField *numTextField = [[UITextField alloc] init];
	numTextField.placeholder = @"请输入1~10000的数量";
	
	UILabel *totalPriceLab = [[UILabel alloc] init];
	totalPriceLab.text = @"数量";
	totalPriceLab.font = Font_13;
	[buyView addSubview:totalPriceLab];
	
	UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0xCCB17E));
	[sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
	sumbitBtn.titleLabel.font = Font_14;
	[buyView addSubview:sumbitBtn];
	
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

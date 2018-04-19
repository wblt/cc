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
    [self setup];
	[self addViewToScrollerView];
}

- (void)setup {
    self.scrollerView.contentSize = CGSizeMake(KScreenWidth*2, 300);
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.contentOffset = CGPointMake(0, 0);
}

- (void)addViewToScrollerView {
	UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
   // buyView.backgroundColor = [UIColor darkGrayColor];
    
	UILabel *hightLab = [[UILabel alloc] init];
	hightLab.text = @"1.234";
	hightLab.textColor = UIColorFromHex(0xCCB17E);
	hightLab.font = Font_13;
    hightLab.textAlignment = NSTextAlignmentCenter;
	[buyView addSubview:hightLab];
	
	UILabel *hightTipsLab = [[UILabel alloc] init];
	hightTipsLab.text = @"最高价";
	hightTipsLab.font = Font_13;
    hightTipsLab.textColor = [UIColor whiteColor];
    hightTipsLab.textAlignment = NSTextAlignmentCenter;
	[buyView addSubview:hightTipsLab];
	
	UILabel *lowerLab = [[UILabel alloc] init];
	lowerLab.text = @"1.234";
	lowerLab.textColor = UIColorFromHex(0xCCB17E);
	lowerLab.font = Font_13;
    lowerLab.textAlignment = NSTextAlignmentCenter;
	[buyView addSubview:lowerLab];
	
	UILabel *lowerTipsLab = [[UILabel alloc] init];
	lowerTipsLab.text = @"最低价";
	lowerTipsLab.font = Font_13;
    lowerTipsLab.textColor = [UIColor whiteColor];
    lowerTipsLab.textAlignment = NSTextAlignmentCenter;
	[buyView addSubview:lowerTipsLab];
	
	UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor grayColor];
	[buyView addSubview:line1];
	
	UILabel *priceTipsLab = [[UILabel alloc] init];
	priceTipsLab.text = @"买单价格";
	priceTipsLab.font = Font_13;
    priceTipsLab.textColor = [UIColor whiteColor];
	[buyView addSubview:priceTipsLab];
	
	UITextField *priceTextField = [[UITextField alloc] init];
	priceTextField.placeholder = @"请输入1.999~2.333的价格";
    priceTextField.font = Font_13;
    priceTextField.textColor = [UIColor whiteColor];
    priceTextField.textAlignment = NSTextAlignmentRight;
    [priceTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[buyView addSubview:priceTextField];
	
	UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor grayColor];
	[buyView addSubview:line2];
	
	UILabel *numTipsLab = [[UILabel alloc] init];
	numTipsLab.text = @"转入数量";
	numTipsLab.font = Font_13;
    numTipsLab.textColor = [UIColor whiteColor];
	[buyView addSubview:numTipsLab];
	
	UITextField *numTextField = [[UITextField alloc] init];
	numTextField.placeholder = @"请输入1~10000的数量";
    numTextField.font = Font_13;
    numTextField.textColor = [UIColor whiteColor];
    numTextField.textAlignment = NSTextAlignmentRight;
    [numTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [buyView addSubview:numTextField];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor =  [UIColor grayColor];
    [buyView addSubview:line3];
    
	UILabel *totalPriceLab = [[UILabel alloc] init];
	totalPriceLab.text = @"总价：0";
	totalPriceLab.font = Font_13;
    totalPriceLab.textColor =  [UIColor whiteColor];
	[buyView addSubview:totalPriceLab];
	
	UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0xCCB17E));
	[sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
	sumbitBtn.titleLabel.font = Font_14;
	[buyView addSubview:sumbitBtn];
	
    [self.scrollerView addSubview:buyView];
 
    [hightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyView).offset(5);
        make.left.equalTo(buyView).offset(0);
        make.width.mas_equalTo(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [lowerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyView).offset(5);
        make.left.equalTo(hightLab.mas_right).offset(0);
        make.width.mas_equalTo(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [hightTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hightLab.mas_bottom).offset(0);
        make.left.equalTo(buyView).offset(0);
        make.width.mas_equalTo(KScreenWidth/2);
        make.height.mas_equalTo(30);
    }];
    
    [lowerTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lowerLab.mas_bottom).offset(0);
        make.left.equalTo(hightTipsLab.mas_right).offset(0);
        make.width.mas_equalTo(KScreenWidth/2);
        make.height.mas_equalTo(30);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hightTipsLab.mas_bottom).offset(8);
        make.left.equalTo(buyView).offset(20);
        make.right.equalTo(buyView).offset(-20);
        make.height.mas_equalTo(0.6);
    }];
    
    [priceTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyView).offset(30);
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyView).offset(-30);
        make.left.equalTo(priceTipsLab.mas_right).offset(20);
        make.centerY.equalTo(priceTipsLab);
        make.height.mas_equalTo(40);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTipsLab.mas_bottom).offset(10);
        make.left.equalTo(buyView).offset(20);
        make.right.equalTo(buyView).offset(-20);
        make.height.mas_equalTo(0.6);
    }];
    
    [numTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyView).offset(30);
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyView).offset(-30);
        make.left.equalTo(numTipsLab.mas_right).offset(20);
        make.centerY.equalTo(numTipsLab);
        make.height.mas_equalTo(40);
    }];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numTipsLab.mas_bottom).offset(10);
        make.left.equalTo(buyView).offset(20);
        make.right.equalTo(buyView).offset(-20);
        make.height.equalTo(line1);
    }];
    
    [totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyView).offset(30);
        make.top.equalTo(line3.mas_bottom).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    [sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalPriceLab.mas_bottom).offset(10);
        make.left.equalTo(buyView).offset(20);
        make.right.equalTo(buyView).offset(-20);
        make.height.mas_equalTo(50);
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

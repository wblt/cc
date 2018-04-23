//
//  Transfer ViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "TransferViewController.h"

@interface TransferViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;
@property (weak, nonatomic) IBOutlet UIView *bottomRightView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"转账";
	[self setup];
	[self addLeftViewToScrollerView];
	[self addRightViewToScrollerView];
}

- (void)setup {
	_bottomRightView.hidden = YES;
	
	self.scrollerView.contentSize = CGSizeMake(KScreenWidth*2, 300);
	self.scrollerView.pagingEnabled = YES;
	self.scrollerView.delegate = self;
	self.scrollerView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)returnToPowerPackAction:(UIButton *)sender {
	if (!sender.selected) {
		sender.selected = !sender.selected;
	}
	_rightBtn.selected = NO;
	_bottomLeftView.hidden = NO;
	_bottomRightView.hidden = YES;
	
	[self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)returnToZeroPackAction:(UIButton *)sender {
	if (!sender.selected) {
		sender.selected = !sender.selected;
	}
	_leftBtn.selected = NO;
	_bottomRightView.hidden = NO;
	_bottomLeftView.hidden = YES;
	
	[self.scrollerView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.x == 0) {
		[self returnToPowerPackAction:_leftBtn];
	}else {
		[self returnToZeroPackAction:_rightBtn];
	}
	
}

- (void)addLeftViewToScrollerView {
	UIView *leftView =   [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
	
	UILabel *powerPackLab = [[UILabel alloc] init];
	powerPackLab.text = @"能量钱包余额";
	powerPackLab.font = Font_13;
	powerPackLab.textColor = [UIColor whiteColor];
	[leftView addSubview:powerPackLab];
	
	UILabel *powerLab = [[UILabel alloc] init];
	powerLab.text = @"1.234";
	powerLab.font = Font_13;
	powerLab.textColor = [UIColor whiteColor];//  UIColorFromHex(0xCCB17E);
	powerLab.textAlignment = NSTextAlignmentRight;
	[leftView addSubview:powerLab];
	
	UIView *line1 = [[UIView alloc] init];
	line1.backgroundColor = [UIColor grayColor];
	[leftView addSubview:line1];
	
	UILabel *accountTipsLab = [[UILabel alloc] init];
	accountTipsLab.text = @"转入账号";
	accountTipsLab.font = Font_13;
	accountTipsLab.textColor = [UIColor whiteColor];
	[leftView addSubview:accountTipsLab];
	
	UITextField *accountTextField = [[UITextField alloc] init];
	accountTextField.placeholder = @"请输入对方会员账号";
	accountTextField.font = Font_13;
	accountTextField.textColor = [UIColor whiteColor];
	accountTextField.textAlignment = NSTextAlignmentRight;
	[accountTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
	[leftView addSubview:accountTextField];
	
	UIView *line2 = [[UIView alloc] init];
	line2.backgroundColor = [UIColor grayColor];
	[leftView addSubview:line2];
	
	UILabel *numTipsLab = [[UILabel alloc] init];
	numTipsLab.text = @"转入数量";
	numTipsLab.font = Font_13;
	numTipsLab.textColor = [UIColor whiteColor];
	[leftView addSubview:numTipsLab];
	
	UITextField *numTextField = [[UITextField alloc] init];
	numTextField.placeholder = @"请输入1的倍数";
	numTextField.font = Font_13;
	numTextField.keyboardType = UIKeyboardTypeNumberPad;
	numTextField.textColor = [UIColor whiteColor];
	numTextField.textAlignment = NSTextAlignmentRight;
	[numTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
	[leftView addSubview:numTextField];
	
	UIView *line3 = [[UIView alloc] init];
	line3.backgroundColor = [UIColor grayColor];
	[leftView addSubview:line3];
	
	UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
	[sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
	sumbitBtn.titleLabel.font = Font_14;
	[leftView addSubview:sumbitBtn];
	[sumbitBtn addTapBlock:^(UIButton *btn) {
		if (accountTextField.text.length == 0) {
			[SVProgressHUD showInfoWithStatus:@"请输入对方会员账号"];
			return ;
		}

		if (numTextField.text.integerValue > 10) {
			[SVProgressHUD showErrorWithStatus:@"超过可卖数量"];
			return ;
		}
		
		[SVProgressHUD showSuccessWithStatus:@"转入成功"];
		
	}];
	
	[self.scrollerView addSubview:leftView];
	
	[powerPackLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView).offset(30);
		make.top.equalTo(leftView).offset(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
	}];
	
	[powerLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(powerPackLab.mas_right).offset(30);
		make.right.equalTo(leftView).offset(-30);
		make.top.equalTo(leftView).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView).offset(20);
		make.right.equalTo(leftView).offset(-20);
		make.top.equalTo(powerPackLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	
	[accountTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView).offset(30);
		make.top.equalTo(line1.mas_bottom).offset(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
	}];
	
	[accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(accountTipsLab.mas_right).offset(30);
		make.right.equalTo(leftView).offset(-30);
		make.top.equalTo(line1.mas_bottom).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView).offset(20);
		make.right.equalTo(leftView).offset(-20);
		make.top.equalTo(accountTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[numTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView).offset(30);
		make.top.equalTo(line2.mas_bottom).offset(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
	}];
	
	[numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(numTipsLab.mas_right).offset(30);
		make.right.equalTo(leftView).offset(-30);
		make.top.equalTo(line2).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView).offset(20);
		make.right.equalTo(leftView).offset(-20);
		make.top.equalTo(numTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(line3.mas_bottom).offset(10);
		make.left.equalTo(leftView).offset(20);
		make.right.equalTo(leftView).offset(-20);
		make.height.mas_equalTo(50);
	}];
	
	
}

- (void)addRightViewToScrollerView {
	UIView *rightView =   [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 300)];
	
	UILabel *powerPackLab = [[UILabel alloc] init];
	powerPackLab.text = @"零钱包余额";
	powerPackLab.font = Font_13;
	powerPackLab.textColor = [UIColor whiteColor];
	[rightView addSubview:powerPackLab];
	
	UILabel *powerLab = [[UILabel alloc] init];
	powerLab.text = @"1.234";
	powerLab.font = Font_13;
	powerLab.textColor =  [UIColor whiteColor];//UIColorFromHex(0xCCB17E);
	powerLab.textAlignment = NSTextAlignmentRight;
	[rightView addSubview:powerLab];
	
	UIView *line1 = [[UIView alloc] init];
	line1.backgroundColor = [UIColor grayColor];
	[rightView addSubview:line1];
	
	UILabel *accountTipsLab = [[UILabel alloc] init];
	accountTipsLab.text = @"转入账号";
	accountTipsLab.font = Font_13;
	accountTipsLab.textColor = [UIColor whiteColor];
	[rightView addSubview:accountTipsLab];
	
	UITextField *accountTextField = [[UITextField alloc] init];
	accountTextField.placeholder = @"请输入对方区块链地址";
	accountTextField.font = Font_13;
	accountTextField.textColor = [UIColor whiteColor];
	accountTextField.textAlignment = NSTextAlignmentRight;
	[accountTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
	[rightView addSubview:accountTextField];
	
	UIView *line2 = [[UIView alloc] init];
	line2.backgroundColor = [UIColor grayColor];
	[rightView addSubview:line2];
	
	UILabel *numTipsLab = [[UILabel alloc] init];
	numTipsLab.text = @"转入数量";
	numTipsLab.font = Font_13;
	numTipsLab.textColor = [UIColor whiteColor];
	[rightView addSubview:numTipsLab];
	
	UITextField *numTextField = [[UITextField alloc] init];
	numTextField.placeholder = @"请输入1的倍数";
	numTextField.font = Font_13;
	numTextField.keyboardType = UIKeyboardTypeNumberPad;
	numTextField.textColor = [UIColor whiteColor];
	numTextField.textAlignment = NSTextAlignmentRight;
	[numTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
	[rightView addSubview:numTextField];
	
	UIView *line3 = [[UIView alloc] init];
	line3.backgroundColor = [UIColor grayColor];
	[rightView addSubview:line3];
	
	UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
	[sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
	sumbitBtn.titleLabel.font = Font_14;
	[rightView addSubview:sumbitBtn];
	[sumbitBtn addTapBlock:^(UIButton *btn) {
		if (accountTextField.text.length == 0) {
			[SVProgressHUD showInfoWithStatus:@"请输入区块链地址"];
			return ;
		}
		if (numTextField.text.integerValue > 10) {
			[SVProgressHUD showErrorWithStatus:@"超过可卖数量"];
			return ;
		}
		[SVProgressHUD showSuccessWithStatus:@"转入成功"];
		
	}];
	
	[self.scrollerView addSubview:rightView];
	
	[powerPackLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(rightView).offset(30);
		make.top.equalTo(rightView).offset(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
	}];
	
	[powerLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(powerPackLab.mas_right).offset(30);
		make.right.equalTo(rightView).offset(-30);
		make.top.equalTo(rightView).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(rightView).offset(20);
		make.right.equalTo(rightView).offset(-20);
		make.top.equalTo(powerPackLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	
	[accountTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(rightView).offset(30);
		make.top.equalTo(line1).offset(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
	}];
	
	[accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(accountTipsLab.mas_right).offset(30);
		make.right.equalTo(rightView).offset(-30);
		make.top.equalTo(line1.mas_bottom).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(rightView).offset(20);
		make.right.equalTo(rightView).offset(-20);
		make.top.equalTo(accountTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[numTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(rightView).offset(30);
		make.top.equalTo(line2.mas_bottom).offset(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
	}];
	
	[numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(numTipsLab.mas_right).offset(30);
		make.right.equalTo(rightView).offset(-30);
		make.top.equalTo(line2.mas_bottom).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(rightView).offset(20);
		make.right.equalTo(rightView).offset(-20);
		make.top.equalTo(numTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(line3.mas_bottom).offset(10);
		make.left.equalTo(rightView).offset(20);
		make.right.equalTo(rightView).offset(-20);
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

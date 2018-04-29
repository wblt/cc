//
//  DealViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/18.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "DealViewController.h"
@interface DealViewController ()<UIScrollViewDelegate>{
    UILabel *guideLab;
    UILabel *sellPriceLab;
    UITextField *sellNumTextField;
    UILabel *sellTotalPriceLab;
    UILabel *chargeLab;
}

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"挂卖单";
    [self setup];
	//[self addBuyViewToScrollerView];
	[self addSellViewToScrollerView];
}

- (void)setup {
    
}


//- (void)addBuyViewToScrollerView {
//    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
//   // buyView.backgroundColor = [UIColor darkGrayColor];
//
//    UILabel *hightLab = [[UILabel alloc] init];
//    hightLab.text = @"1.234";
//    hightLab.textColor =  [UIColor whiteColor]; // UIColorFromHex(0xCCB17E);
//    hightLab.font = Font_13;
//    hightLab.textAlignment = NSTextAlignmentCenter;
//    [buyView addSubview:hightLab];
//
//    UILabel *hightTipsLab = [[UILabel alloc] init];
//    hightTipsLab.text = @"最高价";
//    hightTipsLab.font = Font_13;
//    hightTipsLab.textColor = [UIColor whiteColor];
//    hightTipsLab.textAlignment = NSTextAlignmentCenter;
//    [buyView addSubview:hightTipsLab];
//
//    UILabel *lowerLab = [[UILabel alloc] init];
//    lowerLab.text = @"1.234";
//    lowerLab.textColor = [UIColor whiteColor]; //UIColorFromHex(0xCCB17E);
//    lowerLab.font = Font_13;
//    lowerLab.textAlignment = NSTextAlignmentCenter;
//    [buyView addSubview:lowerLab];
//
//    UILabel *lowerTipsLab = [[UILabel alloc] init];
//    lowerTipsLab.text = @"最低价";
//    lowerTipsLab.font = Font_13;
//    lowerTipsLab.textColor = [UIColor whiteColor];
//    lowerTipsLab.textAlignment = NSTextAlignmentCenter;
//    [buyView addSubview:lowerTipsLab];
//
//    UIView *line1 = [[UIView alloc] init];
//    line1.backgroundColor = [UIColor grayColor];
//    [buyView addSubview:line1];
//
//    UILabel *priceTipsLab = [[UILabel alloc] init];
//    priceTipsLab.text = @"买单价格";
//    priceTipsLab.font = Font_13;
//    priceTipsLab.textColor = [UIColor whiteColor];
//    [buyView addSubview:priceTipsLab];
//
//    UITextField *priceTextField = [[UITextField alloc] init];
//    priceTextField.placeholder = @"请输入1.999~2.333的价格";
//    priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    priceTextField.font = Font_13;
//    priceTextField.textColor = [UIColor whiteColor];
//    priceTextField.textAlignment = NSTextAlignmentRight;
//    [priceTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [buyView addSubview:priceTextField];
//
//    UIView *line2 = [[UIView alloc] init];
//    line2.backgroundColor = [UIColor grayColor];
//    [buyView addSubview:line2];
//
//    UILabel *numTipsLab = [[UILabel alloc] init];
//    numTipsLab.text = @"转入数量";
//    numTipsLab.font = Font_13;
//    numTipsLab.textColor = [UIColor whiteColor];
//    [buyView addSubview:numTipsLab];
//
//    UITextField *numTextField = [[UITextField alloc] init];
//    numTextField.placeholder = @"请输入1~10000的数量";
//    numTextField.font = Font_13;
//    numTextField.keyboardType = UIKeyboardTypeNumberPad;
//    numTextField.textColor = [UIColor whiteColor];
//    numTextField.textAlignment = NSTextAlignmentRight;
//    [numTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [buyView addSubview:numTextField];
//
//    UIView *line3 = [[UIView alloc] init];
//    line3.backgroundColor =  [UIColor grayColor];
//    [buyView addSubview:line3];
//
//    UILabel *totalPriceLab = [[UILabel alloc] init];
//    totalPriceLab.text = @"总价：0";
//    totalPriceLab.font = Font_13;
//    totalPriceLab.textColor =  [UIColor whiteColor];
//    [buyView addSubview:totalPriceLab];
//
//    UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
//    [sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    sumbitBtn.titleLabel.font = Font_14;
//    [buyView addSubview:sumbitBtn];
//    [sumbitBtn addTapBlock:^(UIButton *btn) {
//        if (numTextField.text.length == 0 || priceTextField.text.length == 0) {
//            [SVProgressHUD showInfoWithStatus:@"请输入数量及单价"];
//            return ;
//        }
//
//        if (numTextField.text.integerValue > 10) {
//            [SVProgressHUD showErrorWithStatus:@"超过可卖数量"];
//            return ;
//        }
//
//    }];
//
//    [self.scrollerView addSubview:buyView];
//
//    [hightLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buyView).offset(5);
//        make.left.equalTo(buyView).offset(0);
//        make.width.mas_equalTo(KScreenWidth/2);
//        make.height.mas_equalTo(21);
//    }];
//
//    [lowerLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(buyView).offset(5);
//        make.left.equalTo(hightLab.mas_right).offset(0);
//        make.width.mas_equalTo(KScreenWidth/2);
//        make.height.mas_equalTo(21);
//    }];
//
//    [hightTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(hightLab.mas_bottom).offset(0);
//        make.left.equalTo(buyView).offset(0);
//        make.width.mas_equalTo(KScreenWidth/2);
//        make.height.mas_equalTo(30);
//    }];
//
//    [lowerTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lowerLab.mas_bottom).offset(0);
//        make.left.equalTo(hightTipsLab.mas_right).offset(0);
//        make.width.mas_equalTo(KScreenWidth/2);
//        make.height.mas_equalTo(30);
//    }];
//
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(hightTipsLab.mas_bottom).offset(8);
//        make.left.equalTo(buyView).offset(20);
//        make.right.equalTo(buyView).offset(-20);
//        make.height.mas_equalTo(0.6);
//    }];
//
//    [priceTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(buyView).offset(30);
//        make.top.equalTo(line1.mas_bottom).offset(10);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(30);
//    }];
//
//    [priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(buyView).offset(-30);
//        make.left.equalTo(priceTipsLab.mas_right).offset(20);
//        make.centerY.equalTo(priceTipsLab);
//        make.height.mas_equalTo(40);
//    }];
//
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(priceTipsLab.mas_bottom).offset(10);
//        make.left.equalTo(buyView).offset(20);
//        make.right.equalTo(buyView).offset(-20);
//        make.height.mas_equalTo(0.6);
//    }];
//
//    [numTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(buyView).offset(30);
//        make.top.equalTo(line2.mas_bottom).offset(10);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(30);
//    }];
//
//    [numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(buyView).offset(-30);
//        make.left.equalTo(numTipsLab.mas_right).offset(20);
//        make.centerY.equalTo(numTipsLab);
//        make.height.mas_equalTo(40);
//    }];
//
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(numTipsLab.mas_bottom).offset(10);
//        make.left.equalTo(buyView).offset(20);
//        make.right.equalTo(buyView).offset(-20);
//        make.height.equalTo(line1);
//    }];
//
//    [totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(buyView).offset(30);
//        make.top.equalTo(line3.mas_bottom).offset(10);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(30);
//    }];
//
//    [sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(totalPriceLab.mas_bottom).offset(10);
//        make.left.equalTo(buyView).offset(20);
//        make.right.equalTo(buyView).offset(-20);
//        make.height.mas_equalTo(50);
//    }];
//}

- (void)addSellViewToScrollerView {
	UIView *sellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
	
	UILabel * guideTipsLab = [[UILabel alloc] init];
	guideTipsLab.text = @"指导价";
	guideTipsLab.font = Font_13;
	guideTipsLab.textColor = [UIColor whiteColor];
	[sellView addSubview:guideTipsLab];
	
	guideLab = [[UILabel alloc] init];
	guideLab.text = @"1.234";
	guideLab.font = Font_13;
    guideLab.textColor = [UIColor whiteColor];// UIColorFromHex(0xCCB17E);
	guideLab.textAlignment = NSTextAlignmentRight;
	[sellView addSubview:guideLab];
	
	UIView *line1 = [[UIView alloc] init];
	line1.backgroundColor = [UIColor grayColor];
	[sellView addSubview:line1];
	
	UILabel *sellPriceTipsLab = [[UILabel alloc] init];
	sellPriceTipsLab.text = @"卖单价格";
	sellPriceTipsLab.font = Font_13;
	sellPriceTipsLab.textColor = [UIColor whiteColor];
	[sellView addSubview:sellPriceTipsLab];
    
	sellPriceLab = [[UILabel alloc] init];
	sellPriceLab.text = @"1.234";
	sellPriceLab.font = Font_13;
    sellPriceLab.textColor = [UIColor whiteColor] ;//UIColorFromHex(0xCCB17E);
	sellPriceLab.textAlignment = NSTextAlignmentRight;
	[sellView addSubview:sellPriceLab];
	
	
	UIView *line2 = [[UIView alloc] init];
	line2.backgroundColor = [UIColor grayColor];
	[sellView addSubview:line2];
	
	UILabel *sellNumTipsLab = [[UILabel alloc] init];
	sellNumTipsLab.text = @"卖单数量";
	sellNumTipsLab.font = Font_13;
	sellNumTipsLab.textColor = [UIColor whiteColor];
	[sellView addSubview:sellNumTipsLab];
	
	sellNumTextField = [[UITextField alloc] init];
	sellNumTextField.placeholder = @"请输入100~100000的价格";
	sellNumTextField.font = Font_13;
	sellNumTextField.keyboardType = UIKeyboardTypeNumberPad;
	sellNumTextField.textColor = [UIColor whiteColor];
	sellNumTextField.textAlignment = NSTextAlignmentRight;
	[sellNumTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
	[sellView addSubview:sellNumTextField];
	
	UIView *line3 = [[UIView alloc] init];
	line3.backgroundColor = [UIColor grayColor];
	[sellView addSubview:line3];
	
	sellTotalPriceLab = [[UILabel alloc] init];
	sellTotalPriceLab.text = @"总价：0";
	sellTotalPriceLab.font = Font_13;
	sellTotalPriceLab.textColor = [UIColor whiteColor];
	[sellView addSubview:sellTotalPriceLab];
	
	chargeLab = [[UILabel alloc] init];
	chargeLab.text = @"手续费：0";
	chargeLab.font = Font_13;
	chargeLab.textColor = [UIColor whiteColor];
	chargeLab.textAlignment = NSTextAlignmentRight;
	[sellView addSubview:chargeLab];
	
	UIButton *sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	ViewBorderRadius(sumbitBtn, 10, 0.6, UIColorFromHex(0x4B5461));
	[sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
	sumbitBtn.titleLabel.font = Font_14;
	[sellView addSubview:sumbitBtn];
	[sumbitBtn addTapBlock:^(UIButton *btn) {
		if (sellNumTextField.text.length == 0) {
			[SVProgressHUD showInfoWithStatus:@"请输入数量"];
			return ;
		}
		
		if (sellNumTextField.text.integerValue > 10) {
			[SVProgressHUD showErrorWithStatus:@"超过可卖数量"];
			return ;
		}
        
        
		
	}];
	
	UILabel *tipsLab = [[UILabel alloc] init];
	tipsLab.textColor =  [UIColor whiteColor];
	tipsLab.font = Font_13;
	tipsLab.textAlignment = NSTextAlignmentCenter;
	tipsLab.attributedText = [Util setAllText:@"本次可挂卖最多5000个" andSpcifiStr:@"5000" withColor:UIColorFromHex(0xFFFFFF) specifiStrFont:Font_13];
	[sellView addSubview:tipsLab];
	
	[self.view addSubview:sellView];
	
	[guideTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(30);
		make.top.equalTo(sellView).offset(20);
		make.width.mas_equalTo(60);
		make.height.mas_equalTo(30);
	}];
	
	[guideLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(guideTipsLab.mas_right).offset(30);
		make.right.equalTo(sellView).offset(-30);
		make.top.equalTo(sellView).offset(20);
		make.height.mas_equalTo(30);
	}];
	
	[line1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(20);
		make.right.equalTo(sellView).offset(-20);
		make.top.equalTo(guideTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[sellPriceTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(30);
		make.top.equalTo(line1.mas_bottom).offset(10);
		make.width.mas_equalTo(60);
		make.height.mas_equalTo(30);
	}];
	
	[sellPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellPriceTipsLab.mas_right).offset(30);
		make.right.equalTo(sellView).offset(-30);
		make.top.equalTo(line1.mas_bottom).offset(10);
		make.height.mas_equalTo(30);
	}];
	
	[line2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(20);
		make.right.equalTo(sellView).offset(-20);
		make.top.equalTo(sellPriceTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[sellNumTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(30);
		make.top.equalTo(line2.mas_bottom).offset(10);
		make.width.mas_equalTo(60);
		make.height.mas_equalTo(30);
	}];
	
	[sellNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellNumTipsLab.mas_right).offset(30);
		make.right.equalTo(sellView).offset(-30);
		make.top.equalTo(line2.mas_bottom).offset(10);
		make.height.mas_equalTo(30);
	}];
	
	[line3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(20);
		make.right.equalTo(sellView).offset(-20);
		make.top.equalTo(sellNumTipsLab.mas_bottom).offset(10);
		make.height.mas_equalTo(0.6);
	}];
	
	[sellTotalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellView).offset(30);
		make.top.equalTo(line3.mas_bottom).offset(10);
		make.width.mas_equalTo(120);
		make.height.mas_equalTo(30);
	}];
	
	[chargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(sellTotalPriceLab.mas_right).offset(20);
		make.right.equalTo(sellView).offset(-30);
		make.top.equalTo(line3.mas_bottom).offset(10);
		make.height.mas_equalTo(30);
	}];
	
	[sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(sellTotalPriceLab.mas_bottom).offset(10);
		make.left.equalTo(sellView).offset(20);
		make.right.equalTo(sellView).offset(-20);
		make.height.mas_equalTo(50);
	}];
	
	[tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(sumbitBtn.mas_bottom).offset(10);
		make.left.equalTo(sellView).offset(20);
		make.right.equalTo(sellView).offset(-20);
		make.height.mas_equalTo(30);
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

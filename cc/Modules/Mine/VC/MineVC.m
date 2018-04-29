//
//  MineVC.m
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineVC.h"
#import "SettingViewController.h"
#import "MineInfoViewController.h"
#import "MyOrderViewController.h"
#import "CompoundSettingViewController.h"
#import "TransferViewController.h"
#import "TransferRecordViewController.h"
#import "MoneyTransferViewController.h"
#import "WalletExchangeViewController.h"
#import "UserInfoModel.h"
#import "PowerCGViewController.h"
#import "ReceiveRecordVC.h"
#import "SportRecordViewController.h"
#import "ReceiveAddressViewController.h"
#import "WCQRCodeScanningVC.h"
@interface MineVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;
@property (weak, nonatomic) IBOutlet UIView *bgView7;
@property (weak, nonatomic) IBOutlet UIView *bgView8;
@property (weak, nonatomic) IBOutlet UIView *bgView9;
@property (weak, nonatomic) IBOutlet UIView *bgView10;
@property (weak, nonatomic) IBOutlet UIView *bgView11;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel *walletNumLab;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@end

@implementation MineVC


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// 获取当前数据
	UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	self.nameLab.text = model.USER_NAME;
	self.walletAddressLab.text = model.W_ADDRESS;
	self.walletNumLab.text = model.W_ENERGY;
	[_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"我的";
	[self setup];
	[self addTapAction];
}

- (void)setup {
	ViewBorderRadius(_bgView1, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView2, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView3, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView4, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView5, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView6, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView7, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView8, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView9, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView10, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView11, 0, 0.6, UIColorFromHex(0x4B5461));
	
    UIImageView *saoyisaoImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    saoyisaoImgView.userInteractionEnabled = YES;
    saoyisaoImgView.image = [UIImage imageNamed:@"saoyisao"];
    UIBarButtonItem *leftAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:saoyisaoImgView];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: leftAnotherButton,nil]];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saoyisaoAction)];
    [saoyisaoImgView addGestureRecognizer:leftTap];
    
	UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	newsImgView.userInteractionEnabled = YES;
	newsImgView.image = [UIImage imageNamed:@"setting_icon"];
	UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newsImgView];
	[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingAction:)];
	[newsImgView addGestureRecognizer:tap];
	
	
	UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap)];
	self.nameLab.userInteractionEnabled = YES;
	[self.nameLab addGestureRecognizer:nameTap];
	
	UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap)];
	self.rightImgView.userInteractionEnabled = YES;
	[self.rightImgView addGestureRecognizer:imgTap];

}

- (IBAction)copyWalletAddressAction:(id)sender {
	if (self.walletAddressLab.text.length == 0) {
		[SVProgressHUD showErrorWithStatus:@"复制失败"];
		return;
	}
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	[pasteboard setString:self.walletAddressLab.text];
	[SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)saoyisaoAction {
    WCQRCodeScanningVC *vc = [[WCQRCodeScanningVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)rightTap {
	MineInfoViewController *vc = [[MineInfoViewController alloc] initWithNibName:@"MineInfoViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)settingAction:(UITapGestureRecognizer *)tap {
	SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
	
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)addTapAction {
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView3 addGestureRecognizer:tap1];
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView4 addGestureRecognizer:tap2];
	
	UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView5 addGestureRecognizer:tap3];
	
	UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView6 addGestureRecognizer:tap4];
	
	UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView7 addGestureRecognizer:tap5];
	
	UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView8 addGestureRecognizer:tap6];
	
	UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
	[_bgView11 addGestureRecognizer:tap7];
    
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
    [_bgView9 addGestureRecognizer:tap8];
    
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapAction:)];
    [_bgView10 addGestureRecognizer:tap9];
	
}

- (void)ViewTapAction:(UITapGestureRecognizer *)tap {
	NSInteger tag = tap.view.tag;
	switch (tag) {
		case 100:
		{
			MyOrderViewController *vc = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
			
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 101:
		{
			CompoundSettingViewController *vc = [[CompoundSettingViewController alloc] initWithNibName:@"CompoundSettingViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 102:
		{
//			TransferViewController *vc = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];
//			[self.navigationController pushViewController:vc animated:YES];
			MoneyTransferViewController *vc = [[MoneyTransferViewController alloc] initWithNibName:@"MoneyTransferViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
			
		}
			break;
		case 103:
		{
			TransferRecordViewController *vc = [[TransferRecordViewController alloc] initWithNibName:@"TransferRecordViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 104:
		{
			ReceiveRecordVC *vc = [[ReceiveRecordVC alloc] initWithNibName:@"ReceiveRecordVC" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 105:
		{
			PowerCGViewController *vc = [[PowerCGViewController alloc] initWithNibName:@"PowerCGViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
			
		}
			break;
		case 106:
		{
			SportRecordViewController *vc = [[SportRecordViewController alloc] initWithNibName:@"SportRecordViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 107:
		{
            ReceiveAddressViewController *vc = [[ReceiveAddressViewController alloc] initWithNibName:@"ReceiveAddressViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
			
		}
			break;
        case 108:
        {
            [SVProgressHUD showInfoWithStatus:@"正在开发中"];
        }
            break;
			
		default:
			break;
	}
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

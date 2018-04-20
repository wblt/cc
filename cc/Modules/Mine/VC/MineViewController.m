//
//  MineViewController.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineViewController.h"
#import "SettingViewController.h"
#import "MineInfoViewController.h"
#import "MyOrderViewController.h"
#import "CompoundSettingViewController.h"
#import "TransferViewController.h"
#import "TransferRecordViewController.h"
#import "WalletExchangeViewController.h"
@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *editimgView;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
	[self addTapAction];
    [self setup];
}

- (void)addTapAction {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_userImgView addGestureRecognizer:tap];
	UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_nameLab addGestureRecognizer:tap1];
	UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_editimgView addGestureRecognizer:tap2];
	
	UITapGestureRecognizer *tapView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
	[_bgView1 addGestureRecognizer:tapView1];
	
	UITapGestureRecognizer *tapView2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
	[_bgView2 addGestureRecognizer:tapView2];
	UITapGestureRecognizer *tapView3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
	[_bgView3 addGestureRecognizer:tapView3];
	UITapGestureRecognizer *tapView4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
	[_bgView4 addGestureRecognizer:tapView4];
	UITapGestureRecognizer *tapView5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
	[_bgView5 addGestureRecognizer:tapView5];
	
}

- (void)tapAction {
	MineInfoViewController *vc = [[MineInfoViewController alloc] initWithNibName:@"MineInfoViewController" bundle:nil];
	
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)viewTapAction:(UITapGestureRecognizer *)tap {
	NSInteger tag = tap.view.tag;
	switch (tag) {
		case 101:
		{
			MyOrderViewController *vc = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
			
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 102:
		{
			CompoundSettingViewController *vc = [[CompoundSettingViewController alloc] initWithNibName:@"CompoundSettingViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 103:
		{
			TransferViewController *vc = [[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 104:
		{
			TransferRecordViewController *vc = [[TransferRecordViewController alloc] initWithNibName:@"TransferRecordViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
		}
			break;
		case 105:
		{
			WalletExchangeViewController *vc = [[WalletExchangeViewController alloc] initWithNibName:@"WalletExchangeViewController" bundle:nil];
			[self.navigationController pushViewController:vc animated:YES];
			
		}
			break;
			
		default:
			break;
	}
}

- (void)setup {
    UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newsImgView.userInteractionEnabled = YES;
    newsImgView.image = [UIImage imageNamed:@"setting_icon"];
    UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newsImgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingAction:)];
    [newsImgView addGestureRecognizer:tap];
}

- (void)settingAction:(UITapGestureRecognizer *)tap {
    SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)copyAddressAction:(id)sender {
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

//
//  ReleaseViewController.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReleaseViewController.h"
#import "HashrateShifToWalletVC.h"
#import "NewsVC.h"
#import "ZoreWalletVC.h"
#import "InvitionFriendVC.h"
@interface ReleaseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shiftToHashrateBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *hashrateView;
@property (weak, nonatomic) IBOutlet UIView *ZeroView;


@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeTop;
    _shiftToHashrateBtn.adjustsImageWhenHighlighted = NO;
    _inviteBtn.adjustsImageWhenHighlighted = NO;
    [self addNavView];
    [self addtapView];
}



-(void)addNavView {
    
    UIImageView *imgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imgView.image = [UIImage imageNamed:@"head"];
    UIBarButtonItem *imgItm = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 120, 30);
    [btn setTitle:@"点击查看我的朋友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Font_13;
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: imgItm,anotherButton2,nil]];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookClick)];
    [imgView addGestureRecognizer:tap1];
    
    
    UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newsImgView.image = [UIImage imageNamed:@"xinfeng"];
    UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newsImgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsClick)];
    [newsImgView addGestureRecognizer:tap];
}

- (void)addtapView {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hashrateTapAction)];
    _hashrateView.userInteractionEnabled = YES;
    [_hashrateView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zeroTapAction)];
    _ZeroView.userInteractionEnabled = YES;
    [_ZeroView addGestureRecognizer:tap2];
}

- (void)hashrateTapAction {
    
}

- (void)zeroTapAction {
    ZoreWalletVC *vc = [[ZoreWalletVC alloc] initWithNibName:@"ZoreWalletVC" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookClick{
    
}

- (void)newsClick {
    NewsVC *vc = [[NewsVC alloc] initWithNibName:@"NewsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shiftToWalletAction:(id)sender {
    HashrateShifToWalletVC *vc = [[HashrateShifToWalletVC alloc] initWithNibName:@"HashrateShifToWalletVC" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)inviteFriendsAction:(id)sender {
    InvitionFriendVC *vc = [[InvitionFriendVC alloc] initWithNibName:@"InvitionFriendVC" bundle:nil];
    
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

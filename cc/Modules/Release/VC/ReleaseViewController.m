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
#import "ZeroWalletVC.h"
#import "InvitionFriendVC.h"
#import "QLCycleProgressView.h"
#import "MyFriendsViewController.h"
#import "UserInfoModel.h"
@interface ReleaseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shiftToHashrateBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *hashrateView;
@property (weak, nonatomic) IBOutlet UIView *ZeroView;
@property (weak, nonatomic) IBOutlet UIView *centerBgView;
@property (weak, nonatomic) IBOutlet UILabel *sNumLab;
@property (weak, nonatomic) IBOutlet UILabel *dNumLab;

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) QLCycleProgressView *progressView;
@property (nonatomic, strong) UIImageView *birdImage;
@end

@implementation ReleaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updataDayStep];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeTop;
    _shiftToHashrateBtn.adjustsImageWhenHighlighted = NO;
    _inviteBtn.adjustsImageWhenHighlighted = NO;
    [self addNavView];
	[self addheadthView];
    [self addtapView];
	[self requestData];
}

// 获取首页数据
- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_HOMEPAGE];
    
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
		
		NSDictionary *dic = data[@"pd"];
		UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dic];
		[[BeanManager shareInstace] setBean:model path:UserModelPath];
		[_headImage sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
		_sNumLab.text = model.S_CURRENCY;
		_dNumLab.text = model.D_CURRENCY;
		
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

- (void)updataDayStep {
    // 记录步数
    RequestParams *params = [[RequestParams alloc] initWithParams:API_DAYSTEP];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"USER_STEP" value:@"0"];
    [params addParameter:@"CREATE_TIME" value:[Util getCurrentTime]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"记录步数" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

-(void)addNavView {
    
    _headImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _headImage.image = [UIImage imageNamed:@"logo"];
    UIBarButtonItem *imgItm = [[UIBarButtonItem alloc] initWithCustomView:_headImage];
	
	UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
	_nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	_nameLab.textColor = [UIColor whiteColor];
	_nameLab.font = Font_11;
	_nameLab.text = [SPUtil objectForKey:k_app_userNumber];
	[bgView addSubview:_nameLab];
	
	UILabel *friendsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 110, 20)];
	friendsLab.userInteractionEnabled = YES;
	friendsLab.textColor = [UIColor whiteColor];
	friendsLab.font = Font_12;
	friendsLab.text = @"点击查看我的朋友";
	[bgView addSubview:friendsLab];
	
	UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookClick)];
	[friendsLab addGestureRecognizer:friendTap];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: imgItm,anotherButton2,nil]];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookClick)];
    [_headImage addGestureRecognizer:tap1];
	
    UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newsImgView.image = [UIImage imageNamed:@"xinfeng"];
    UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newsImgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsClick)];
    [newsImgView addGestureRecognizer:tap];
    
    ViewBorderRadius(_shiftToHashrateBtn, 6, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_inviteBtn, 6, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_hashrateView, 10, 0.6,  UIColorFromHex(0x4B5461));
    ViewBorderRadius(_ZeroView, 10, 0.6,  UIColorFromHex(0x4B5461));
}

- (void)addheadthView {
	[_centerBgView addSubview:self.progressView];
	_progressView.progress = .0;
	_progressView.mainColor = [UIColor redColor];
	_progressView.fillColor = [UIColor whiteColor];
	_progressView.line_width = 15;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		_progressView.stepNum = 6000;
		_progressView.progress = .6;
		
	});
	//动画小人
	 _birdImage = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/2-50, 200, 100, 100)]; //实例化一个图片视图
//	 [_birdImage setAnimationImages:self.imageArr];把保存了图片的数组放进去
//	 _birdImage.animationRepeatCount = 0;
//	 _birdImage.animationDuration = 1;//每隔多少秒切换图片
//	 [_birdImage startAnimating];//开始动画
	_birdImage.image = [UIImage imageNamed:@"big_logo"];
	 [_centerBgView addSubview:_birdImage];//添加视图
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
    ZeroWalletVC *vc = [[ZeroWalletVC alloc] initWithNibName:@"ZeroWalletVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookClick{
	MyFriendsViewController *vc = [[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
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

- (QLCycleProgressView *)progressView {
	if (!_progressView) {
		_progressView = [[QLCycleProgressView alloc]initWithFrame:CGRectMake(KScreenWidth/2-80,30 , 160, 160)];
	}
	return _progressView;
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

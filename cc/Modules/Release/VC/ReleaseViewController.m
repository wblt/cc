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
#import "QLCycleProgressView.h"
#import "MyFriendsViewController.h"
@interface ReleaseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shiftToHashrateBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *hashrateView;
@property (weak, nonatomic) IBOutlet UIView *ZeroView;
@property (weak, nonatomic) IBOutlet UIView *centerBgView;

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
        /*
         "pd": {
         "W_ENERGY": 0,
         "D_CURRENCY": 499,
         "HEAD_URL": "http://shcunion.vip.img.800cdn.com/ala/fj/apple2.png",
         "W_ADDRESS": "243213feb0824c6986633cb1c336a3da8162a6ff490448419a6a29d6bb243359",
         "USER_NAME": "jun",
         "S_CURRENCY": 10004,
         "NICK_NAME": "jun"
         },
         */
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

- (void)updataDayStep {
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_DAYSTEP];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"USER_STEP" value:@"0"];
    [params addParameter:@"CREATE_TIME" value:[Util getCurrentTime]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"" successBlock:^(id data) {
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
    
    UIImageView *imgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imgView.image = [UIImage imageNamed:@"head"];
    UIBarButtonItem *imgItm = [[UIBarButtonItem alloc] initWithCustomView:imgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 120, 30);
    [btn setTitle:@"点击查看我的朋友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = Font_13;
    [btn addTapBlock:^(UIButton *btn) {
        MyFriendsViewController *vc = [[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
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

- (void)addheadthView {
	[_centerBgView addSubview:self.progressView];
	_progressView.progress = .0;
	_progressView.mainColor = [UIColor redColor];
	_progressView.fillColor = [UIColor yellowColor];
	_progressView.line_width = 15;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		_progressView.stepNum = 6000;
		_progressView.progress = .6;
		
	});
	//动画小人
	//
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

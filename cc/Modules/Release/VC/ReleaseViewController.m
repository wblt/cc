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
#import "HGBStepTool.h"
@interface ReleaseViewController ()
@property (weak, nonatomic) IBOutlet UIView *turnView;
@property (weak, nonatomic) IBOutlet UIView *inviteView;

@property (weak, nonatomic) IBOutlet UIView *hashrateView;

@property (weak, nonatomic) IBOutlet UIView *centerBgView;
@property (weak, nonatomic) IBOutlet UILabel *sNumLab;
@property (weak, nonatomic) IBOutlet UILabel *dNumLab;
@property (weak, nonatomic) IBOutlet UILabel *quNumLab;
@property (weak, nonatomic) IBOutlet UIView *sBgView;
@property (weak, nonatomic) IBOutlet UIView *qBgView;
@property (weak, nonatomic) IBOutlet UIView *lingBgView;



@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) QLCycleProgressView *progressView;
@property (nonatomic, strong) UIImageView *birdImage;
@end

@implementation ReleaseViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self requestData];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDate *now = [NSDate date];
	NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond: 0];
	
	NSDate *startDate = [calendar dateFromComponents:components];
	NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
	
	MJWeakSelf
	[[HGBStepTool shareInstance] queryStepDataFromDate:startDate toDate:endDate andWithReslut:^(BOOL status, NSDictionary *returnMessage) {
		
		/*
		 {
		 distance = "754.1300000017509";
		 floorsAscended = "(null)";
		 floorsDescended = "(null)";
		 numberOfSteps = 1201;
		 }
		 */
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			_progressView.stepNum = [returnMessage[@"numberOfSteps"] integerValue];
			//最大步数量
			_progressView.progress = (float)_progressView.stepNum/10000;
			//上传到服务器
			[weakSelf updataDayStep:[NSString stringWithFormat:@"%ld",_progressView.stepNum]];
		});
		
	}];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    
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
		
		NSDictionary *dic = data[@"pd"];
		UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dic];
		[[BeanManager shareInstace] setBean:model path:UserModelPath];
		[_headImage sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
		_sNumLab.text = [NSString stringWithFormat:@"算力钱包 %@",model.S_CURRENCY];
        _quNumLab.text = [NSString stringWithFormat:@"区块SHC %@",model.QK_CURRENCY];
		_dNumLab.text = model.D_CURRENCY;
		
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)updataDayStep:(NSString *)step {
    // 记录步数
    RequestParams *params = [[RequestParams alloc] initWithParams:API_DAYSTEP];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"USER_STEP" value:step];
    [params addParameter:@"CREATE_TIME" value:[Util getCurrentTime]];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"记录步数" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

-(void)addNavView {
    
    UIView *iconBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)
                          ];
    _headImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _headImage.image = [UIImage imageNamed:@"logo"];
    [iconBgView addSubview:_headImage];
    UIBarButtonItem *imgItm = [[UIBarButtonItem alloc] initWithCustomView:iconBgView];
    
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
    NSDictionary *attribtDic3 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr3 = [[NSMutableAttributedString alloc]initWithString:friendsLab.text attributes:attribtDic3];
    friendsLab.attributedText = attribtStr3;
    
	[bgView addSubview:friendsLab];
	
	UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookClick)];
	[friendsLab addGestureRecognizer:friendTap];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: imgItm,anotherButton2,nil]];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookClick)];
    [_headImage addGestureRecognizer:tap1];
	
    
    UIView *newBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newsImgView.userInteractionEnabled = YES;
    newsImgView.image = [UIImage imageNamed:@"xinfeng"];
    [newBgView addSubview:newsImgView];
    UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newBgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsClick)];
    [newsImgView addGestureRecognizer:tap];
    
    ViewBorderRadius(_inviteView, 6, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_turnView, 6, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_sBgView, 6, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_qBgView, 6, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_hashrateView, 10, 0.6,  UIColorFromHex(0x4B5461));
    
}

- (void)addheadthView {
	[_centerBgView addSubview:self.progressView];
	_progressView.progress = .0;
	_progressView.mainColor = UI_ColorWithRGBA(81, 178, 77, 1.0);
	_progressView.fillColor = [UIColor whiteColor];
	_progressView.line_width = 15;
	
	//动画小人
	_birdImage = [[UIImageView alloc]init]; //实例化一个图片视图
	_birdImage.contentMode = UIViewContentModeScaleAspectFit;
	[_centerBgView addSubview:_birdImage];//添加视图
	[_birdImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_progressView.mas_bottom).offset(5);
		make.centerX.equalTo(_centerBgView);
		make.bottom.equalTo(_centerBgView.mas_bottom).offset(0);
		make.width.mas_equalTo(200);
	}];
	
	[_birdImage setAnimationImages:@[[UIImage imageNamed:@"app_loading0"],[UIImage imageNamed:@"app_loading1"]]];//把保存了图片的数组放进去
	_birdImage.animationRepeatCount = 0;
	_birdImage.animationDuration = 0.25;//每隔多少秒切换图片
	[_birdImage startAnimating];//开始动画
}

- (void)addtapView {
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hashrateTapAction)];
    _hashrateView.userInteractionEnabled = YES;
    [_hashrateView addGestureRecognizer:tap1];
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zeroTapAction)];
    _lingBgView.userInteractionEnabled = YES;
    [_lingBgView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftToWalletAction)];
    _turnView.userInteractionEnabled = YES;
    [_turnView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteFriendsAction)];
    _inviteView.userInteractionEnabled = YES;
    [_inviteView addGestureRecognizer:tap4];
    
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

- (void)shiftToWalletAction {
    HashrateShifToWalletVC *vc = [[HashrateShifToWalletVC alloc] initWithNibName:@"HashrateShifToWalletVC" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)inviteFriendsAction {
    InvitionFriendVC *vc = [[InvitionFriendVC alloc] initWithNibName:@"InvitionFriendVC" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (QLCycleProgressView *)progressView {
	if (!_progressView) {
		_progressView = [[QLCycleProgressView alloc]initWithFrame:CGRectMake(KScreenWidth/2-70,30 , 140, 140)];
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

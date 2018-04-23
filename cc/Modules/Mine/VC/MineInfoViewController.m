//
//  MineInfoViewController.m
//  cc
//
//  Created by yanghuan on 2018/4/20.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineInfoViewController.h"
#import "XLPhotoBrowser.h"
#import "UserInfoModel.h"

@interface MineInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"个人信息";
	[self setup];
	[self addTapAction];
}
- (void)setup {
	UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
	_nickLab.text = model.NICK_NAME;
	[_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
}

- (void)addTapAction {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
	[_headImgView addGestureRecognizer:tap];
}

- (void)tapAction {
	[XLPhotoBrowser showPhotoBrowserWithImages:@[_headImgView.image] currentImageIndex:0];
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

//
//  ReceiveAddressViewController.m
//  cc
//
//  Created by wy on 2018/4/29.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "SGQRCode.h"
@interface ReceiveAddressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from itsnib.
    self.navigationItem.title = @"收款地址";
    [self setup];
    
}


- (void)setup {
    ViewRadius(_bgView, 10);
    
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
    _nameLab.text = model.NICK_NAME;
    _addressLab.text = model.W_ADDRESS;
    
    _codeImgView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:model.W_ADDRESS imageViewWidth:200];
}

- (IBAction)copyAddressAction:(id)sender {
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:model.W_ADDRESS];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    
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

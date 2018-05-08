//
//  OrderDetailsViewController.m
//  cc
//
//  Created by wy on 2018/5/1.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "SetAQPwdNumViewController.h"
#import <IQKeyboardManager.h>
#import "PasswordAlertView.h"
#import "XLPhotoBrowser.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadPic.h"

@interface OrderDetailsViewController ()<PasswordAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)UILabel *orderIdLab;
@property(nonatomic,strong)UILabel *sellNameLab;
@property(nonatomic,strong)UILabel *numLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *totalPriceLab;
@property(nonatomic,strong)UILabel *orderStatusLab;
@property(nonatomic,strong)UILabel *orderTimeLab;
@property(nonatomic,strong)UIView *line1View;

@property(nonatomic,strong)UILabel *bankUserNameLab;
@property(nonatomic,strong)UILabel *bankNameLab;
@property(nonatomic,strong)UILabel *zhiNameLab;
@property(nonatomic,strong)UILabel *bankNumLab;
@property(nonatomic,strong)UILabel *alipayLab;
@property(nonatomic,strong)UILabel *weixinLab;
@property(nonatomic,strong)UIView *line2View;

@property(nonatomic,strong)UILabel *tipsLab;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIView *line3View;

@property(nonatomic,strong)UIButton *actionBtn;
@property(nonatomic,strong)UIButton *payBtn;// 买单确认付款

@property(nonatomic,copy) NSString *url;
@property(nonatomic,strong)UIImage *img;
@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic,strong) PasswordAlertView *alertView;
@property (nonatomic,strong) NSString *urlType; // 1 取消订单  2 确认收款（卖单）  3确认付款（买单）

@end

@implementation OrderDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO; // 控制点击背景是否收起键盘
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //TODO: 页面Disappear 启用
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单详情";
    
    [self requestData];
    [self setup];
}

- (void)setup {
    
    _alertView = [[PasswordAlertView alloc]initWithType:PasswordAlertViewType_sheet];
    _alertView.delegate = self;
    _alertView.titleLable.text = @"请输入安全密码";
    _alertView.tipsLalbe.text = @"您输入的密码不正确！";
    self.scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight);
    self.scrollView.scrollEnabled = NO;
    
    _orderIdLab = [[UILabel alloc] init];
    _orderIdLab.text = @"订单ID:";
    _orderIdLab.font = Font_14;
    _orderIdLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_orderIdLab];
    
    _numLab = [[UILabel alloc] init];
    _numLab.text = @"数量:";
    _numLab.font = Font_14;
    _numLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_numLab];
    
    _totalPriceLab = [[UILabel alloc] init];
    _totalPriceLab.text = @"总计:";
    _totalPriceLab.font = Font_14;
    _totalPriceLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_totalPriceLab];
    
    _orderTimeLab = [[UILabel alloc] init];
    _orderTimeLab.text = @"订单时间:";
    _orderTimeLab.font = Font_14;
    _orderTimeLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_orderTimeLab];
    
    
    _sellNameLab = [[UILabel alloc] init];
    _sellNameLab.text = @"卖方用户名:";
    _sellNameLab.font = Font_14;
    _sellNameLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_sellNameLab];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.text = @"价格:";
    _priceLab.font = Font_14;
    _priceLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_priceLab];
    
    _orderStatusLab = [[UILabel alloc] init];
    _orderStatusLab.text = @"订单状态:";
    _orderStatusLab.font = Font_14;
    _orderStatusLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_orderStatusLab];
    
    _line1View = [[UIView alloc] init];
    _line1View.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_line1View];
    
    _bankUserNameLab = [[UILabel alloc] init];
    _bankUserNameLab.text = @"开户名:";
    _bankUserNameLab.font = Font_14;
    _bankUserNameLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_bankUserNameLab];
    
    _bankNameLab = [[UILabel alloc] init];
    _bankNameLab.text = @"银行名称:";
    _bankNameLab.font = Font_14;
    _bankNameLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_bankNameLab];
    
    _zhiNameLab = [[UILabel alloc] init];
    _zhiNameLab.text = @"支行名称:";
    _zhiNameLab.font = Font_14;
    _zhiNameLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_zhiNameLab];
    
    _bankNumLab = [[UILabel alloc] init];
    _bankNumLab.text = @"银行账号:";
    _bankNumLab.font = Font_14;
    _bankNumLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_bankNumLab];
    
    _alipayLab = [[UILabel alloc] init];
    _alipayLab.text = @"支付宝账号:";
    _alipayLab.font = Font_14;
    _alipayLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_alipayLab];
    
    _weixinLab = [[UILabel alloc] init];
    _weixinLab.text = @"微信账号:";
    _weixinLab.font = Font_14;
    _weixinLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_weixinLab];
    
    _line2View = [[UIView alloc] init];
    _line2View.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_line2View];
    
    _tipsLab = [[UILabel alloc] init];
    _tipsLab.text = @"付款凭证:";
    _tipsLab.font = Font_14;
    _tipsLab.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:_tipsLab];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.userInteractionEnabled = YES;
    _imgView.image = [UIImage imageNamed:@"addimg"];
    [self.scrollView addSubview:_imgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImgTap)];
    [_imgView addGestureRecognizer:tap];
    
    _line3View = [[UIView alloc] init];
    _line3View.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_line3View];
    
    _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionBtn.titleLabel.font = Font_14;
    [_actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _actionBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:_actionBtn];
    MJWeakSelf
    [_actionBtn addTapBlock:^(UIButton *btn) {
        if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
            // 取消订单
            _urlType = @"1";
        }else {
            // 确认收款
            _urlType = @"2";
        }
        UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
        if ([model.IFPAS isEqualToString:@"1"]) {
            [weakSelf.alertView show];
        }else {
            [SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.titleLabel.font = Font_14;
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payBtn.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:_payBtn];
    
    
    [_payBtn addTapBlock:^(UIButton *btn) {
       // 确认付款
        if (weakSelf.url.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请上传付款凭证"];
            return ;
        }
        // 确认付款
        _urlType = @"3";
        UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
        if ([model.IFPAS isEqualToString:@"1"]) {
            [weakSelf.alertView show];
            
        }else {
            [SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }
    }];
    
    [_orderIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_orderTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_sellNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderIdLab);
        make.left.equalTo(self.scrollView).offset(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_numLab);
        make.left.equalTo(self.scrollView).offset(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [_orderStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_totalPriceLab);
        make.left.equalTo(self.scrollView).offset(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [_line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTimeLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.width.mas_equalTo(KScreenWidth-20);
        make.height.mas_equalTo(1);
    }];
    
    [_bankUserNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_zhiNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankUserNameLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhiNameLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_alipayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNumLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bankUserNameLab);
        make.left.equalTo(self.scrollView).offset(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [_weixinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_alipayLab);
        make.left.equalTo(self.scrollView).offset(KScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    
    [_line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayLab.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.width.mas_equalTo(KScreenWidth-20);
        make.height.mas_equalTo(1);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.line2View.mas_bottom).offset(10);
       make.left.equalTo(self.scrollView).offset(100);
       make.height.width.mas_equalTo(100);
    }];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgView);
        make.left.equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [_line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.left.equalTo(self.scrollView).offset(10);
        make.width.mas_equalTo(KScreenWidth-20);
        make.height.mas_equalTo(1);
    }];
    
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3View.mas_bottom).offset(20);
        make.centerX.equalTo(self.scrollView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_actionBtn.mas_right).offset(20);
        make.centerY.equalTo(_actionBtn);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    _payBtn.hidden = YES;
    
    
    ViewBorderRadius(_actionBtn, 10, 0.6, UIColorFromHex(0x4B5461));
    ViewBorderRadius(_payBtn, 10, 0.6, UIColorFromHex(0x4B5461));
}


#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    if (buttonIndex == 0) {/**<相册库选取照片*/
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"相册访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:nil];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:action];
            return;
        }else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }else if (buttonIndex == 1){/**<拍照选取照片*/
        /// 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        /// 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:nil];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:action];
            return ;
        }else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }else if (buttonIndex == 2){
        
        return ;
    }
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
//相册处理，获取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {/**<选中照片回调*/
    self.img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(
                                       self.img, nil, nil, nil);
    }
    _imgView.image = self.img;
    [self dismissViewControllerAnimated:YES completion:nil];
    // 上传照片
    NSString *photoPath = [[UploadPic sharedInstance] photoSavePathForURL:info[UIImagePickerControllerReferenceURL]];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage],1.0);
    if ((float)imageData.length/1024 > 100) {//需要测试
        imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1024*100.0/(float)imageData.length);
    }
    [imageData writeToFile:photoPath atomically:YES];
    NSString *fileName = [NSString stringWithFormat:@"%f_%d.jpg", [[NSDate date] timeIntervalSince1970], arc4random()%1000];
    [[UploadPic sharedInstance] uploadFileMultipartWithPath:photoPath fileName:fileName callback:^(NSString *url) {
        NSLog(@"%@",url);
        _url = url;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {/**<不选照片点击取消回调*/
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)scaleImgTap {
    if ([_type isEqualToString:@"0"] && !_actionBtn.hidden) {
        // 是买单，并且没有隐藏  就是上传图片
        ////这里是摄像头可以使用的处理逻辑
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择照片", @"拍照片", nil];
        [actionSheet showInView:self.view];
        
    }else {
        [XLPhotoBrowser showPhotoBrowserWithImages:@[_imgView.image] currentImageIndex:0];
    }
}

- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_orderDetail];
    [params addParameter:@"TRADE_ID" value:self.model.TRADE_ID];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"订单详情" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        NSDictionary *pd = data[@"pd"];
        _orderIdLab.text = [NSString stringWithFormat:@"订单ID:%@",pd[@"TRADE_ID"]];
        _weixinLab.text = [NSString stringWithFormat:@"微信账号:%@",pd[@"WCHAT"]];
        _alipayLab.text = [NSString stringWithFormat:@"支付宝账号:%@",pd[@"ALIPAY"]];
        _totalPriceLab.text = [NSString stringWithFormat:@"总价:%@",pd[@"TOTAL_MONEY"]];
        _sellNameLab.text = [NSString stringWithFormat:@"卖方用户名:%@",pd[@"USER_NAME"]];
        _priceLab.text = [NSString stringWithFormat:@"价格:%@",pd[@"BUSINESS_PRICE"]];
        _orderTimeLab.text = [NSString stringWithFormat:@"订单时间:%@",pd[@"CREATE_TIME"]];
        _numLab.text = [NSString stringWithFormat:@"数量:%@",pd[@"BUSINESS_COUNT"]];
        _bankNumLab.text =  [NSString stringWithFormat:@"银行账号:%@",pd[@"BANK_NO"]];
        _bankNameLab.text = [NSString stringWithFormat:@"银行名称:%@",pd[@"BANK_NAME"]];
        _bankUserNameLab.text = [NSString stringWithFormat:@"开户名:%@",pd[@"BANK_USERNAME"]];
        _zhiNameLab.text =  [NSString stringWithFormat:@"支行名称:%@",pd[@"BANK_ADDR"]];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:pd[@"IMAGE_NOTE"]] placeholderImage:[UIImage imageNamed:@"addimg"]];
        
        NSString *status = [NSString stringWithFormat:@"%@",pd[@"STATUS"]];

        if ([status isEqualToString:@"0"]) {
            _orderStatusLab.text = @"订单状态:待审核";
            _tipsLab.hidden = YES;
            _line3View.hidden = YES;
            _imgView.hidden = YES;
            
            [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line2View.mas_bottom).offset(20);
                make.centerX.equalTo(self.scrollView);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
            [_actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        }else if ([status isEqualToString:@"1"])  {
            _orderStatusLab.text = @"订单状态:审核通过";
            _tipsLab.hidden = YES;
            _line3View.hidden = YES;
            _imgView.hidden = YES;
            
            [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line2View.mas_bottom).offset(20);
                make.centerX.equalTo(self.scrollView);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
            [_actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        }else if ([status isEqualToString:@"2"])  {
            _orderStatusLab.text = @"订单状态:部分成交";
            _tipsLab.hidden = YES;
            _line3View.hidden = YES;
            _imgView.hidden = YES;
            
            [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line2View.mas_bottom).offset(20);
                make.centerX.equalTo(self.scrollView);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(40);
            }];
            [_actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        }else if ([status isEqualToString:@"3"])  {
            _orderStatusLab.text = @"订单状态:待付款";
            if ([_type isEqualToString:@"0"]) {//买单
                _payBtn.hidden = NO;
                [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.line3View.mas_bottom).offset(20);
                    make.centerX.equalTo(self.scrollView).offset(-60);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(40);
                }];
                [_actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [_payBtn setTitle:@"确认付款" forState:UIControlStateNormal];
            }else {// 卖单
                _tipsLab.hidden = YES;
                _line3View.hidden = YES;
                _imgView.hidden = YES;
                _actionBtn.hidden = YES;
            }
            
        }else if ([status isEqualToString:@"4"])  {
            _orderStatusLab.text = @"订单状态:已付款";
            [_actionBtn setTitle:@"确认收款" forState:UIControlStateNormal];
        }else if ([status isEqualToString:@"5"])  {
            _orderStatusLab.text = @"订单状态:已成交";
            _actionBtn.hidden = YES;
        }else if ([status isEqualToString:@"6"])  {
            _orderStatusLab.text = @"订单状态:已取消";
            _tipsLab.hidden = YES;
            _line3View.hidden = YES;
            _imgView.hidden = YES;
            _actionBtn.hidden = YES;
        }
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)cancelAction:(UIButton *)sender {
    _type = @"1";
    UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
    if ([model.IFPAS isEqualToString:@"1"]) {
        [_alertView show];
     
    }else {
        [SVProgressHUD showInfoWithStatus:@"未设置资金密码"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
}

- (void)payAction:(UIButton *)sender {
    _type = @"2";
    
}

-(void)PasswordAlertViewCompleteInputWith:(NSString*)password{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UserInfoModel *model = [[BeanManager shareInstace] getBeanfromPath:UserModelPath];
        if ([model.PASSW isEqualToString:password]) {
            [_alertView passwordCorrect];
            
            if ([_urlType isEqualToString:@"1"]) { //取消订单
                [self cancelOrderAction:self.model];
            }else if ([_urlType isEqualToString:@"2"]){ //确认收款
                 [self sureGetMoney:self.model];
            }else {//3 确认付款
                 [self payOrder:self.model];
            }
            
        }else {
            [_alertView passwordError];
        }
        
    });
}

-(void)PasswordAlertViewDidClickCancleButton{
    NSLog(@"点击了取消按钮");
}


-(void)PasswordAlertViewDidClickForgetButton{
    NSLog(@"点击了忘记密码按钮");
    SetAQPwdNumViewController *vc = [[SetAQPwdNumViewController alloc] initWithNibName:@"SetAQPwdNumViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelOrderAction:(OrderModel *)order {
    
    RequestParams *params = [[RequestParams alloc] initWithParams:API_orderCancle];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    if ([_type isEqualToString:@"0"]) {
        [params addParameter:@"TYPE" value:@"0"]; // 取消买单
    }else {
        [params addParameter:@"TYPE" value:@"1"]; // 取消卖单
    }
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"订单取消" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)payOrder:(OrderModel *)order {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_pay];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    [params addParameter:@"STATUS" value:@"4"];
    [params addParameter:@"IMAGE_NOTE" value:_url];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"确认付款" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"确认付款成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}
//确认收款
- (void)sureGetMoney:(OrderModel *)order {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_surePay];
    [params addParameter:@"TRADE_ID" value:order.TRADE_ID];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"确认收款" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"确认收款成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

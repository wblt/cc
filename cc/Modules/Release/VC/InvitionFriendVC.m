//
//  InvitionFriendVC.m
//  cc
//
//  Created by wy on 2018/4/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "InvitionFriendVC.h"

@interface InvitionFriendVC ()
@property (weak, nonatomic) IBOutlet UIImageView *shareImgView;
@property (nonatomic,copy)NSString *leftStr;
@property (nonatomic,copy)NSString *rightStr;
@property (nonatomic,copy)NSString *appUrl;
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UILabel *leftUrlLab;
@property (weak, nonatomic) IBOutlet UILabel *rightUrlLab;
@property (weak, nonatomic) IBOutlet UILabel *httpUrlLab;

@end

@implementation InvitionFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestData];
    [self addTapView];
}

- (void)addTapView {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftCopyAction)];
    self.leftUrlLab.userInteractionEnabled = YES;
    [self.leftUrlLab addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightCopyAction)];
    self.rightUrlLab.userInteractionEnabled = YES;
    [self.rightUrlLab addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appCopyAction)];
    self.httpUrlLab.userInteractionEnabled = YES;
    [self.httpUrlLab addGestureRecognizer:tap3];
    
}

- (void)leftCopyAction{
    if (self.leftUrlLab.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.leftUrlLab.text];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)rightCopyAction {
    if (self.rightUrlLab.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.rightUrlLab.text];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)appCopyAction{
    if (self.httpUrlLab.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.httpUrlLab.text];
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)requestData {
    RequestParams *params = [[RequestParams alloc] initWithParams:API_INVITATION];
    [params addParameter:@"USER_NAME" value:[SPUtil objectForKey:k_app_userNumber]];
    [params addParameter:@"TERMINAL" value:@"1"];
    
    [[NetworkSingleton shareInstace] httpPost:params withTitle:@"邀请好友" successBlock:^(id data) {
        NSString *code = data[@"code"];
        if (![code isEqualToString:@"1000"]) {
            [SVProgressHUD showErrorWithStatus:data[@"message"]];
            return ;
        }
        /*
         "pd": {
         "LEFT_URL": "http://ala-1254340937.file.myqcloud.com/100000280.png",
         "RIGHT_URL": "http://ala-1254340937.file.myqcloud.com/100000281.png",
         "APP_URL": "http://shcunion.vip.img.800cdn.com/ala/fj/apple2.png"
         },
         */
        self.leftLab.text = [NSString stringWithFormat:@"左区业绩:%@",data[@"pd"][@"L_TOTAL"]];
        self.rightLab.text = [NSString stringWithFormat:@"右区业绩:%@",data[@"pd"][@"R_TOTAL"]];
        
        self.leftUrlLab.text = data[@"pd"][@"LEFT_URL"];
        self.rightUrlLab.text = data[@"pd"][@"RIGHT_URL"];
        self.httpUrlLab.text = data[@"pd"][@"APP_URL"];
        
        // 下划线
        NSDictionary *attribtDic1 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString:self.leftUrlLab.text attributes:attribtDic1];
        self.leftUrlLab.attributedText = attribtStr1;
        
        NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:self.rightUrlLab.text attributes:attribtDic2];
        self.rightUrlLab.attributedText = attribtStr2;
        
        NSDictionary *attribtDic3 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr3 = [[NSMutableAttributedString alloc]initWithString:self.httpUrlLab.text attributes:attribtDic3];
        self.httpUrlLab.attributedText = attribtStr3;
        
        
        
		[_shareImgView sd_setImageWithURL:[NSURL URLWithString:self.appUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常，请联系管理员"];
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

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

@end

@implementation InvitionFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
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
        self.leftStr = data[@"pd"][@"LEFT_URL"];
        self.leftStr = data[@"pd"][@"RIGHT_URL"];
        self.appUrl = data[@"pd"][@"APP_URL"];
    } failureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

- (IBAction)copyLeftAction:(id)sender {
    if (self.leftStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.leftStr];
     [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (IBAction)copyRightAction:(id)sender {
    if (self.rightStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"复制失败"];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.rightStr];
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

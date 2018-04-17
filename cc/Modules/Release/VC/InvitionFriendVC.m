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

@end

@implementation InvitionFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)copyLeftAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:@"复制左区"];
}

- (IBAction)copyRightAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:@"复制右区"];
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

//
//  MineVC.m
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "MineVC.h"

@interface MineVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;
@property (weak, nonatomic) IBOutlet UIView *bgView7;
@property (weak, nonatomic) IBOutlet UIView *bgView8;
@property (weak, nonatomic) IBOutlet UIView *bgView9;
@property (weak, nonatomic) IBOutlet UIView *bgView10;
@property (weak, nonatomic) IBOutlet UIView *bgView11;
@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setup];
}

- (void)setup {
	ViewBorderRadius(_bgView1, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView2, 10, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView3, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView4, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView5, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView6, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView7, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView8, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView9, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView10, 0, 0.6, UIColorFromHex(0x4B5461));
	ViewBorderRadius(_bgView11, 0, 0.6, UIColorFromHex(0x4B5461));
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

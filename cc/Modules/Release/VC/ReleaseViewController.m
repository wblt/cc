//
//  ReleaseViewController.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "ReleaseViewController.h"

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self addNavView];
    
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
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: imgItm,anotherButton2,nil]];
    
    UIImageView *newsImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newsImgView.image = [UIImage imageNamed:@"xinfeng"];
    UIBarButtonItem *rightAnotherButton = [[UIBarButtonItem alloc] initWithCustomView:newsImgView];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightAnotherButton,nil]];
}

- (void)lookClick{
    
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

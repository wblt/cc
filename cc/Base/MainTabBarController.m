//
//  MainTabBarController.m
//  ThankYou
//
//  Created by lizzy on 16/5/4.
//  Copyright © 2016年 2011-2013 湖南长沙阳环科技实业有限公司 @license http://www.yhcloud.com.cn. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavViewController.h"
#import "MainTabBarItem.h"
#import "BaseViewController.h"
#import "ReleaseViewController.h"
#import "MarketsViewController.h"
#import "MineViewController.h"

@interface MainTabBarController ()
{
    MainTabBarItem *selectedItem;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSArray *subViews = self.tabBar.subviews;
    for (UIView *view in subViews) {
        //此函数能获取该字符串指代的类
        Class cla = NSClassFromString(@"UITabBarButton");
        //判断该视图的类型是否属于cla所指的类型
        if ([view isKindOfClass:cla]) {
            [view removeFromSuperview];
        }
    }
    [self createTabbar];
}

#pragma mark Private Method
-(void)addViewControllers {/**<添加二级控制器*/
    ReleaseViewController *releaseVC = [[ReleaseViewController alloc] initWithNibName:@"ReleaseViewController" bundle:nil];
    MarketsViewController *marketsVC = [[MarketsViewController alloc] initWithNibName:@"MarketsViewController" bundle:nil];
	MineViewController *mineVC = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
	
    NSArray *vcArray = @[releaseVC,marketsVC, mineVC];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:vcArray.count];
    for (int i = 0; i < vcArray.count; i++) {
         BaseNavViewController*navigationVC = [[BaseNavViewController alloc] initWithRootViewController:vcArray[i]];
		
        [viewControllers addObject:navigationVC];
    }
    self.viewControllers = viewControllers;
}

- (void)createTabbar {
	
    self.tabBar.backgroundColor = [UIColor darkGrayColor]; //UIColorFromHex(0x303030);
    // 按钮的非循环中状态图片数组
    NSArray *normalImgArray = @[@"deliver_icon", @"market_icon", @"mine_icon"];
    NSArray *selectedImgArray = @[@"deliver_icon_selector", @"market_icon_selector", @"mine_icon_selector"];
    // 按钮的标题数组
    NSArray *titleArray = @[@"释放", @"市场",@"我的"];
    UIColor *normalTitleColor =  [UIColor whiteColor]; //UIColorFromHex(0x808080);
    UIColor *selectedTitleColor = [UIColor whiteColor];
    //UI_ColorWithRGBA(204, 177, 126, 1.0); //UIColorFromHex(0xCCB17E);
    
    // 按钮的宽、高
    CGFloat itemWidth = KScreenWidth / (float)normalImgArray.count;
    CGFloat itemHeight = self.tabBar.frame.size.height;
	
    for (int i = 0; i < normalImgArray.count; i++) {
        CGRect itemFrame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        //使用自定义的按钮样式
        MainTabBarItem *item = [[MainTabBarItem alloc] initWithFrame:itemFrame
                                                     normalImageName:normalImgArray[i]
                                                   selectedImageNemd:selectedImgArray[i]
                                                     normalFontColor:normalTitleColor
                                                   selectedFontColor:selectedTitleColor
                                                               title:titleArray[i]];
        item.backgroundColor = UIColorFromHex(0x020919);
        //[UIColor darkGrayColor];
        item.tag = i;
        item.isSelected = NO;
        if (i == self.selectedIndex) {
            item.isSelected = YES;
            selectedItem = item;
        }
		
		[item addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
		
        [self.tabBar addSubview:item];
    }
}

#pragma mark -
#pragma mark Event Response
//设置是否选中
- (void)selectAction:(MainTabBarItem *)item
{
    NSArray *subViews = self.tabBar.subviews;
    for (UIView *view in subViews) {
        //此函数能获取该字符串指代的类
        Class cla = NSClassFromString(@"UITabBarButton");
        //判断该视图的类型是否属于cla所指的类型
        if ([view isKindOfClass:cla]) {
            [view removeFromSuperview];
        }
    }
    if (item != selectedItem)
    {
        item.isSelected = YES;
        selectedItem.isSelected = NO;
        selectedItem = item;
        //跳转至对应的控制器
        self.selectedIndex = item.tag;
    }
}

/**<模块跳转识别*/
- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex !=_selectIndex) {
        _selectIndex = selectIndex;
    }
    self.selectedIndex = selectIndex;
}

@end

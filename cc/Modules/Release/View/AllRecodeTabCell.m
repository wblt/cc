//
//  AllRecodeTabCell.m
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "AllRecodeTabCell.h"

@implementation AllRecodeTabCell


// 在cell 的视线文件中重写该方法
- (void)setFrame:(CGRect)frame
{
	//修改cell的左右边距为5; 自定义
	//修改cell的Y值下移5;
	//修改cell的高度减少5;
	//未测试UICollectionViewCell    ps：应该是一样的，不过没必要，可以自己设置间距
	static CGFloat margin = 2;
	frame.origin.x = margin;
	frame.size.width -= 2 * frame.origin.x;
	frame.origin.y += margin;
	frame.size.height -= margin*2;
	
	[super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

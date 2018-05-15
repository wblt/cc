//
//  AllRecodeTabCell.m
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "AllRecodeTabCell.h"

@implementation AllRecodeTabCell


- (void)setModel:(ReleaseModel *)model {
	_model = model;
	self.calcuLateLab.text =  [NSString stringWithFormat:@"%.02f", [model.CALCULATE_MONEY floatValue]];
	self.bigLab.text = [NSString stringWithFormat:@"%.02f", [model.BIG_CURRENCY floatValue]];
	self.smallLab.text = [NSString stringWithFormat:@"%.02f", [model.SMALL_CURRENCY floatValue]];
	self.staticLab.text = [NSString stringWithFormat:@"%.02f", [model.STATIC_CURRENCY floatValue]];
    self.stepLab.text =  [NSString stringWithFormat:@"%.02f", [model.STEP_CURRENCY floatValue]];
    self.timeLab.text = model.CREATE_TIME;
	self.jdLab.text = [NSString stringWithFormat:@"%.02f",[model.JD_CURRENCY floatValue]];
}

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

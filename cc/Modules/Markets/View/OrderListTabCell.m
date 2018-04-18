//
//  OrderListTabCell.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "OrderListTabCell.h"

@implementation OrderListTabCell



- (IBAction)mactchAction:(id)sender {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(OrderListTabCellMacth:)]) {
		[self.delegate OrderListTabCellMacth:self.index];
	}
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

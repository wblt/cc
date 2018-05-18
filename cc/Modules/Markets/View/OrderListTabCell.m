//
//  OrderListTabCell.m
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "OrderListTabCell.h"

@implementation OrderListTabCell

/*
 @property (weak, nonatomic) IBOutlet UILabel *numLab;
 @property (weak, nonatomic) IBOutlet UILabel *priceLab;
 @property (weak, nonatomic) IBOutlet UILabel *totalLab;
 @property (weak, nonatomic) IBOutlet UILabel *nameLab;
 @property (weak, nonatomic) IBOutlet UILabel *timeLab;
 */
- (void)setOrder:(OrderModel *)order {
    _order = order;
    self.nameLab.text = order.USER_NAME;
    self.timeLab.text = order.CREATE_TIME;
    self.numLab.text = [NSString stringWithFormat:@"%@",order.BUSINESS_COUNT];
    self.priceLab.text = [NSString stringWithFormat:@"%@",order.BUSINESS_PRICE];
    self.totalLab.text = [NSString stringWithFormat:@"%@", order.TOTAL_MONEY];
    if ([order.STATUS isEqualToString:@"0"]) {
        self.statesLab.text = @"待审核";
    }else if ([order.STATUS isEqualToString:@"1"]) {
         self.statesLab.text = @"审核通过";
    }else if ([order.STATUS isEqualToString:@"2"]) {
         self.statesLab.text = @"部分成交";
    }else if ([order.STATUS isEqualToString:@"3"]) {
         self.statesLab.text = @"待付款";
    }else if ([order.STATUS isEqualToString:@"4"]) {
         self.statesLab.text = @"已付款";
    }else if ([order.STATUS isEqualToString:@"5"]) {
         self.statesLab.text = @"已成交";
    }else if ([order.STATUS isEqualToString:@"6"]) {
         self.statesLab.text = @"已取消";
    }
    [self.matchBtn setTitle:@"查看详情" forState:UIControlStateNormal];
}

- (void)setMarketOrder:(OrderModel *)marketOrder{
    _marketOrder = marketOrder;
    self.nameLab.text = marketOrder.USER_NAME;
    self.timeLab.text = marketOrder.CREATE_TIME;
    self.numLab.text = [NSString stringWithFormat:@"%@",marketOrder.BUSINESS_COUNT];
    self.priceLab.text = [NSString stringWithFormat:@"%@",marketOrder.BUSINESS_PRICE];
    self.totalLab.text = [NSString stringWithFormat:@"%.02f", [marketOrder.TOTAL_MONEY floatValue]];
}

- (IBAction)mactchAction:(id)sender {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(OrderListTabCellMacth: orderType:)]) {
		[self.delegate OrderListTabCellMacth:self.index orderType:self.ordertype];
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

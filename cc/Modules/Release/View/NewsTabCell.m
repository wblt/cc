//
//  NewsTabCell.m
//  cc
//
//  Created by wy on 2018/4/17.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "NewsTabCell.h"

@implementation NewsTabCell

- (void)setModel:(NoticeModel *)model {
    _model = model;
    self.titleLab.text = model.TITLE;
    self.contentLab.text = model.CONTENT;
    self.timeLab.text = model.CREATE_TIME;
    
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

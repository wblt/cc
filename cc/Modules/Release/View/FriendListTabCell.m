//
//  FriendListTabCell.m
//  cc
//
//  Created by wy on 2018/4/22.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import "FriendListTabCell.h"

@implementation FriendListTabCell


- (void)setModel:(FriendInfoModel *)model {
    _model = model;
    self.telLab.text = [NSString stringWithFormat:@"tel:%@",model.TEL];
    self.nameLab.text = model.USER_NAME;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.HEAD_URL] placeholderImage:[UIImage imageNamed:@"logo"]];
    
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

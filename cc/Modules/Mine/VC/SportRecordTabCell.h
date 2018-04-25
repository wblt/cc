//
//  SportRecordTabCell.h
//  cc
//
//  Created by yanghuan on 2018/4/25.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"
@interface SportRecordTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *stepLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property(nonatomic,strong)RecordModel *model;

@end

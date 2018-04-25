//
//  AllRecodeTabCell.h
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseModel.h"
@interface AllRecodeTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *calcuLateLab;
@property (weak, nonatomic) IBOutlet UILabel *bigLab;
@property (weak, nonatomic) IBOutlet UILabel *smallLab;
@property (weak, nonatomic) IBOutlet UILabel *staticLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *jdLab;
@property (weak, nonatomic) IBOutlet UILabel *stepLab;

@property(nonatomic,strong)ReleaseModel *model;

@end

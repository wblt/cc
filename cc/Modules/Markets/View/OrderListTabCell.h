//
//  OrderListTabCell.h
//  cc
//
//  Created by wy on 2018/4/14.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderListTabCellDelegate <NSObject>

-(void)OrderListTabCellMacth:(NSInteger )index;
////点击了确定按钮  或者是完成了6位密码的输入
//-(void)PasswordAlertViewCompleteInputWith:(NSString*)password;
////点击了取消按钮
//-(void)PasswordAlertViewDidClickCancleButton;
////点击了忘记密码按钮
//-(void)PasswordAlertViewDidClickForgetButton;
@end

@interface OrderListTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *matchBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;



@property (nonatomic,assign)NSInteger index;
@property (nonatomic,weak)id<OrderListTabCellDelegate> delegate;

@end

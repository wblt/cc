//
//  UserInfoModel.h
//  cc
//
//  Created by yanghuan on 2018/4/23.
//  Copyright © 2018年 wyChirs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *USER_NAME;//用户名
@property(nonatomic,copy)NSString *NICK_NAME;//昵称
@property(nonatomic,copy)NSNumber *USER_ID;//用户ID
@property(nonatomic,copy)NSString *TEL;//手机号码
@property(nonatomic,copy)NSString *HEAD_URL;//头像地址
@property(nonatomic,copy)NSString *S_CURRENCY;//算力钱包余额
@property(nonatomic,copy)NSString *D_CURRENCY;//零钱包余额
@property(nonatomic,copy)NSString *A_CURRENCY;//可转余额
@property(nonatomic,copy)NSString *W_ENERGY;//能量钱包余额
@property(nonatomic,copy)NSString *W_ADDRESS;//钱包地址

@end

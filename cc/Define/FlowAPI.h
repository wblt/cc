//
//  FlowAPI.h
//  Keepcaring
//
//  Created by mac on 2017/12/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#ifndef FlowAPI_h
#define FlowAPI_h

// 主服务器地址
#define SERVER_IP         @"http://139.196.225.206:8082"

// 登录
#define API_LOGIN       SERVER_IP@"/app/user/login"

// 注册验证码
#define API_REGIST_CODE SERVER_IP@"/app/user/sysendMess"

// 注册
#define API_REGIST       SERVER_IP@"/app/user/syreg"

// 忘记密码验证码
#define API_FGPWD_CODE   SERVER_IP@"/app/user/sysendMessFG"

//忘记密码
#define API_FGPWD    SERVER_IP@"/app/user/forget"

//安全密码短信验证码
#define API_AQPWD_CODE  SERVER_IP@"/app/user/sysendMessAQ"

// 公告
#define API_NOTICE     SERVER_IP@"/app/index/notice"
// 我的好友
#define API_MY_FRIENDS SERVER_IP@"/app/index/friends"
//记录步数
#define API_DAYSTEP SERVER_IP@"/app/index/dayStep"
//邀请好友
#define API_INVITATION SERVER_IP@"/app/index/invitation"
//释放记录
#define API_RELEASE SERVER_IP@"/app/index/release"
//释放详情
#define API_RELEASEDTTAIIL SERVER_IP@"/app/index/releaseDetaiil"
//零钱包转入算力钱包
#define API_TRANSFERRED SERVER_IP@"/app/index/transferred"

//首页
#define API_HOMEPAGE   SERVER_IP@"/app/index/homePage"

// 修改个人信息
#define API_CGPERSONMSG   SERVER_IP@"/app/tool/cgPersonMes"
// 修改安全密码
#define API_ANPASSW   SERVER_IP@"/app/tool/aqPassw"
// 修改手机号码
#define API_PHONECG   SERVER_IP@"/app/tool/phoneCg"
// 修改登陆密码
#define API_CGPASSWORD   SERVER_IP@"/app/tool/changePassw"

#endif /* FlowAPI_h */

//
//  SHGGloble.h
//  Finance
//
//  Created by changxicao on 15/8/24.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePeopleObject.h"

typedef void (^SHHomeDataCompletionBlock)(NSArray *allList, NSArray *normalList, NSArray *adList);

@protocol SHGGlobleDelegate <NSObject>

@optional

- (void)userlocationDidShow:(NSString *)cityName;

@end

@interface SHGGloble : NSObject

/**
 @brief  全局代理

 @since 1.5.0
 */
@property (assign, nonatomic) id<SHGGlobleDelegate> delegate;

/**
 @brief  当前的省份名称
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSString *provinceName;

/**
 @brief  当前城市的名称
 
 @since 1.4.1
 */
@property (strong, nonatomic) NSString *cityName;

/**
 @brief  个人标签数据(供选择)

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *tagsArray;

/**
 @brief  用户选择的标签

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *selectedTagsArray;

/**
 @brief  获取到的通讯录数组

 @since 1.5.0
 */
@property (strong, nonatomic) NSMutableArray *contactArray;

/**
 @brief 当前app的版本号

 @since 1.8.1_01
 */
@property (strong, nonatomic) NSString *currentVersion;

/**
 @brief 当前手机的型号

 @since 1.8.2
 */
@property (strong, nonatomic) NSString *platform;


/**
 @brief  首页请求完成的回掉
 
 @since 1.4.1
 */
@property (copy, nonatomic) SHHomeDataCompletionBlock CompletionBlock;

/**
 @brief  globle单例
 
 @return 当前对象
 
 @since 1.4.1
 */
+ (instancetype)sharedGloble;

/**
 @brief  是否需要启动界面

 @return 是否是第一次启动 或者是升级了应用

 @since 1.5.0
 */
- (BOOL)isShowGuideView;

/**
 @brief  程序首次启动未显示首页的情况下去请求数据
 
 @since 1.4.1
 */
- (void)requestHomePageData;

/**
 @brief  获取所有的标签

 @since 1.5.0
 */
- (void)downloadUserTagInfo:(void(^)())block;

/**
 @brief  获取用户选择的标签

 @param block

 @since 1.5.0
 */
- (void)downloadUserSelectedInfo:(void (^)())block;

/**
 @brief  上传用户选择的标签

 @since 1.5.0
 */
- (void)uploadUserSelectedInfo:(NSArray *)array completion:(void(^)(BOOL finished))block;

/**
 @brief  获取用户的通讯录

 @param block 是否完成获取操作

 @since 1.5.0
 */
- (void)getUserAddressList:(void(^)(BOOL finished))block;

/**
 @brief  上传用户的通讯录

 @param block 是否完成上传操作

 @since 1.5.0
 */
- (void)uploadPhonesWithPhone:(void(^)(BOOL finish))block;


/**
 @brief  格式化得到的数据到object数组

 @param array 字典数据
 @param class 固定的类

 @return object数据

 @since 1.5.0
 */
- (NSArray *)parseServerJsonArrayToJSONModel:(NSArray *)array class:(Class)class;

/**
 @brief  获取用户认证状态

 @param block 返回状态

 @since 1.6.0
 */
- (void)requestUserVerifyStatusCompletion:(void (^)(BOOL state))completionblock showAlert:(BOOL)showAlert leftBlock:(void(^)())leftblock failString:(NSString *)string;


/**
 @breief  记录用户行为

 @since 1.7
 */
- (void)recordUserAction:(NSString *)recordIdStr type:(NSString *)typeStr;

/**
 @breief  向服务端传递

 @since 1.7
 */

- (void)registerToken:(NSDictionary *)param block:(void(^)(BOOL success, MOCHTTPResponse *response))block;


/**
 @brief  获取当前的界面

 @return 获取当前的界面

 @since 1.8
 */
- (UIViewController *)getCurrentRootViewController;

/**
 @brief  检查更新并提示

 @param state 是否有新版本
 @param block 有新版本的操作

 @since 1.8
 */
- (void)checkForUpdate:(void(^)(BOOL state))block;

/**
 @brief 当此用户注册成功的时候调用通知给其他的好友用户

 @since 1.8.0
 */
- (void)dealFriendPush;

/**
 @brief  向服务端请求用户信息

 @since 1.8.0
 */

- (void)refreshFriendListWithUid:(NSString *)userId finishBlock:(void (^)(BasePeopleObject *object))block;

/**
 @brief 获取业务的key和value值

 @since 1.8.04
 */

- (NSDictionary *)getBusinessKeysAndValues;

/**
 @brief 通过服务端返回的value值反向去查询对应的key值

 @param values 服务端返回的key

 @return key值字符串

 @since 1.8.0
 */
- (NSString *)businessKeysForValues:(NSString *)values showEmptyKeys:(BOOL)show;

- (NSMutableArray *)editBusinessKeysForValues:(NSArray *)nameArray middleContentArray:(NSArray *)middleContentArray;

- (NSString *)checkPhoneNumber:(NSString *)phoneText;


/**
 @brief 拨打电话号码

 @param number 电话号码

 @since 1.8.1
 */
- (void)dialNumber:(NSString *)number;

/**
 @brief 发送短信

 @param phones 发送的电话号码 可以多个
 @param body   默认的消息

 @since 1.8.1
 */
- (void)showMessageView:(NSArray *)phones body:(NSString *)body;

/**
 @brief 适应CTTextDisplayView 需要格式话字符串

 @param string 传入的字符串

 @return 返回的字符串

 @since 1.8.2
 */
- (NSString *)formatStringToHtml:(NSString *)string;
@end

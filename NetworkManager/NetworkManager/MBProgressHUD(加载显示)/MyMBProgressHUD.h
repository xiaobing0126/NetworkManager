//
//  MyMBProgressHUD.h
//  RichCreditNetwork
//
//  Created by Bing on 2017/10/26.
//  Copyright © 2017年 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

/**
 *  弹窗类型的枚举值
 */
typedef NS_ENUM(NSInteger, ProgressMode) {
    
    ProgressModeOnlyText,           // 文字
    ProgressModeLoading,            // 加载菊花
    ProgressModeCircle,             // 加载环形
    ProgressModeCircleLoading,      // 加载环形，要处理进度值
    ProgressModeCustomAnimation,    // 自定义加载动画，序列帧实现
    ProgressModeSuccess,            // 加载成功
    ProgressModeCustomImage         // 自定义加载图片
    
};

@interface MyMBProgressHUD : NSObject

/*========== 属性 ===============*/
@property (nonatomic,strong)MBProgressHUD *hud;

/*========== 下面两个方法提供给本类自己调用的方法 ==============*/

/**
 *  单例方法
 */
+ (instancetype)shareInstance;

/**
 *  公共显示方法
 */
+ (void)show:(NSString *)msg inView:(UIView *)view mode:(ProgressMode *)myMode;

/*========== 下面方法提供给实例化的单例调用 ==========*/
/**
 *  显示提示，1秒后消失
 */
+ (void)showMessage:(NSString *)msg inView:(UIView *)view;


/**
 *  显示提示，N秒后消失
 */
+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;


/**
 *  在最上层显示，不需要指定showView,1秒后消失
 */
+ (void)showMessageWithoutView:(NSString *)msg;


/**
 *  显示进度 - 菊花
 */
+ (void)showProgress:(NSString *)msg inView:(UIView *)view;


/**
 *  显示进度 - 环形
 */
+ (void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view;


/**
 *  显示进度 - 转圈，要处理数据加载进度
 */
+ (MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view;


/**
 *  显示成功
 */
+ (void)showSuccess:(NSString *)msg inView:(UIView *)view;


/**
 *  显示提示，带静态图片（如失败，警告）
 */
+ (void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName inView:(UIView *)view;


/**
 *  显示自定义动画
 */
+ (void)showCustomAnimation:(NSString *)msg withImageArray:(NSArray *)imageArray inView:(UIView *)view;


/**
 *  隐藏
 */
+ (void)hide;





@end

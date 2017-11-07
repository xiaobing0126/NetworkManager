//
//  MyMBProgressHUD.m
//  RichCreditNetwork
//
//  Created by Bing on 2017/10/26.
//  Copyright © 2017年 Bing. All rights reserved.
//

#import "MyMBProgressHUD.h"

@implementation MyMBProgressHUD

/**
 *  单例方法
 */
+ (instancetype)shareInstance
{
    static MyMBProgressHUD *myHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        myHUD = [[MyMBProgressHUD alloc] init];
        
    });
    return myHUD;
}

// 仅供自己调用的通用方法
+ (void)show:(NSString *)msg inView:(UIView *)view mode:(ProgressMode *)myMode customImageView:(UIImageView *)customImageView
{
    // 如果有弹框，先dismiss调
    if ([MyMBProgressHUD shareInstance].hud != nil)
    {
        
        [[MyMBProgressHUD shareInstance].hud hideAnimated:YES];
        [MyMBProgressHUD shareInstance].hud = nil;
        
    }
    
    // 4/4S苹果木避免键盘存在遮挡
    if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        [view endEditing:YES];
    }
    
    [MyMBProgressHUD shareInstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // 设置是否显示遮罩层
//    [MyMBProgressHUD shareInstance].hud.dimBackground = YES;
    
    // 是否设置黑色背景，这两句配合使用
    [MyMBProgressHUD shareInstance].hud.bezelView.color = [UIColor blackColor];
    [MyMBProgressHUD shareInstance].hud.contentColor = [UIColor whiteColor];
    
    
    [[MyMBProgressHUD shareInstance].hud setMargin:10];
    [[MyMBProgressHUD shareInstance].hud setRemoveFromSuperViewOnHide:YES];
    [MyMBProgressHUD shareInstance].hud.detailsLabel.text = msg;
    [MyMBProgressHUD shareInstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    
    // 让HUD显示的时候用户也可以交互
    [MyMBProgressHUD shareInstance].hud.userInteractionEnabled = NO;
    
    switch ((NSInteger)myMode)
    {
            // 文字
            case ProgressModeOnlyText:
            
                [MyMBProgressHUD shareInstance].hud.mode = MBProgressHUDModeText;
            
            break;
            
            
            // 加载菊花
            case ProgressModeLoading:
            
                [MyMBProgressHUD shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
            
            break;
            
            
            // 加载环形
            case ProgressModeCircle:{
            
                [MyMBProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SourceBundle.bundle/loading"]];
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                animation.toValue = [NSNumber numberWithFloat:M_PI*2];
                animation.duration = 1.0;
                animation.repeatCount = 100;
                [image.layer addAnimation:animation forKey:nil];
                
                [MyMBProgressHUD shareInstance].hud.customView = image;
            
            break;
            }
            
            // 自定义加载图片
            case ProgressModeCustomImage:
            
                [MyMBProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                [MyMBProgressHUD shareInstance].hud.customView = customImageView;
            
            break;
            
            
            // 自定义加载动画，序列帧实现
            case ProgressModeCustomAnimation:
            
            // 设置动画的背景色
//                [MyMBProgressHUD shareInstance].hud.bezelView.color = [UIColor yellowColor];
            
                [MyMBProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                [MyMBProgressHUD shareInstance].hud.customView = customImageView;
            
            break;
            
            
            
            // 加载成功
            case ProgressModeSuccess:
            
            
                [MyMBProgressHUD shareInstance].hud.mode = MBProgressHUDModeCustomView;
                [MyMBProgressHUD shareInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SourceBundle.bundle/success"]];
            
            break;
            
            
        default:
            break;
    }
    
    
}


/**
 *  公共显示方法
 */
+ (void)show:(NSString *)msg inView:(UIView *)view mode:(ProgressMode *)myMode
{
    [self show:msg inView:view mode:myMode customImageView:nil];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnon-literal-null-conversion"
/**
 *  显示提示，1秒后消失
 */
+ (void)showMessage:(NSString *)msg inView:(UIView *)view
{
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[MyMBProgressHUD shareInstance].hud hideAnimated:YES afterDelay:1];
}


/**
 *  显示提示，N秒后消失
 */
+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay
{
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[MyMBProgressHUD shareInstance].hud hideAnimated:YES afterDelay:delay];
}


/**
 *  在最上层显示，不需要指定showView，1秒后消失
 */
+ (void)showMessageWithoutView:(NSString *)msg
{
    UIWindow *view = [UIApplication sharedApplication].keyWindow;
    [self show:msg inView:view mode:ProgressModeOnlyText];
    [[MyMBProgressHUD shareInstance].hud hideAnimated:YES afterDelay:1];
}





/**
 *  显示进度 - 菊花
 */
+ (void)showProgress:(NSString *)msg inView:(UIView *)view
{
    [self show:msg inView:view mode:ProgressModeLoading];
}


/**
 *  显示进度 - 环形
 */
+ (void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view
{
    [self show:msg inView:view mode:ProgressModeCircle];
}


/**
 *  显示进度 - 转圈，要处理数据加载进度
 */
+ (MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
}


/**
 *  显示成功
 */
+ (void)showSuccess:(NSString *)msg inView:(UIView *)view
{
    [self show:msg inView:view mode:ProgressModeSuccess];
    [[MyMBProgressHUD shareInstance].hud hideAnimated:YES afterDelay:1];
}


/**
 *  显示提示，带静态图片（如失败，警告）
 */
+ (void)showMsgWithImage:(NSString *)msg imageName:(NSString *)imageName inView:(UIView *)view
{
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:ProgressModeCustomImage customImageView:img];
    [[MyMBProgressHUD shareInstance].hud hideAnimated:YES afterDelay:1];
    
}


/**
 *  显示自定义动画
 */
+ (void)showCustomAnimation:(NSString *)msg withImageArray:(NSArray *)imageArray inView:(UIView *)view
{
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imageArray;
    showImageView.animationRepeatCount = 0;
    showImageView.animationDuration    = (imageArray.count + 1) * 0.075;
    [showImageView startAnimating];
    [self show:msg inView:view mode:ProgressModeCustomAnimation customImageView:showImageView];
}

/**
 *  隐藏
 */
+ (void)hide
{
    if ([MyMBProgressHUD shareInstance].hud != nil)
    {
        
        [[MyMBProgressHUD shareInstance].hud hideAnimated:YES];
        [MyMBProgressHUD shareInstance].hud = nil;
        
    }
}



@end

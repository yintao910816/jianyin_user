//
//  libUMSPosPay.h
//  libUMSPosPay
//
//  Created by Bohan on 2/11/15.
//  Copyright (c) 2015 ChinaUMS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  弹框模式
 */
typedef NS_ENUM(NSInteger, UMSThirdAlertMode) {
    ///普通弹框模式
    UMSThirdAlertModeNormal,
    ///支付弹框模式
    UMSThirdAlertModePayment,
    ///其他弹框模式
    UMSThirdAlertModeAnother
};

/**
 *  用户触发的事件类型
 */
typedef NS_ENUM(NSInteger, UMSTouchEventMode) {
    ///取消事件类型
    UMSTouchEventModeCancel,
    ///确认事件类型
    UMSTouchEventModeConfirm,
    ///选择支付介质事件类型
    UMSTouchEventModeChoosePayMedium,
    ///其他事件类型
    UMSTouchEventModeAnother
};

/**
 *  其他事件类型
 *
 *  @param mode         触发事件类型 @see UMSTouchEventMode
 *  @param encryptedPsd 支付密码
 */
typedef void(^UMSThirdAlertCallBackBlock)(UMSTouchEventMode mode,NSString *encryptedPsd);

@protocol UMSPosPayPluginDelegate <NSObject>

@optional
- (void)onActivityResultErrCode:(NSString *)errCode
                        errInfo:(NSString *)errInfo;

/*!
 @method
 @abstract 调起第三方支付弹框
 @param    alertMode  弹出框模式 @see UMSThirdAlertMode
 @param    info
 用于传递信息，内容可以扩展，
 包含：
 {
 alertTitle        弹出框标题
 alertSubtitle     弹出框副标题
 alertMsg          弹出框提示信息
 payMediumInfo     支付介质展示信息
 cancelBtnTitle    取消按钮标题
 confirmBtnTitle   确认按钮标题
 }
 @param    block   第三方弹框回调 @see UMSThirdAlertCallBackBlock
 */
- (void)onActivityThirdAlertMode:(UMSThirdAlertMode)alertMode
                          params:(NSDictionary *)info
                        callback:(UMSThirdAlertCallBackBlock)block;

/*!
 @method
 @abstract 第三方支付弹框消失
 */
- (void)onActivityThirdAlertDismiss;

@end

/**
 *  近场支付
 */
@interface UMSPPPayPosPay : NSObject

/**
 *  启动插件接口
 *
 *  @param info           支付信息
 *  @param delegate       调用插件回调代理
 */
+ (void)callUMSPosPayPluginWithPaymentInfo:(NSString *)info
                                  delegate:(id<UMSPosPayPluginDelegate>)delegate;

@end

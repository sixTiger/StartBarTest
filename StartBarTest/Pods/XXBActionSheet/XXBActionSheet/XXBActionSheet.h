//
//  XXBActionSheet.h
//  XXBActionSheetView_table
//
//  Created by 杨小兵 on 15/8/16.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBActionSheet;

@protocol XXBActionSheetDelegate <NSObject>
/**
 *  点击按钮
 */
- (void)actionSheet:(XXBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface XXBActionSheet : UIView
/**
 *  代理
 */
@property (nonatomic, weak) id <XXBActionSheetDelegate> delegate;
/**
 *  创建对象方法
 */

- (instancetype)initWithTitle:(NSString *)title delegate:(id<XXBActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");
- (void)showInView:(UIView *)view;
@end

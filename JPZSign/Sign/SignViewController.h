//
//  SignViewController.h
//  InvestmentAssistant
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 jpcf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignDelegate <NSObject>

- (void)signCompleteWithImage:(UIImage *)img base64str:(NSString *)base64str;
@optional
- (void)backMethod;

@end


@interface SignViewController : UIViewController

/** pop出栈 */
- (void)popViewController;
/** 当前NavC是否可以左滑返回，ViewDidLoad中设置 */
@property (nonatomic, assign) BOOL gesturePopEnable;

@property (nonatomic, weak) id<SignDelegate> delegate;

@end

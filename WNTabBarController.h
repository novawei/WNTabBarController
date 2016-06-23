//
//  WNTabBarController.h
//  QDG
//
//  Created by WeiXinxing on 16/5/20.
//  Copyright © 2016年 nova. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WNScrollableTabBar;

@protocol WNScrollableTabBarDelegate <NSObject>

@optional
- (void)scrollableTabBar:(WNScrollableTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index;

@end

@interface WNScrollableTabBar : UIScrollView

@property (nonatomic, weak) id<WNScrollableTabBarDelegate> tabDelegate;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, copy) NSArray *items;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemSpacing;

@end

@interface WNTabBarController : UITabBarController

@property (nonatomic, strong, readonly) WNScrollableTabBar *scrollableTabBar;
- (void)setBadgeNumber:(NSUInteger)badge atIndex:(NSUInteger)index;

@property (nonatomic, assign) NSUInteger selectedTab;

/**
 * WARNING:
 *  DO NOT use the following method to change viewControllers
 *  - (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
 */

@end

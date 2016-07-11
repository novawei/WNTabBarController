//
//  WNTabBarController.h
//  WN
//
//  Created by WeiXinxing on 16/5/20.
//  Copyright © 2016年 nfs. All rights reserved.
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
{
    NSUInteger _selectedTab;
}

@property (nonatomic, strong, readonly) WNScrollableTabBar *scrollableTabBar;
@property (nonatomic, strong) NSArray *tabControllers;

- (void)setBadgeNumber:(NSUInteger)badge atIndex:(NSUInteger)index;

/**
 * 切换tab操作必须使用selectedTab
 * 不能使用setSelectedIndex进行切换tab操作
 */
@property (nonatomic, assign) NSUInteger selectedTab;

/**
 *  WARNING:
 *  不要在外部调用 viewControllers = @[] 修改数组，通过tabControllers修改
 *  不要调用该方法去修改viewControllers
 *  - (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
 */

@end

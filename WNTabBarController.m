//
//  WNTabBarController.m
//  WN
//
//  Created by WeiXinxing on 16/5/20.
//  Copyright © 2016年 nfs. All rights reserved.
//

#import "WNTabBarController.h"

@interface WNTabBarItemButton : UIButton

@property (nonatomic, strong) UIImageView *badgeView;

@end

@implementation WNTabBarItemButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.badgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_dot_badge"]];
        [self addSubview:self.badgeView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    
    // set x, center horizontal
    imageFrame.origin.x = (CGRectGetWidth(bounds)-CGRectGetWidth(imageFrame))*0.5;
    // set y, (title+image) should center horizontal
    imageFrame.origin.y = (CGRectGetHeight(bounds)-self.imageEdgeInsets.top-CGRectGetHeight(imageFrame)-self.imageEdgeInsets.bottom-self.titleEdgeInsets.top-CGRectGetHeight(titleFrame)-self.titleEdgeInsets.bottom)*0.5;
    self.imageView.frame = imageFrame;
    // set x, center horizontal
    titleFrame.size.width = CGRectGetWidth(bounds)-self.titleEdgeInsets.left-self.titleEdgeInsets.right;
    titleFrame.origin.x = (CGRectGetWidth(bounds)-CGRectGetWidth(titleFrame))*0.5;
    // set y, base on image
    titleFrame.origin.y = CGRectGetMaxY(imageFrame)+self.imageEdgeInsets.bottom+self.titleEdgeInsets.top;
    self.titleLabel.frame = titleFrame;
    
    CGRect badgeFrame = self.badgeView.frame;
    badgeFrame.origin.x = CGRectGetMaxX(imageFrame)-CGRectGetWidth(badgeFrame)*0.5;
    badgeFrame.origin.y = CGRectGetMinY(imageFrame);
    self.badgeView.frame = badgeFrame;
}

@end

@implementation WNScrollableTabBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.scrollsToTop = NO;
        
        _itemSpacing = 0;
        _selectedIndex = 0;
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    if (items.count == 0) {
        self.itemWidth = 0;
    } else if (items.count < 6) {
        self.itemWidth = [UIScreen width]/items.count;
    } else {
        self.itemWidth = [UIScreen width]/6;
    }
    
    CGRect frame = CGRectMake(0, 0, self.itemWidth, CGRectGetHeight(self.bounds));
    for (int i = 0; i < items.count; i++) {
        frame.origin.x = (self.itemSpacing+self.itemWidth)*i;
        
        WNTabBarItemButton *itemButton = [[WNTabBarItemButton alloc] initWithFrame:frame];
        itemButton.tag = VIEW_TAG + i;
        itemButton.titleLabel.font = [UIFont systemFontOfSize:10];
        itemButton.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        itemButton.badgeView.hidden = YES;
        
        UITabBarItem *tabBarItem = items[i];
        [itemButton setImage:tabBarItem.image forState:UIControlStateNormal];
        if (tabBarItem.selectedImage) {
            [itemButton setImage:tabBarItem.selectedImage forState:UIControlStateSelected];
            [itemButton setImage:tabBarItem.selectedImage forState:UIControlStateHighlighted];
        }
        [itemButton setTitle:tabBarItem.title forState:UIControlStateNormal];
        [itemButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [itemButton setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
        [itemButton setTitleColor:BLUE_COLOR forState:UIControlStateHighlighted];
        
        itemButton.selected = (i == self.selectedIndex);
        
        [itemButton addTarget:self action:@selector(handleItemAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:itemButton];
    }
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(frame), CGRectGetHeight(frame));
}

- (void)handleItemAction:(UIButton *)itemButton
{
    self.selectedIndex = itemButton.tag - VIEW_TAG;
    
    if ([self.tabDelegate respondsToSelector:@selector(scrollableTabBar:didSelectItemAtIndex:)]) {
        [self.tabDelegate scrollableTabBar:self didSelectItemAtIndex:self.selectedIndex];
    }
    
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    anim.duration = 0.5;
//    anim.values = @[@(1.0), @(1.3), @(0.9), @(1.0)];
//    [itemButton.imageView.layer addAnimation:anim forKey:@"Bounce"];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    UIButton *itemButton = [self viewWithTag:VIEW_TAG+selectedIndex];
    if (itemButton) {
        UIButton *prevButton = [self viewWithTag:VIEW_TAG+_selectedIndex];
        prevButton.selected = NO;
        itemButton.selected = YES;
        
        _selectedIndex = selectedIndex;
    }
}

- (void)setBadgeNumber:(NSUInteger)badge atIndex:(NSUInteger)index
{
    WNTabBarItemButton *btn = [self viewWithTag:VIEW_TAG+index];
    btn.badgeView.hidden = (badge == 0);
}

@end

@interface WNTabBarController () <WNScrollableTabBarDelegate>

@property (nonatomic, strong) WNScrollableTabBar *scrollableTabBar;

@end

@implementation WNTabBarController

@synthesize selectedTab = _selectedTab;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupScrollableTabBarIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedTab:(NSUInteger)selectedTab
{
    if (selectedTab < self.tabControllers.count) {
        _selectedTab = selectedTab;
        
        self.scrollableTabBar.selectedIndex = selectedTab;
        UIViewController *controller = self.tabControllers[selectedTab];
        [super setViewControllers:[[NSArray alloc] initWithObjects:controller, nil]];
    }
}

- (void)setTabControllers:(NSArray *)tabControllers
{
    _tabControllers = tabControllers;
    [self setupScrollableTabBarIfNeeded];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    // 设置viewControllers之后，tabBar就会重新布局，必须把scrollableTabBar重新移到最前面
    [self.tabBar bringSubviewToFront:self.scrollableTabBar];
}

- (void)setBadgeNumber:(NSUInteger)badge atIndex:(NSUInteger)index
{
    [self.scrollableTabBar setBadgeNumber:badge atIndex:index];
}

- (void)setupScrollableTabBarIfNeeded
{
    if (!self.isViewLoaded) {
        return;
    }
    
    NSUInteger count = self.tabControllers.count;
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        UIViewController *controller = self.tabControllers[i];
        [tabBarItems addObject:controller.tabBarItem];
        // 覆盖tabBarItem，以免重合，图片不能为空，采用了透明的图片进行掩盖
        controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_fake"] tag:i];
    }
    
    if (!self.scrollableTabBar) {
        self.scrollableTabBar = [[WNScrollableTabBar alloc] initWithFrame:self.tabBar.bounds];
        self.scrollableTabBar.tabDelegate = self;
        [self.tabBar addSubview:self.scrollableTabBar];
    }
    self.scrollableTabBar.items = tabBarItems;
    
    if (tabBarItems.count > 0) {
        [self scrollableTabBar:self.scrollableTabBar didSelectItemAtIndex:0];
    }
}

#pragma mark - WNScrollableTabBarDelegate

- (void)scrollableTabBar:(WNScrollableTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index
{
    self.selectedTab = index;
}

@end

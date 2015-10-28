//
//  HeadTest.m
//  StartBarTest
//
//  Created by xiaobing on 15/10/23.
//  Copyright © 2015年 杨小兵. All rights reserved.
//

#import "HeadTest.h"
#import <XXBLibs.h>

#define headViewHeight 300
@interface HeadTest ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic , weak)UITableView      *tableView;
@property(nonatomic , weak)UIView           *statusBarView;
@property(nonatomic , weak)UIImageView      *hearView;
@property(nonatomic , weak) UIWindow        *startWindow;

@end

@implementation HeadTest
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView bringSubviewToFront:self.hearView];
    [self addObserverOnTableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self p_showHeaderView];
    });
}
- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)addObserverOnTableView
{
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)p_showHeaderView
{
    self.tableView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, - headViewHeight)animated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = _tableView.contentOffset.y;
        NSLog(@"%@",@(offsetY));
        
        self.hearView.y =  - self.tableView.contentOffset.y - headViewHeight;
        if (offsetY > 0)
        {
            [self p_showStatusBarBG:YES animated:YES];
        }
        else
        {
            [self p_showStatusBarBG:NO animated:YES];
        }
        if (offsetY >= -20)
        {
            self.startWindow.y = - offsetY - 20;
//            self.startWindow.backgroundColor = [UIColor redColor];
        }
        else
        {
            
//            self.startWindow.backgroundColor = [UIColor blackColor];
            self.startWindow.y = 0;
        }
    }
}
- (void)p_showStatusBarBG:(BOOL)isShow animated:(BOOL)animated
{
    [UIView animateWithDuration:animated?0.25:0.0 animations:^{
        self.statusBarView.alpha = isShow?1.0:0.0;
    }];
}
#pragma mark - table 的相关代理和实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cel"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --> %@",@(indexPath.section),@(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self presentViewController:[[HeadTest alloc] init] animated:YES completion:nil];
}
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = (1 << 6) - 1;
        [self.view addSubview:tableView];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    return _tableView;
}
- (UIView *)statusBarView
{
    if (_statusBarView == nil)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
        [self.view insertSubview:view aboveSubview:self.tableView];
        view.backgroundColor = [UIColor myRandomColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        _statusBarView = view;
    }
    return _statusBarView;
}
- (UIImageView *)hearView
{
    if (_hearView == nil)
    {
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -headViewHeight, CGRectGetWidth(self.tableView.frame), headViewHeight)];
        headView.backgroundColor = [UIColor blueColor];
        headView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        headView.image =  [UIImage imageNamed:@"head"];
        [self.view insertSubview:headView belowSubview:self.tableView];
        headView.contentMode = UIViewContentModeScaleAspectFill;
        _hearView = headView;
    }
    return _hearView;
}
- (UIWindow *)startWindow
{
    if (_startWindow == nil)
    {
        _startWindow = [[UIApplication sharedApplication] valueForKeyPath:@"statusBarWindow"];
    }
    return _startWindow;
}
@end

//
//  ViewController.m
//  StartBarTest
//
//  Created by 杨小兵 on 15/8/28.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "ViewController.h"
#import <XXBLibs.h>

#define headViewHeight 150
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic , weak)UITableView *tableView;
@property(nonatomic , weak)UIView *statusBarView;
@property(nonatomic , weak)UIImageView *hearView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView bringSubviewToFront:self.hearView];
    [self addObserverOnTableView];
    self.tableView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    self.tableView.tintColor = [UIColor redColor];
}
- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)addObserverOnTableView
{
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = _tableView.contentOffset.y;
        CGFloat height = headViewHeight - self.tableView.contentOffset.y;
        if (height <= 10)
        {
            height = 10;
        }
        self.hearView.height =  height;
        
        NSLog(@"%@ ---> %@ %@",@(_tableView.contentOffset.y),@(self.hearView.height),@(self.hearView.y));
        if (offsetY > 0)
        {
            [self p_showStatusBarBG:YES animated:YES];
        }
        else
        {
            [self p_showStatusBarBG:NO animated:YES];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"------>>>>> %@",@(section)];
}
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
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - 100, CGRectGetWidth(self.tableView.frame), 300)];
        headView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        headView.image =  [UIImage imageNamed:@"head"];
        [self.view insertSubview:headView belowSubview:self.tableView];
        headView.contentMode = UIViewContentModeScaleAspectFill;
        _hearView = headView;
    }
    return _hearView;
}
@end

//
//  XXBActionSheet.m
//  XXBActionSheetView_table
//
//  Created by 杨小兵 on 15/8/16.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//
#import "XXBActionSheet.h"

// 每个按钮的高度
#define CellHeight 46
// 取消按钮上面的间隔高度
#define Margin 8

#define XXBCColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
// 背景色
#define GlobelBgColor XXBCColor(237, 240, 242)
// 分割线颜色
#define GlobelSeparatorColor XXBCColor(226, 226, 226)
// 普通状态下的图片
#define normalImage [self createImageWithColor:XXBCColor(255, 255, 255)]
// 高亮状态下的图片
#define highImage [self createImageWithColor:XXBCColor(242, 242, 242)]

// 字体
#define HeitiLight(f) [UIFont fontWithName:@"STHeitiSC-Light" size:f]


#pragma  mark - 显示的按钮
@interface XXBActionSheetTableViewCell : UITableViewCell
@property(nonatomic , strong)UILabel *titleLabel;
@property(nonatomic , strong)UIView *lineView;
@end
@implementation XXBActionSheetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview: _titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *lcLeftTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *lcTopTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *lcRightTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *lcBottomTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:- 0.5];
        [self.contentView addConstraint:lcRightTitleLabel];
        [self.contentView addConstraint:lcLeftTitleLabel];
        [self.contentView addConstraint:lcTopTitleLabel];
        [self.contentView addConstraint:lcBottomTitleLabel];
        
        _lineView = [UIView new];
        
        _lineView.backgroundColor = GlobelSeparatorColor;
        [self.contentView addSubview:_lineView];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *lcRightLineView = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *lcLeftLineView = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *lcTopLineLineView = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        NSLayoutConstraint *lcHeightLineView = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
        
        [self.contentView addConstraints:@[lcRightLineView, lcLeftLineView, lcTopLineLineView]];
        [self.lineView addConstraint:lcHeightLineView];
        
    }
    return self;
}

@end


@interface XXBrotationViewController : UIViewController
@end
@implementation XXBrotationViewController

- (BOOL)shouldAutorotate
{
    return YES;
}
@end

@interface XXBActionSheet ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic , strong)UIWindow           *keyWindow;
@property(nonatomic , strong)UIWindow           *actionSheetWindow;
@property(nonatomic , strong)UITableView        *tableView;
@property (nonatomic, strong)UIView             *sheetView;
@property(nonatomic , strong)UIView             *titleView;
@property(nonatomic , strong)UILabel            *titleLabel;
@property(nonatomic , strong)NSMutableArray     *dataSourceArray;
@property(nonatomic , copy)NSString *title;
@end

@implementation XXBActionSheet
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        self.autoresizingMask = (1 << 6) - 1;
        [self p_creatWindow];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title delegate:(id<XXBActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super init])
    {
        self.delegate = delegate;
        self.title = title;
        [self p_creatSheetView];
        [self p_creatTitleView:title];
        
        NSString* curStr;
        va_list list;
        if(otherButtonTitles)
        {
            [self p_creatTableView];
            self.dataSourceArray = [NSMutableArray array];
            [self.dataSourceArray addObject:[otherButtonTitles copy]];
            va_start(list, otherButtonTitles);
            while ((curStr = va_arg(list, NSString*)))
            {
                [self.dataSourceArray addObject:[curStr copy]];
            }
            va_end(list);
        }
        CGRect sheetViewF = _sheetView.frame;
        sheetViewF.size.height = CellHeight + Margin + CellHeight * self.dataSourceArray.count;
        _sheetView.frame = sheetViewF;
        [self p_creatCancleButton:cancelButtonTitle];
    }
    return self;
}
- (void)dealloc
{
    NSLog(@"---->dealloc");
}
- (void)showInView:(UIView *)view
{
    self.frame = self.actionSheetWindow.rootViewController.view.bounds;
    [self.actionSheetWindow.rootViewController.view addSubview:self];
    self.sheetView.hidden = NO;
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = CGRectGetHeight(self.frame);
    self.sheetView.frame = sheetViewF;
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = CGRectGetHeight(self.frame) - self.sheetView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = newSheetViewF;
        self.window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }];
}
- (void)p_creatWindow
{
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _actionSheetWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _actionSheetWindow.backgroundColor = [UIColor clearColor];
    _actionSheetWindow.windowLevel = CGFLOAT_MAX;
    [_actionSheetWindow makeKeyAndVisible];
    _actionSheetWindow.rootViewController = [[UIViewController alloc] init];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.dataSourceArray.count * CellHeight + CellHeight + Margin + (self.title?CellHeight:0);
    if (height >= CGRectGetHeight(self.frame))
    {
        height = CGRectGetHeight(self.frame) - 44;
    }
    CGRect sheetViewFrame = self.sheetView.frame;
    sheetViewFrame.size.height = height;
    sheetViewFrame.origin.y = CGRectGetHeight(self.frame) - height;
    self.sheetView.frame = sheetViewFrame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.alwaysBounceVertical = self.tableView.contentSize.height > self.tableView.frame.size.height + 1;
    });
}
- (void)p_creatSheetView
{
    _sheetView = [[UIView alloc] initWithFrame:self.bounds];
    _sheetView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    _sheetView.alpha = 1.0;
    [self addSubview:_sheetView];
    _sheetView.hidden = YES;
}
- (void)p_creatTitleView:(NSString *)title
{
    if (title)
    {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _sheetView.frame.size.width, CellHeight)];
        _titleView.backgroundColor = GlobelSeparatorColor;
        [_sheetView addSubview:_titleView];
        _titleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), CellHeight - 0.5)];
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
        _titleLabel.autoresizingMask = (1 << 6) -1;
    }
}
- (void)p_creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.sheetView.bounds),CGRectGetHeight(self.sheetView.bounds) - CGRectGetHeight(self.titleLabel.frame) - CellHeight - Margin ) style:UITableViewStylePlain];
    [_sheetView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *lcRightTableView = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_sheetView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *lcLeftTableView = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_sheetView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *lcTopTableView = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: _sheetView attribute:NSLayoutAttributeTop multiplier:1.0 constant:CGRectGetHeight(_titleView.bounds)];
    
    NSLayoutConstraint *lcBottomTableView = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_sheetView attribute:NSLayoutAttributeBottom multiplier:1.0 constant: -CellHeight - Margin];
    [self.sheetView addConstraints:@[lcRightTableView, lcLeftTableView,lcTopTableView,lcBottomTableView]];
}
- (void)p_creatCancleButton:(NSString *)string
{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, _sheetView.frame.size.height - CellHeight, CGRectGetWidth(self.sheetView.frame), CellHeight)];
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleTopMargin;
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitle:string forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = HeitiLight(17);
    btn.tag = 0;
    [btn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self coverClick:nil];
}
- (void)coverClick:(void(^)())finish
{
    [self.keyWindow makeKeyAndVisible];
    CGRect viewFrame = self.window.rootViewController.view.frame;
    [UIView animateWithDuration:0.25 animations:^{
        self.window.rootViewController.view.frame = CGRectMake(0,CGRectGetHeight(self.sheetView.frame) ,viewFrame.size.width , viewFrame.size.height);
    } completion:^(BOOL finished) {
        finish();
        [UIView animateWithDuration:0.25 animations:^{
            self.window.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}
- (void)cancleBtnClick:(UIButton *)btn
{
    [self coverClick:^{
        if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        {
            [self.delegate actionSheet:self clickedButtonAtIndex:0];
        }
    }];
}
- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXBActionSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXBActionSheetTableViewCell"];
    if (cell == nil)
    {
        cell = [[XXBActionSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXBActionSheetTableViewCell"];
    }
    cell.titleLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self coverClick:^{
        [self.delegate actionSheet:self clickedButtonAtIndex:(indexPath.row + 1)];
    }];
}
@end
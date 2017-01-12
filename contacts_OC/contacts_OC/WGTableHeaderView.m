//
//  WGTableHeaderView.m
//  Contacts
//
//  Created by Admin on 17/1/9.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGTableHeaderView.h"

@implementation WGTableHeaderView

- (void)setShowInfo:(BOOL)showInfo
{
    _showInfo = showInfo;
    [self initSubViews];
}

- (UIButton *)infoButton
{
    return _infoButton;
}

- (UIButton *)historyButton
{
    return _historyButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _showInfo = YES;
        [self initSubViews];
    }
    
    return self;
}

- (void)initSubViews
{
    if (!_infoButton)
    {
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _infoButton.frame = CGRectMake(0, 0, self.frame.size.width / 2 - 10, 50);
        _infoButton.center = CGPointMake(0.5 * self.center.x, 25);
        [_infoButton setTitle:@"Information" forState:UIControlStateNormal];
        [_infoButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_infoButton];
    }
    [_infoButton setTitleColor:_showInfo ? [UIColor blueColor] : [UIColor blackColor] forState:UIControlStateNormal];

    if (!_historyButton)
    {
        _historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyButton.frame = CGRectMake(0, 0, self.frame.size.width / 2 - 10, 50);
        _historyButton.center = CGPointMake(1.5 * self.center.x, 25);
        [_historyButton setTitle:@"History" forState:UIControlStateNormal];
        [_historyButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_historyButton];
    }
    [_historyButton setTitleColor:_showInfo ? [UIColor blackColor] : [UIColor blueColor] forState:UIControlStateNormal];
}

- (void)onAction:(UIButton *)button
{
    WGNSLog(@"%@",button.titleLabel.text);
    if ([button.titleLabel.text isEqualToString:@"Information"])
    {
        _showInfo = YES;
    }
    else if ([button.titleLabel.text isEqualToString:@"History"])
    {
        _showInfo = NO;
    }
    [self initSubViews];
    
    if ([_delegate respondsToSelector:@selector(tableHeaderView:didChangedShowInfo:)])
    {
        [_delegate tableHeaderView:self didChangedShowInfo:_showInfo];
    }
}













@end

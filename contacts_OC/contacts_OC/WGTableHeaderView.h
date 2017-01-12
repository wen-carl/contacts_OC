//
//  WGTableHeaderView.h
//  Contacts
//
//  Created by Admin on 17/1/9.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WGTableHeaderView;

@protocol WGTableHeaderViewDelegate <NSObject>

- (void)tableHeaderView:(WGTableHeaderView *)headerView didChangedShowInfo:(BOOL)showInfo;

@end

@interface WGTableHeaderView : UIView
{
    UIButton *_infoButton;
    UIButton *_historyButton;
}

@property (nonatomic, strong, readonly) UIButton *infoButton;
@property (nonatomic, strong, readonly) UIButton *historyButton;
@property (nonatomic, assign) BOOL showInfo;
@property (nonatomic, weak) id <WGTableHeaderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end




//
//  WGContactDetailView.h
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGContact.h"
#import "WGHeaderView.h"
#import "WGTableViewCell.h"
#import "WGTableHeaderView.h"

@class WGContactDetailView;
@protocol WGContactDetailViewDelegate <NSObject>

- (void)contactDetailView:(WGContactDetailView *)detailView didChangesShowInfo:(BOOL)showInfo;

@end

@interface WGContactDetailView : UIView

@property (nonatomic, strong, readonly) WGContact *contact;
@property (nonatomic, assign) BOOL isEditting;
@property (nonatomic, assign) BOOL showInfo;
@property (nonatomic, weak) id <WGContactDetailViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame andContact:(WGContact *)contact;
- (void)willbeginEditting;
- (BOOL)didEndEditting;

@end

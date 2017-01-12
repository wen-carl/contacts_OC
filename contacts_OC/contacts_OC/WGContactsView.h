//
//  WGContactsView.h
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGContact.h"
#import "WGContactGroup.h"

@class WGContactsView;

@protocol WGContactsViewDelegate <NSObject>

- (void)contactsView:(WGContactsView *)contactsView didSelectContact:(WGContact *)contact andIndex:(NSInteger)index;

@end


@interface WGContactsView : UIView

@property (nonatomic, strong) NSMutableDictionary *allContacts;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id <WGContactsViewDelegate> delegate;



- (instancetype)initWithFrame:(CGRect)frame;
- (void)setUpData;

@end






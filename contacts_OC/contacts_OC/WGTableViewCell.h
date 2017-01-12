//
//  WGTableViewCell.h
//  Contacts
//
//  Created by Admin on 17/1/9.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WGTableViewCellStyleDefalt,
    WGTableViewCellStyleValue1,  // Add
    WGTableViewCellStyleValue2,  // Delete
} WGTableViewCellStyle;

@class WGTableViewCell;

@protocol WGTableViewCellDelegate <NSObject>

- (void)tableViewCell:(WGTableViewCell *)cell didChangesData:(BOOL)isAdd;

@end

@interface WGTableViewCell : UITableViewCell
{
    UILabel *_kindLabel;
    UITextField *_infoTextField;
}

@property (nonatomic, strong, readonly) UILabel *kindLabel;
@property (nonatomic, strong, readonly) UITextField *infoTextField;
@property (nonatomic, assign) WGTableViewCellStyle style;
@property (nonatomic, assign) BOOL isEditting;
@property (nonatomic, weak) id <WGTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(WGTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

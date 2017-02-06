//
//  WGTableViewCell.h
//  Contacts
//
//  Created by Admin on 17/1/9.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_KINDTF        1000
#define TAG_INFOTF        1001

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
    UITextField *_kindTextfield;
    UITextField *_infoTextField;
}

@property (nonatomic, strong, readonly) UITextField *kindTextfield;
@property (nonatomic, strong, readonly) UITextField *infoTextField;
@property (nonatomic, assign) WGTableViewCellStyle style;
@property (nonatomic, assign) BOOL isEditting;
@property (nonatomic, weak) id <WGTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(WGTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

//
//  WGTableViewCell.m
//  Contacts
//
//  Created by Admin on 17/1/9.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGTableViewCell.h"

@implementation WGTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setKindLabel:(UILabel *)kindLabel
{
    _kindLabel = kindLabel;
}

- (UILabel *)kindLabel
{
    if (!_kindLabel)
    {
        _kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, self.frame.size.height)];
        _kindLabel.textAlignment = NSTextAlignmentRight;
        _kindLabel.textColor = [UIColor darkGrayColor];
//        _kindLabel.layer.borderColor = [UIColor redColor].CGColor;
//        _kindLabel.layer.borderWidth = 1.0f;
    }
    
    return _kindLabel;
}

- (void)setInfoTextField:(UITextField *)infoTextField
{
    _infoTextField = infoTextField;
}

- (UITextField *)infoTextField
{
    if (!_infoTextField)
    {
        _infoTextField = [[UITextField alloc] initWithFrame:CGRectMake(125, 0, self.frame.size.width - 100, self.frame.size.height)];
        _infoTextField.borderStyle = UITextBorderStyleRoundedRect;
        _infoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _infoTextField;
}

- (void)setIsEditting:(BOOL)isEditting
{
    _isEditting = isEditting;
    _infoTextField.enabled = _isEditting;
    _infoTextField.borderStyle = _isEditting ? UITextBorderStyleRoundedRect : UITextBorderStyleLine;
    self.accessoryView.hidden = !_isEditting;
}

- (instancetype)initWithStyle:(WGTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _style = style;
        [self.contentView addSubview:self.kindLabel];
        [self.contentView addSubview:self.infoTextField];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 30, 30);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15;
        
        switch (style)
        {
            case WGTableViewCellStyleValue1:
                button.backgroundColor = [UIColor greenColor];
                [button addTarget:self action:@selector(onAdd:) forControlEvents:UIControlEventTouchUpInside];
                self.accessoryView = button;
                break;
                
            case WGTableViewCellStyleValue2:
                button.backgroundColor = [UIColor redColor];
                [button addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
                self.accessoryView = button;
                break;
                
            case WGTableViewCellStyleDefalt:
            default:
                break;
        }
    }
    
    return self;
}

- (void)onAdd:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didChangesData:)])
    {
        [_delegate tableViewCell:self didChangesData:YES];
    }
}

- (void)onDelete:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:didChangesData:)])
    {
        [_delegate tableViewCell:self didChangesData:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

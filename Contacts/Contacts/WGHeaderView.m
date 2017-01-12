//
//  WGHeaderView.m
//  Contacts
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGHeaderView.h"

@interface WGHeaderView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation WGHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isEditting = NO;
    }
    
    return self;
}

- (void)initSubviews
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 140, 140)];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
        _imageView.layer.borderWidth = 1.0f;
        _imageView.layer.cornerRadius = 70;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChooseImage:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [_imageView addGestureRecognizer:singleTap];
    }
    _imageView.userInteractionEnabled = _isEditting;
    
    if (!_nameTf)
    {
        _nameTf = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, _imageView.center.y - 20, self.frame.size.width / 3, 40)];
        _nameTf.font = [UIFont systemFontOfSize:24];
        _nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_nameTf];
    }
    _nameTf.enabled = _isEditting;
    _nameTf.borderStyle = _isEditting ? UITextBorderStyleRoundedRect: UITextBorderStyleNone;
    
    if (!_label)
    {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, _imageView.center.y - 60, self.frame.size.width / 3, 40)];
        _label.text = @"Name:";
        [self addSubview:_label];
    }
    _label.hidden = !_isEditting;
}

- (void)setContact:(WGContact *)contact
{
    _contact = contact;
    _imageView.image = _contact.image;
    _nameTf.text = _contact.name;
}

- (void)setIsEditting:(BOOL)isEditting
{
    _isEditting = isEditting;
    [self initSubviews];
}

- (void)refresh
{
    [self initSubviews];
}

#pragma mark UITapGestureRecognizer

- (void)onChooseImage:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([_delegate respondsToSelector:@selector(imagePickerWillBePresented:)])
        {
            [_delegate imagePickerWillBePresented:picker];
        }
    }
}

#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _imageView.image = image;
    if ([_delegate respondsToSelector:@selector(imagePicker:DidFinishPicking:)])
    {
        [_delegate imagePicker:picker DidFinishPicking:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}












@end

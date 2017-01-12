//
//  WGHeaderView.h
//  Contacts
//
//  Created by Admin on 17/1/6.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGContact.h"


@protocol WGHeaderViewDelegate <NSObject>

- (void)imagePickerWillBePresented:(UIImagePickerController *)picker;
- (void)imagePicker:(UIImagePickerController *)picker DidFinishPicking:(UIImage *)image;

@end

@interface WGHeaderView : UIView

@property (nonatomic, strong) WGContact *contact;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UITextField *nameTf;
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, assign) BOOL isEditting;
@property (nonatomic, weak) id <WGHeaderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refresh;

@end

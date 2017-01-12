//
//  WGContactDetailVC.h
//  Contacts
//
//  Created by Admin on 17/1/4.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGContactDetailView.h"

@interface WGContactDetailVC : UIViewController

@property (nonatomic, strong) WGContact *contact;
@property (nonatomic, assign) NSInteger index;


@end

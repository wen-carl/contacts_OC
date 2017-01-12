//
//  WGContact.h
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WGContactGroup.h"
#import <objc/runtime.h>

@interface WGContact : NSObject <NSCoding>
{
    WGContactGroup *_group;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableDictionary *phoneNum;
@property (nonatomic, strong) NSMutableDictionary *email;
@property (nonatomic, strong, readonly) WGContactGroup *group;

+ (instancetype)contactWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;
- (NSString *)getFirstLetter;
- (NSArray *)getNonullProperties:(BOOL)isNil;

+ (NSMutableDictionary *)getContactsDataFromLocal;
+ (BOOL)saveContactsDataToLocale:(NSMutableDictionary *)dic;
+ (BOOL)saveContact:(WGContact *)contact beReplaced:(WGContact *)originContact andIndex:(NSInteger)index;

@end

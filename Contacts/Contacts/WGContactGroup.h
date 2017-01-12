//
//  WGContactGroup.h
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WGContact;

@interface WGContactGroup : NSObject <NSCoding>
{
    NSMutableArray <WGContact *> *_contacts;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) NSMutableArray <WGContact *> *contacts;

+ (instancetype)contactGroupWithName:(NSString *)name andDetail:(NSString *)detail;

- (instancetype)initWithName:(NSString *)name andDetail:(NSString *)detail;

@end

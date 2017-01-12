//
//  WGContactGroup.m
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGContactGroup.h"
#import "WGContact.h"

#define CG_NAME       @"CG_name"
#define CG_DETAIL     @"CG_detail"
#define CG_CONTACTS   @"CG_contacts"

@implementation WGContactGroup

+ (instancetype)contactGroupWithName:(NSString *)name andDetail:(NSString *)detail
{
    return [[WGContactGroup alloc] initWithName:name andDetail:detail];
}

- (instancetype)initWithName:(NSString *)name andDetail:(NSString *)detail
{
    self = [super init];
    if (self)
    {
        _name = name;
        _detail = detail;
    }
    
    return self;
}

- (void)setContacts:(NSMutableArray <WGContact *>*)contacts
{
    NSArray *arr = [contacts sortedArrayUsingComparator:finderSortBlock];
    _contacts = [NSMutableArray arrayWithArray:arr];
    //_contacts = [contacts sortedArrayUsingFunction:sortContact context:NULL];
}

- (NSMutableArray<WGContact *> *)contacts
{
    if (!_contacts)
    {
        _contacts = [NSMutableArray array];
    }
    
    return _contacts;
}

#pragma mark NSCoding protocol

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:CG_NAME];
        _detail = [aDecoder decodeObjectForKey:CG_DETAIL];
        _contacts = [aDecoder decodeObjectForKey:CG_CONTACTS];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:CG_NAME];
    [aCoder encodeObject:_detail forKey:CG_DETAIL];
    [aCoder encodeObject:_contacts forKey:CG_CONTACTS];
}

#pragma mark 排序

- (NSComparisonResult)compareContact:(WGContactGroup *)other
{
    NSComparisonResult result = [self.name compare:other.name];
    if (result == NSOrderedSame)
    {
        // 可以按照其他属性排序
    }
    
    return result;
}

NSComparator finderSortBlock = ^(id con1, id con2)
{
    WGContact *c1 = (WGContact *)con1;
    WGContact *c2 = (WGContact *)con2;
    
    NSRange range = NSMakeRange(0, [c1.name length]);
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    return [c1.name compare:c2.name options:comparisonOptions range:range locale:[NSLocale currentLocale]];
};

NSInteger sortContact(id con1, id con2, void *context)
{
    WGContact *c1 = (WGContact *)con1;
    WGContact *c2 = (WGContact *)con2;
    
    return [c2.name localizedCompare:c1.name];
}







@end

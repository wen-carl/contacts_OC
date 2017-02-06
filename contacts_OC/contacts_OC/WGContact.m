//
//  WGContact.m
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGContact.h"

#define C_NAME               @"C_name"
#define C_PHONENUM           @"C_phoneNum"
#define C_IMAGE              @"C_image"
#define C_GROUP              @"C_group"
#define C_ADDRESS            @"C_address"
#define C_BIRTHDAY           @"C_birthday"
#define C_EMAIL              @"C_email"
#define KEY_ARCHIVER         @"key_contacts"


@implementation WGContact

+ (instancetype)contactWithName:(NSString *)name
{
    return [[WGContact alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _name = name;
    }
    
    return self;
}

- (UIImage *)image
{
    if (!_image)
    {
        _image = [UIImage imageNamed:@"contact.png"];
    }
    
    return _image;
}

- (NSMutableDictionary *)phoneNum
{
    if (!_phoneNum)
    {
        NSMutableArray <NSString *> *arr = [NSMutableArray arrayWithArray:@[@"phoneNum1",@"phoneNum2",@"phoneNum3"]];
        _phoneNum = [NSMutableDictionary dictionaryWithObject:arr forKey:@"index"];
        [_phoneNum setObject:@"" forKey:@"phoneNum1"];
    }
    
    return _phoneNum;
}

- (NSMutableDictionary *)email
{
    if (!_email)
    {
        NSMutableArray <NSString *> *arr = [NSMutableArray arrayWithArray:@[@"email1",@"email2",@"email3"]];
        _email = [NSMutableDictionary dictionaryWithObject:arr forKey:@"index"];
        [_email setObject:@"" forKey:@"email1"];
    }
    
    return _email;
}

- (NSString *)group
{
    if (!_group)
    {
        _group = [self getFirstLetter].uppercaseString;
    }
    return _group;
}

- (NSString *)getFirstLetter
{
    NSString *firstLetter = nil;
    NSString *subString = [_name substringToIndex:1];
    // 英文占1个字节   汉字占三个字节
    if (strlen(subString.UTF8String) == 1)
    {
        firstLetter = subString;
    }
    else
    {
        // 转换为可变字符串
        NSMutableString *mutableStr = [NSMutableString stringWithString:subString];
        // 转换为带音调的拼音
        CFStringTransform((CFMutableStringRef)mutableStr, NULL, kCFStringTransformMandarinLatin, NO);
        // 转换为不带音调的拼音
        CFStringTransform((CFMutableStringRef)mutableStr, NULL, kCFStringTransformStripDiacritics, NO);
        // 转换为大写拼音
        NSString *str = [mutableStr capitalizedString];
        firstLetter = [str substringToIndex:1];
    }
    
    return firstLetter;
}

#pragma mark NSCoding protocol

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:C_NAME];
        _phoneNum = [aDecoder decodeObjectForKey:C_PHONENUM];
        _image = [aDecoder decodeObjectForKey:C_IMAGE];
        _group = [aDecoder decodeObjectForKey:C_GROUP];
        _address = [aDecoder decodeObjectForKey:C_ADDRESS];
        _birthday = [aDecoder decodeObjectForKey:C_BIRTHDAY];
        _email = [aDecoder decodeObjectForKey:C_EMAIL];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:C_NAME];
    [aCoder encodeObject:_phoneNum forKey:C_PHONENUM];
    [aCoder encodeObject:_image forKey:C_IMAGE];
    [aCoder encodeObject:_group forKey:C_GROUP];
    [aCoder encodeObject:_address forKey:C_ADDRESS];
    [aCoder encodeObject:_birthday forKey:C_BIRTHDAY];
    [aCoder encodeObject:_email forKey:C_EMAIL];
}

#pragma mark Data

+ (NSString *)getContactsPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/Contacts.plist"];
    
    return path;
}

+ (BOOL)saveContact:(WGContact *)contact beReplaced:(WGContact *)originContact andIndex:(NSInteger)index
{
    NSMutableDictionary *contactDic = [self getContactsDataFromLocal];
    if (originContact)
    {
        WGContactGroup *oldGroup = contactDic[originContact.group];
        [oldGroup.contacts removeObjectAtIndex:index];
    }

    WGContactGroup *group = contactDic[contact.group];
    if (group)
    {
        [group.contacts addObject:contact];
        [group.contacts sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            WGContact *c1 = (WGContact *)obj1;
            WGContact *c2 = (WGContact *)obj2;
            
            return [c1.name compare:c2.name options:NSCaseInsensitiveSearch];
        }];
    }
    else
    {
        group = [[WGContactGroup alloc] initWithName:contact.group andDetail:[NSString stringWithFormat:@"Name start with %@.",contact.group]];
        [group.contacts addObject:contact];
    }
    
    [contactDic setObject:group forKey:contact.group];

    return [self saveContactsDataToLocale:contactDic];
}

+ (BOOL)saveContactsDataToLocale:(NSMutableDictionary *)dic
{
    NSMutableData *cData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:cData];
    [archiver encodeObject:dic forKey:KEY_ARCHIVER];
    [archiver finishEncoding];
    
    BOOL isSuccess = [cData writeToFile:[self getContactsPath] atomically:YES];
    return isSuccess;
}

+ (NSMutableDictionary *)getContactsDataFromLocal
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self getContactsPath]];
    NSMutableDictionary *contactsDic = nil;
    
    if (data)
    {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        contactsDic = [unArchiver decodeObjectForKey:KEY_ARCHIVER];
        [unArchiver finishDecoding];
    }
    
    return contactsDic;
}

// 遍历所有属性

- (NSArray *)getNonullProperties:(BOOL)isNil
{
    NSArray *names = [self getProperties:[self class]];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:names.count];
    if (isNil)
    {
        for (NSString *name in names)
        {
            if ([self valueForKey:name])
            {
                [result addObject:name];
            }
        }
        
        return result.copy;
    }
    else
    {
        return names;
    }
}

- (NSArray *)getProperties:(Class)class
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i ++)
    {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
}





@end

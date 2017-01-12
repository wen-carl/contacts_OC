//
//  WGContactsView.m
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGContactsView.h"

#define SEARCHBAR_HEIGHT     50.0f





@interface WGContactsView ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSMutableArray <NSString *>*_indexArray;
    UISearchBar *_searchBar;
    BOOL _isSearching;
    NSMutableArray <WGContact *>*_resultArray;
}

@end

@implementation WGContactsView

- (void)initData
{
    NSArray *arr = [NSArray arrayWithObjects:@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0", nil];
    int count = arc4random() % 5 + 5;
    NSMutableDictionary *allContact = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i ++)
    {
        int a = arc4random() % 36;
        NSString *str1 = arr[a];
        NSMutableArray *contacts = [NSMutableArray array];
        for (int j = 0; j < arc4random() % 10 + 2; j ++)
        {
            NSString *name = str1;
            for (int x = 0; x < 3; x ++)
            {
                int b = arc4random() % 36;
                NSString *sss = arr[b];
                name = [name stringByAppendingString:sss];
            }
            
            WGContact *contact = [WGContact contactWithName:name];
            NSArray *arr = contact.phoneNum[@"index"];
            [contact.phoneNum setObject:[self getPhoneNumber] forKey:arr[0]];
            [contact.phoneNum setObject:[self getPhoneNumber] forKey:arr[1]];
            [contact.phoneNum setObject:[self getPhoneNumber] forKey:arr[2]];
            
            NSArray *arr1 = contact.email[@"index"];
            [contact.email setObject:@"wen_carl@163.com" forKey:arr1[0]];
            [contact.email setObject:@"1755039122@qq.com" forKey:arr1[1]];
            
            contact.address = @"xian";
            contact.birthday = @"2017.01.01";
            [contacts addObject:contact];
        }
        
        WGContactGroup *group = [WGContactGroup contactGroupWithName:str1 andDetail:[NSString stringWithFormat:@"Name start with %@",str1]];
        group.contacts = contacts;
        
        [allContact setObject:group forKey:group.name];
    }
    
    [WGContact saveContactsDataToLocale:allContact];
}

- (NSString *)getPhoneNumber
{
    NSArray *arr = @[@"3",@"5",@"7",@"8"];
    int a = arc4random()%4;
    NSString *number = @"";
    for (int i = 0; i < 9; i ++)
    {
        int b = arc4random()%10;
        number = [number stringByAppendingString:[NSString stringWithFormat:@"%d",b]];
    }
    NSString *phoneNumber = [NSString stringWithFormat:@"1%@%@",arr[a],number];
    return phoneNumber;
}

- (void)setUpData
{
    _allContacts = [WGContact getContactsDataFromLocal];
    
    if (_allContacts)
    {
        _indexArray = (NSMutableArray *)[_allContacts.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *str1 = obj1;
            NSString *str2 = obj2;
            
            return [str1 compare:str2 options:NSCaseInsensitiveSearch];
        }];
    }
    else
    {
        [self initData];
        [self setUpData];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpData];
        [self addSubviews];
    }
    
    return self;
}

- (void)addSubviews
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, SEARCHBAR_HEIGHT)];
    _searchBar.delegate = self;
    _isSearching = NO;
    [self addSubview:_searchBar];
    
    CGRect rect = CGRectMake(0, SEARCHBAR_HEIGHT, self.frame.size.width, self.frame.size.height - SEARCHBAR_HEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger c = 0;
    if (_isSearching)
    {
        c = 1;
    }
    else
    {
        c = _allContacts.count;
    }
    
    return c;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger c = 0;
    if (_isSearching)
    {
        c = _resultArray.count;
    }
    else
    {
        WGContactGroup *group = _allContacts[_indexArray[section]];
        c = group.contacts.count;
    }
    
    return c;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSString *header = nil;
    if (!_isSearching)
    {
        header = _indexArray[section];
    }
    return header;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
    //WGContactGroup *group = _allContacts[_indexArray[section]];
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"contact_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        CGRect rect = cell.imageView.frame;
        rect.size = CGSizeMake(cell.frame.size.height - 10, cell.frame.size.height - 10);
        rect.origin.y = 5;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = cell.frame.size.height / 2 - 5;
    }
    
    WGContact *contact = nil;
    if (_isSearching)
    {
        contact = _resultArray[indexPath.row];
    }
    else
    {
        WGContactGroup *group = _allContacts[_indexArray[indexPath.section]];
        contact = group.contacts[indexPath.row];
    }
    cell.textLabel.text = contact.name;
    cell.imageView.image = contact.image;
    CGRect rect = cell.imageView.frame;
    rect.size = CGSizeMake(cell.frame.size.height - 10, cell.frame.size.height - 10);
    rect.origin.y = 5;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = cell.frame.size.height / 2 - 5;
    
    return cell;
}

#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return _isSearching ? 0.000000001 : 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.00000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WGContact *contact = nil;
    if (_isSearching)
    {
        contact = _resultArray[indexPath.row];
        _isSearching = NO;
        [_searchBar resignFirstResponder];
        [tableView reloadData];
    }
    else
    {
        WGContactGroup *group = _allContacts[_indexArray[indexPath.section]];
        contact = group.contacts[indexPath.row];
    }
    
    if ([_delegate respondsToSelector:@selector(contactsView:didSelectContact:andIndex:)])
    {
        [_delegate contactsView:self didSelectContact:contact andIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _isSearching ? nil : _indexArray;
}

#pragma mark SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _resultArray = nil;
    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    _isSearching = NO;
    [_tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText  isEqual: @""])
    {
        _isSearching = NO;
    }
    else
    {
        _isSearching = YES;
        _resultArray = [self searchResultWithKeyWord:searchText];
    }
    [_tableView reloadData];
}

- (NSMutableArray *)searchResultWithKeyWord:(NSString *)keyWord
{
    NSMutableSet *resultSet = [NSMutableSet set];
    [_allContacts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        WGContactGroup *group = obj;
        [group.contacts enumerateObjectsUsingBlock:^(WGContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WGContact *contact = obj;
            if ([contact.name.uppercaseString containsString:keyWord] || [contact.address containsString:keyWord] || [contact.birthday containsString:keyWord])
            {
                [resultSet addObject:contact];
            }
            
            [contact.phoneNum enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]])
                {
                    NSString *phoneNum = obj;
                    if ([phoneNum containsString:keyWord])
                    {
                        [resultSet addObject:contact];
                    }
                }
            }];
            
            [contact.email enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]])
                {
                    NSString *email = obj;
                    if ([email containsString:keyWord])
                    {
                        [resultSet addObject:contact];
                    }
                }
            }];
        }];
    }];
    
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    NSArray *arr = [resultSet sortedArrayUsingDescriptors:sortDesc];
    
    return [NSMutableArray arrayWithArray:arr];
}





@end

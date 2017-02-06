//
//  WGContactDetailView.m
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGContactDetailView.h"

@interface WGContactDetailView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, WGHeaderViewDelegate, WGTableHeaderViewDelegate, WGTableViewCellDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView *_tableView;
    WGHeaderView *_headerView;
    WGTableHeaderView *tableHeader;
    UITextField *_textField;
    UIToolbar *footerView;
    NSArray <NSDictionary *>*_cityArr;
}

@end

@implementation WGContactDetailView


- (instancetype)initWithFrame:(CGRect)frame andContact:(WGContact *)contact
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _showInfo = YES;
        _contact = contact;
        
        if (_contact)
        {
            _isEditting = NO;
        }
        else
        {
            _isEditting = YES;
            _contact = [WGContact contactWithName:nil];
        }

        [self initSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)initSubViews
{
    _headerView = [[WGHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 160)];
    _headerView.delegate = self;
    _headerView.nameTf.delegate = self;
    _headerView.contact = _contact;
    _headerView.isEditting = _isEditting;
    [self addSubview:_headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, self.frame.size.width, self.frame.size.height - 260) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    tableHeader = [[WGTableHeaderView alloc] initWithFrame:CGRectMake(0, 160, self.frame.size.width, 50)];
    tableHeader.hidden = _isEditting;
    tableHeader.delegate = self;
    [self addSubview:tableHeader];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
    footer.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:footer];
}

#pragma mark WGTableHeaderView Delegate

- (void)tableHeaderView:(WGTableHeaderView *)headerView didChangedShowInfo:(BOOL)showInfo
{
    _showInfo = showInfo;
    [_tableView reloadData];
    
    if ([_delegate respondsToSelector:@selector(contactDetailView:didChangesShowInfo:)])
    {
        [_delegate contactDetailView:self didChangesShowInfo:showInfo];
    }
}

#pragma mark WGHeaderView Delegate

- (void)imagePickerWillBePresented:(UIImagePickerController *)picker
{
    if ([_delegate isKindOfClass:[UIViewController class]])
    {
        [(UIViewController *)_delegate presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIView *next = self.superview;
        UIResponder *nextResponder = nil;
        do {
            next = next.superview;
            nextResponder = next.nextResponder;
        } while (![nextResponder isKindOfClass:[UIViewController class]]);
        
        [(UIViewController *)nextResponder presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePicker:(UIImagePickerController *)picker DidFinishPicking:(UIImage *)image
{
    _contact.image = image;
}

#pragma mark BeginOrEndEditting

- (void)willbeginEditting
{
    _isEditting = YES;
    _headerView.isEditting = YES;
    tableHeader.hidden = YES;
    CGRect rect = _tableView.frame;
    rect.origin.y -= 50;
    rect.size.height += 50;
    _tableView.frame = rect;
    [_tableView reloadData];
}

- (BOOL)didEndEditting
{
    if (_textField)
    {
        [_textField resignFirstResponder];
    }
    
    if (_contact.name != nil && ![_contact.name isEqualToString:@""])
    {
        _isEditting = NO;
        _headerView.isEditting = NO;
        tableHeader.hidden = NO;
        CGRect rect = _tableView.frame;
        rect.origin.y += 50;
        rect.size.height -= 50;
        _tableView.frame = rect;
        [_tableView reloadData];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"A contact need a name at least." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        
        [(UIViewController *)_delegate presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }

    return !_isEditting;
}

#pragma mark WGTableViewCell Delegate

- (void)tableViewCell:(WGTableViewCell *)cell didChangesData:(BOOL)isAdd
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSArray *indexArr = @[@"phoneNum",@"email"];
    NSString *key = indexArr[indexPath.section];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[_contact valueForKey:key]];
    if (isAdd)
    {
        if (dataDic.count < 4)
        {
            NSString *numKey = ((NSArray *)(dataDic[@"index"]))[indexPath.row + 1];
            [dataDic setObject:@"" forKey:numKey];
        }
    }
    else
    {
        if (dataDic.count > 2)
        {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:dataDic[@"index"]];
            NSString *numKey = arr[indexPath.row];
            [arr removeObject:numKey];
            [arr addObject:numKey];
            [dataDic setObject:arr forKey:@"index"];
            [dataDic removeObjectForKey:numKey];
        }
    }
    [_contact setValue:dataDic forKey:key];
    
    [_tableView reloadData];
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_showInfo)
    {
        return ([_contact getNonullProperties:NO].count - 3);
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (_showInfo)
    {
        switch (section)
        {
            case 0:
                number = MIN(3, (_contact.phoneNum.count - 1));
                break;
                
            case 1:
                number = MIN(3, (_contact.email.count - 1));
                break;
                
            default:
                number = 1;
                break;
        }
    }
    else
    {
        number = 10;
    }
    
    return number;
}

- (WGTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WGTableViewCell *cell = nil;
    
    if (!_showInfo)
    {
        NSString *identifier = @"history";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[WGTableViewCell alloc] initWithStyle:WGTableViewCellStyleDefalt reuseIdentifier:identifier];
            cell.delegate = self;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoTextField.text = _contact.phoneNum[@"phoneNum1"];
        return cell;
    }
    
    NSArray * array = @[@"phoneNum",@"email",@"address",@"birthday",@"other"];
    id data = [_contact valueForKey:array[indexPath.section]];
    if (indexPath.section < 2)
    {
        NSDictionary *dic = (NSDictionary *)data;
        if ((indexPath.row == dic.count - 2 && indexPath.row != 2) || dic.count == 1)
        {
            NSString *identifier = @"add+";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WGTableViewCell alloc] initWithStyle:WGTableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.delegate = self;
            }
        }
        else
        {
            NSString *identifier = @"delete-";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[WGTableViewCell alloc] initWithStyle:WGTableViewCellStyleValue2 reuseIdentifier:identifier];
                cell.delegate = self;
            }
        }
        NSArray *arr = dic[@"index"];
        cell.kindTextfield.text = [arr[indexPath.row] stringByAppendingString:@" :"];
        cell.infoTextField.text = dic[arr[indexPath.row]];
    }
    else
    {
        NSString *str = (NSString *)data;
        NSString *identifier = @"default";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[WGTableViewCell alloc] initWithStyle:WGTableViewCellStyleDefalt reuseIdentifier:identifier];
        }
        cell.infoTextField.text = str;
        cell.kindTextfield.text = [array[indexPath.section] stringByAppendingString:@" :"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoTextField.delegate = self;
    cell.isEditting = _isEditting;
    
    return cell;
}

#pragma mark Tableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10;
    switch (section)
    {
        case 0:
            height = 0.0000000001;
            break;
            
        case 1:
            break;
            
        default:
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _textField = textField;
    
    if ([textField.superview isKindOfClass:[WGHeaderView class]])
        return;
    
    UIView *superview = textField.superview;
    while (![superview isKindOfClass:[WGTableViewCell class]])
    {
        superview = superview.superview;
    }
    
    WGTableViewCell *cell = (WGTableViewCell *)superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    switch (indexPath.section)
    {
        case 0:
            textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 1:
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
            
        case 2:
        {
            if (!_cityArr)
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
                NSDictionary *address = [NSDictionary dictionaryWithContentsOfFile:path];
                _cityArr = [[NSArray alloc] initWithArray:address[@"address"]];
            }
            
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.delegate = self;
            picker.dataSource = self;
            _textField.inputView = picker;
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, 50, 30);
            [button setTitle:@"Done" forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor blueColor].CGColor;
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(onGetAddress:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *bar1 = [[UIBarButtonItem alloc] initWithCustomView:button];
            UIBarButtonItem *bar2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            toolbar.items = @[bar2,bar1];
            _textField.inputAccessoryView = toolbar;
        }
            break;
            
        case 3:
        {
            UIDatePicker *picker = [[UIDatePicker alloc] init];
            picker.datePickerMode = UIDatePickerModeDate;
            picker.maximumDate = [NSDate date];
            _textField.inputView = picker;
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 0, 50, 30);
            [button setTitle:@"Done" forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor blueColor].CGColor;
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(onGetDate:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *bar1 = [[UIBarButtonItem alloc] initWithCustomView:button];
            UIBarButtonItem *bar2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            toolbar.items = @[bar2,bar1];
            _textField.inputAccessoryView = toolbar;
        }
            break;
            
        default:
            textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.superview isKindOfClass:[WGHeaderView class]])
    {
        _contact.name = textField.text;
    }
    else
    {
        UIView *superview = textField.superview;
        while (![superview isKindOfClass:[WGTableViewCell class]])
        {
            superview = superview.superview;
        }
        WGTableViewCell *cell = (WGTableViewCell *)superview;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        NSString *valueStr = textField.text;
        switch (indexPath.section)
        {
            case 0:
            case 1:
            {
                NSMutableDictionary *dic = indexPath.section == 0 ? _contact.phoneNum : _contact.email;
                
                if (textField.tag == TAG_KINDTF)
                {
                    [dic[@"index"] replaceObjectAtIndex:indexPath.row withObject:valueStr];
                }
                else if (textField.tag == TAG_INFOTF)
                {
                    if (![self validateStringValue:valueStr section:indexPath.section])
                    {
                        textField.textColor = [UIColor redColor];
                    }
                    else
                    {
                        textField.textColor = [UIColor blackColor];
                    }
                }
                
                NSString *key = dic[@"index"][indexPath.row];
                [dic setObject:valueStr forKey:key];
                indexPath.section == 0 ? [_contact setPhoneNum:dic] : [_contact setEmail:dic];
            }
                break;
                
            case 2:
            {
                _contact.address = valueStr;
            }
                break;
                
            case 3:
            {
                _contact.birthday = valueStr;
            }
                break;
                
            default:
                break;
        }
    }
    
    _textField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)validateStringValue:(NSString *)string section:(NSUInteger)section
{
    BOOL success = NO;
    if (section == 0)
    {
        NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        success = [phoneTest evaluateWithObject:string];
    }
    else if (section == 1)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        success = [emailTest evaluateWithObject:string];
    }
    
    return success;
}

#pragma mark UIKeyboardNotification Methods

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    float keyBoardHeight = [value CGRectValue].size.height;
    CGRect rect = _tableView.frame;
    rect.size.height = self.frame.size.height - 160 - keyBoardHeight;
    _tableView.frame = rect;
}

- (void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect rect = _tableView.frame;
    rect.size.height = self.frame.size.height - 210;
    _tableView.frame = rect;
}

#pragma mark UIPickeView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    
    for (; count <= 0; )
    {
        count = _cityArr.count;
        
        if (component == 0)
            break;
        
        NSInteger first = [pickerView selectedRowInComponent:0];
        NSDictionary *dic1 = _cityArr[first];
        NSArray *arr1 = dic1[@"sub"];
        count = arr1.count;
        
        if (component == 1)
            break;
        
        NSInteger second = [pickerView selectedRowInComponent:1];
        NSDictionary *dic2 = arr1[second];
        NSArray *arr2 = dic2[@"sub"];
        count = arr2.count;
        
        if (component == 2)
            break;
    }
    
    return count;
}

#pragma mark UIPickerView Delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSArray *array = nil;
    switch (component)
    {
        case 0:
        {
            array = @[[NSNumber numberWithInteger:row]];
        }
            break;
            
        case 1:
        {
            NSInteger first = [pickerView selectedRowInComponent:0];
            array = @[[NSNumber numberWithInteger:first],[NSNumber numberWithInteger:row]];
        }
            break;
            
        case 2:
        {
            NSInteger first = [pickerView selectedRowInComponent:0];
            NSInteger second = [pickerView selectedRowInComponent:1];
            array = @[[NSNumber numberWithInteger:first],[NSNumber numberWithInteger:second],[NSNumber numberWithInteger:row]];
        }
            break;
            
        default:
            break;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = [self getNameWithArray:array andAddress:NO];
    
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
            
        case 1:
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
            
        case 2:
            break;
            
        default:
            break;
    }
}

- (NSString *)getNameWithArray:(NSArray <NSNumber *>*)array andAddress:(BOOL)flag
{
    if (!array || array.count == 0)
        return nil;
    
    NSString *nameStr = nil;
    
    if (flag)
    {
        NSInteger provinceIndex = [array[0] integerValue];
        NSInteger cityIndex = [array[1] integerValue];
        NSInteger regionIndex = [array[2] integerValue];
        
        NSDictionary *dic1 = _cityArr[provinceIndex];
        NSString *province = dic1[@"name"];
        
        NSArray *arr1 = dic1[@"sub"];
        NSDictionary *dic2 = arr1[cityIndex];
        NSString *city = dic2[@"name"];
        
        NSArray *arr2 = dic2[@"sub"];
        NSString *region = arr2[regionIndex];
        nameStr = [NSString stringWithFormat:@"%@ | %@ | %@",province,city,region];
    }
    else
    {
        for (; YES; )
        {
            NSDictionary *dic1 = _cityArr[[array[0] integerValue]];
            nameStr = dic1[@"name"];
            if (array.count == 1)
                break;
            
            NSArray *arr1 = dic1[@"sub"];
            NSDictionary *dic2 = arr1[[array[1] integerValue]];
            nameStr = dic2[@"name"];
            
            if (array.count == 2)
                break;
            
            NSArray *arr2 = dic2[@"sub"];
            nameStr = arr2[[array[2] integerValue]];
            
            if (array.count == 3)
                break;
        }
    }
    
    return nameStr;
}

#pragma mark KeyboardAccessoryView

- (void)onGetAddress:(UIButton *)button
{
    UIPickerView *picker = (UIPickerView *)_textField.inputView;
    NSInteger province = [picker selectedRowInComponent:0];
    NSInteger city = [picker selectedRowInComponent:1];
    NSInteger region = [picker selectedRowInComponent:2];
    _textField.text = [self getNameWithArray:@[[NSNumber numberWithInteger:province],[NSNumber numberWithInteger:city],[NSNumber numberWithInteger:region]] andAddress:YES];
    [_textField resignFirstResponder];
}

- (void)onGetDate:(UIButton *)button
{
    UIDatePicker *picker = (UIDatePicker *)_textField.inputView;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy | MM | dd"];
    _textField.text = [formatter stringFromDate:picker.date];
    [_textField resignFirstResponder];
}

#pragma mark Memory Management

- (void)dealloc
{
    WGNSLog(@"dealloc.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


@end

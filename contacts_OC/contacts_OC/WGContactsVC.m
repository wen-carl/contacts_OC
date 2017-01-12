//
//  WGContactsVC.m
//  Contacts
//
//  Created by Admin on 17/1/3.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGContactsVC.h"

@interface WGContactsVC ()<WGContactsViewDelegate>
{
    WGContactsView *contactsView;
}

@end

@implementation WGContactsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Contacts";
    
    CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat originY = statusFrame.size.height + navBarFrame.size.height;
    CGRect rect = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
    
    contactsView = [[WGContactsView alloc] initWithFrame:rect];
    contactsView.delegate = self;
    [self.view addSubview:contactsView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddContact:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"WGContactDidFinishEditting" object:nil];
}

- (void)onAddContact:(UIBarButtonItem *)bar
{
    WGContactDetailVC *addContact = [[WGContactDetailVC alloc] init];
    [self.navigationController pushViewController:addContact animated:YES];
}

- (void)refreshData
{
    [contactsView setUpData];
    [contactsView.tableView reloadData];
}

#pragma mark WGContactsView Delegate

- (void)contactsView:(WGContactsView *)contactsView didSelectContact:(WGContact *)contact andIndex:(NSInteger)index
{
    WGContactDetailVC *contactDetailVC = [[WGContactDetailVC alloc] init];
    contactDetailVC.contact = contact;
    contactDetailVC.index = index;
    [self.navigationController pushViewController:contactDetailVC animated:YES];
}







- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WGContactDidFinishEditting" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

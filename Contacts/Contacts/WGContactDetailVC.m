//
//  WGContactDetailVC.m
//  Contacts
//
//  Created by Admin on 17/1/4.
//  Copyright © 2017年 Wind. All rights reserved.
//

#import "WGContactDetailVC.h"

@interface WGContactDetailVC ()<WGContactDetailViewDelegate>
{
    WGContactDetailView *detailView;
}

@end

@implementation WGContactDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _contact ? _contact.name : @"Add New Contact";
    
    CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGFloat originY = statusFrame.size.height + navBarFrame.size.height;
    CGRect rect = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);

    detailView = [[WGContactDetailView alloc] initWithFrame:rect andContact:_contact];
    detailView.delegate = self;
    [self.view addSubview:detailView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:(_contact ? @"Edit" : @"Save") style:UIBarButtonItemStyleDone target:self action:@selector(onEditOrDone:)];
}

- (void)onEditOrDone:(UIBarButtonItem *)bar
{
    WGNSLog(@"zzzzzzzzzzzz");
    if ([bar.title isEqualToString:@"Edit"])
    {
        bar.title = @"Done";
        [detailView willbeginEditting];
    }
    else if ([bar.title isEqualToString:@"Done"] || [bar.title isEqualToString:@"Save"])
    {
        BOOL end = [detailView didEndEditting];
        if (end)
        {
            [WGContact saveContact:detailView.contact beReplaced:_contact andIndex:_index];
            bar.title = @"Edit";
            self.title = detailView.contact.name;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WGContactDidFinishEditting" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark WGContactDetailView Delegate

- (void)contactDetailView:(WGContactDetailView *)detailView didChangesShowInfo:(BOOL)showInfo
{
    if (showInfo)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(onEditOrDone:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

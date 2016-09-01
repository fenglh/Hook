//
//  AnimationsListViewController.m
//  Popping
//
//  Created by André Schneider on 10.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "AnimationsListViewController.h"
#import "MenuTableViewCell.h"
#import "LCZoomTransition.h"
#import "UIColor+CustomColors.h"
#import "AvoidRevokeViewController.h"
#import "RedPacketTableViewController.h"
#import "OneKeyRecordTableViewController.h"
#import "ITXAboutViewController.h"
#import "FingerPrintAuthViewController.h"


@interface AnimationsListViewController()
@property (nonatomic, strong) LCZoomTransition *zoomTransition;
@property(nonatomic) NSArray *items;

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIViewController *)viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureTableView;
- (void)configureTitleView;
@end

@implementation AnimationsListViewController

- (void)dealloc
{
    self.navigationController.delegate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"iOS逆向";
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]]; 
    [self configureTableView];
    [self configureTitleView];
}

- (void)viewDidAppear:(BOOL)animated
{
        self.zoomTransition = [[LCZoomTransition alloc] initWithNavigationController:self.navigationController];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self viewControllerForRowAtIndexPath:indexPath];
    viewController.title = [self titleForRowAtIndexPath:indexPath];
    self.zoomTransition.sourceView = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self.items[indexPath.row] firstObject];
    return cell;
}

#pragma mark - Private Instance methods

- (void)configureTableView
{
    self.items = @[
                   @[@"防撤销", [AvoidRevokeViewController class]],
                   @[@"指纹锁定", [FingerPrintAuthViewController class]],
                   @[@"自动抢红包", [RedPacketTableViewController class]],
                   @[@"一键录音", [OneKeyRecordTableViewController class]],
                   @[@"关于", [ITXAboutViewController class]],
                   ];
    [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44.f;
}

- (void)configureTitleView
{
    UILabel *headlinelabel = [UILabel new];
    headlinelabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    headlinelabel.textAlignment = NSTextAlignmentCenter;
    headlinelabel.textColor = [UIColor customGrayColor];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor customBlueColor]
                             range:NSMakeRange(1, 1)];

    headlinelabel.attributedText = attributedString;
    [headlinelabel sizeToFit];

    [self.navigationItem setTitleView:headlinelabel];
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items[indexPath.row] firstObject];
}

- (UIViewController *)viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.items[indexPath.row] lastObject] new];
}

@end

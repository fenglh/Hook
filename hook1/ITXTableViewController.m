//
//  AvoidRevokeViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "ITXTableViewController.h"


@interface ITXTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end


@implementation ITXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [[SpreadButtonManager sharedInstance] openAvoidRevoke:![SpreadButtonManager sharedInstance].avoidRevoke];
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
//    if ([SpreadButtonManager sharedInstance].avoidRevoke) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    cell.textLabel.text = self.items[indexPath.row];
//    return cell;
//}



- (void)addTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}


@end

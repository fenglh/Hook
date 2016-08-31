//
//  AvoidRevokeViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "AvoidRevokeViewController.h"
#import "MenuTableViewCell.h"
#import "SpreadButtonManager.h"

@interface AvoidRevokeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation AvoidRevokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"防撤销"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SpreadButtonManager sharedInstance] openAvoidRevoke:![SpreadButtonManager sharedInstance].avoidRevoke];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([SpreadButtonManager sharedInstance].avoidRevoke) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

@end

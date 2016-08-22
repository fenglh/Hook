//
//  RedPacketTableViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "RedPacketTableViewController.h"
#import "MenuTableViewCell.h"
#import "SpreadButtonManager.h"

@interface RedPacketTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RedPacketTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"关闭抢红包",
                   @"打开抢红包",
                   @"不抢自己红包",
                   @"不抢自己群红包"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    RedEnvPluginType oldType = [SpreadButtonManager sharedInstance].redEnvPluginType ;
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldType inSection:0];
    [[SpreadButtonManager sharedInstance] openRedEnvPlugin:indexPath.row];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([SpreadButtonManager sharedInstance].redEnvPluginType == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}


@end

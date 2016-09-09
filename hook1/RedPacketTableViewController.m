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
@property (nonatomic, strong) NSArray *delayItems;
@end

@implementation RedPacketTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"关闭抢红包",
                   @"打开抢红包",
                   @"不抢自己红包",
                   @"不抢自己群红包"];
    self.delayItems = @[
                        @"100毫秒",
                        @"300毫秒",
                        @"500毫秒",
                        @"1000毫秒内随机",
                        @"I dont't care",];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return @"红包抢太快会被微信弹出警告，可以适当设置延时时间！";
    }
    return nil;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"开关";
    }else if (section == 1){
        return @"延时";
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.items count];
    }else if(section ==1){
        return [self.delayItems count];
    }else{
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RedEnvPluginType oldType = [SpreadButtonManager sharedInstance].redEnvPluginType ;
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldType inSection:0];
        [[SpreadButtonManager sharedInstance] openRedEnvPlugin:indexPath.row];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
    }

    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([SpreadButtonManager sharedInstance].redEnvPluginType == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.items[indexPath.row];
    }else{
        cell.textLabel.text = self.delayItems[indexPath.row];
    }
    
    return cell;
}


@end

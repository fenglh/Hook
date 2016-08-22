//
//  OneKeyRecordTableViewController.m
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "OneKeyRecordTableViewController.h"
#import "MenuTableViewCell.h"
@interface OneKeyRecordTableViewController ()

@end

@implementation OneKeyRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[@"一键录音"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SpreadButtonManager sharedInstance] openOneKeyRecord:![SpreadButtonManager sharedInstance].oneKeyRecord];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([SpreadButtonManager sharedInstance].oneKeyRecord) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}




@end

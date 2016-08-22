//
//  ITXTableViewController.h
//  hook1
//
//  Created by 冯立海 on 16/8/16.
//
//

#import "ITXBaseViewController.h"
#import "MenuTableViewCell.h"
#import "SpreadButtonManager.h"

static NSString * const kCellIdentifier = @"cellIdentifier";
@interface ITXTableViewController : ITXBaseViewController
@property(nonatomic) NSArray *items;
@end

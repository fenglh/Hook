//
//  ViewController.m
//  Hook
//
//  Created by 冯立海 on 16/8/12.
//
//

#import "ViewController.h"
#import "SpreadButtonManager.h"
#import <pop/POP.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.button setBackgroundColor:[UIColor redColor]];
//    [self.button setTitle:@"点击我" forState:UIControlStateNormal];
//    self.button.frame = CGRectMake(10, 100, 160, 44);
//    [self.view addSubview:self.button];
//    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;

}

- (void)buttonClick:(UIButton *)button
{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 400) ];
    [button.layer pop_addAnimation:anim forKey:@"buttonAnim"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

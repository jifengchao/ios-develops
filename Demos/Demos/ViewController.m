//
//  ViewController.m
//  Demos
//
//  Created by hyl on 2022/8/2.
//

#import "ViewController.h"

#import "DemoLabelsViewController.h"
#import "DemoIMAccountsViewController.h"
#import "DemoNumberScrollViewController.h"
#import "DemoUIViewListViewController.h"
#import "DemoYYLabelViewController.h"
#import "DemoXialaActivityIndicatorViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *demoTableView;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Demo示例指引";
    self.demoTableView.delegate = self;
    self.demoTableView.dataSource = self;
    
    self.datas = @[].mutableCopy;
    
    [self.datas addObject:@"多标签动态宽度计算显示【支持方向】"];
    [self.datas addObject:@"网易云信IM【聊天室】"];
    [self.datas addObject:@"滚动数字"];
    [self.datas addObject:@"UIView小功能"];
    [self.datas addObject:@"YYLabel简单使用"];
    [self.datas addObject:@"下拉头部方法+指示器转动"];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.textLabel.text = self.datas[indexPath.row];
    cell.textLabel.numberOfLines = 2;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        DemoLabelsViewController *vc = [DemoLabelsViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
    if (row == 1) {
        DemoIMAccountsViewController *vc = [DemoIMAccountsViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
    if (row == 2) {
        DemoNumberScrollViewController *vc = [DemoNumberScrollViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
    if (row == 3) {
        DemoUIViewListViewController *vc = [DemoUIViewListViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
    if (row == 4) {
        DemoYYLabelViewController *vc = [DemoYYLabelViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
    if (row == 5) {
        DemoXialaActivityIndicatorViewController *vc = [DemoXialaActivityIndicatorViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

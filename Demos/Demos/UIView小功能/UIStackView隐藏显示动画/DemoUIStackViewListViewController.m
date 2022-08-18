//
//  DemoUIStackViewListViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoUIStackViewListViewController.h"

#import "DemoUIStackView01ViewController.h"
#import "DemoUIStackView02ViewController.h"

@interface DemoUIStackViewListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *demoTableView;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation DemoUIStackViewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"UIStackView隐藏显示动画";
    
    [self setupUI];
    
    self.demoTableView.delegate = self;
    self.demoTableView.dataSource = self;
    
    self.datas = @[].mutableCopy;
    
    [self.datas addObject:@"布局在普通视图上"];
    [self.datas addObject:@"布局在TableView上"];

}

- (void)setupUI {
    UITableView *demoTableView = [[UITableView alloc] init];
    [self.view addSubview:demoTableView];
    self.demoTableView = demoTableView;
    [demoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
        DemoUIStackView01ViewController *vc = [DemoUIStackView01ViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
    if (row == 1) {
        DemoUIStackView02ViewController *vc = [DemoUIStackView02ViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

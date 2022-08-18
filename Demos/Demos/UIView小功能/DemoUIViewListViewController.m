//
//  DemoUIViewListViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoUIViewListViewController.h"

#import "DemoUIViewCornersViewController.h"

@interface DemoUIViewListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *demoTableView;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation DemoUIViewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"UIView小功能";
    
    [self setupUI];
    
    self.demoTableView.delegate = self;
    self.demoTableView.dataSource = self;
    
    self.datas = @[].mutableCopy;
    
    [self.datas addObject:@"分类-四个角不同半径的切角"];
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
        DemoUIViewCornersViewController *vc = [DemoUIViewCornersViewController new];
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

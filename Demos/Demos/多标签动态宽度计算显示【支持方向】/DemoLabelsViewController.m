//
//  DemoLabelsViewController.m
//  Demos
//
//  Created by hyl on 2022/8/2.
//

#import "DemoLabelsViewController.h"

#import "LabelsTableViewCell.h"

@interface DemoLabelsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, weak) UITableView *demoTableView;

@end

@implementation DemoLabelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"多标签动态宽度计算显示【支持方向】";
    
    [self setupUI];
    self.datas = @[@0, @0, @0].mutableCopy;
}

- (void)setupUI {
    UITableView *demoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self.view addSubview:demoTableView];
    self.demoTableView = demoTableView;
    demoTableView.delegate = self;
    demoTableView.dataSource = self;
    [demoTableView registerClass:LabelsTableViewCell.class forCellReuseIdentifier:@"LabelsTableViewCellID"];
    [demoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *num = self.datas[indexPath.row];
    
    LabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelsTableViewCellID" forIndexPath:indexPath];
    cell.expand = num.boolValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSNumber *num = self.datas[indexPath.row];
    num = num.intValue == 0 ?@1 :@0;
    [self.datas replaceObjectAtIndex:indexPath.row withObject:num];
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

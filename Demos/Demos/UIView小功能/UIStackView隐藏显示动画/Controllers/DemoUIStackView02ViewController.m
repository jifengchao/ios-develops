//
//  DemoUIStackView02ViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoUIStackView02ViewController.h"

#import "DemoUIStackView01ViewController.h"
#import "FEMatchDetailIndexDataCell.h"

@interface DemoUIStackView02ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *demoTableView;

@property (nonatomic, strong) NSMutableArray<FEMatchDetailIndexDataModel *> *datas;

@end

@implementation DemoUIStackView02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"点击列表显示效果";
    
    [self setupUI];
    
    self.datas = @[].mutableCopy;

    FEMatchDetailIndexDataModel *data1 = [FEMatchDetailIndexDataModel new];
    data1.count = 4;
    [self.datas addObject:data1];
    FEMatchDetailIndexDataModel *data2 = [FEMatchDetailIndexDataModel new];
    data2.count = 6;
    [self.datas addObject:data2];
}

- (void)setupUI {
    UITableView *demoTableView = [[UITableView alloc] init];
    [self.view addSubview:demoTableView];
    self.demoTableView = demoTableView;
    [demoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.demoTableView.delegate = self;
    self.demoTableView.dataSource = self;
    [self.demoTableView registerClass:FEMatchDetailIndexDataCell.class forCellReuseIdentifier:[FEMatchDetailIndexDataCell cellIdentifier]];
    self.demoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FEMatchDetailIndexDataCell *cell = [tableView dequeueReusableCellWithIdentifier:[FEMatchDetailIndexDataCell cellIdentifier] forIndexPath:indexPath];
    
    FEMatchDetailIndexDataModel *data = self.datas[indexPath.row];
    
    cell.tabV = tableView;
    cell.dataModel = data;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

//
//  DemoXialaActivityIndicatorViewController.m
//  Demos
//
//  Created by hyl on 2022/8/18.
//

#import "DemoXialaActivityIndicatorViewController.h"
#import "FEActivityIndicatorView.h"

@interface DemoXialaActivityIndicatorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UIView       *tableHeaderView;
@property (strong,nonatomic) UIImageView  *imageView;
@property (nonatomic, weak) FEActivityIndicatorView *indicatorView;

@end

@implementation DemoXialaActivityIndicatorViewController

-(UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        CGRect frame = CGRectMake(0, 0, SCREENWIDTH, 218);
        _tableHeaderView=[[UIImageView alloc]initWithFrame:frame];
    }
    return _tableHeaderView;
}
 
- (UIImageView *)imageView {
    if (!_imageView) {
        CGRect frame = CGRectMake(0, 0, SCREENWIDTH, 218);
        _imageView=[[UIImageView alloc]initWithFrame:frame];
        _imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.clipsToBounds=YES;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(0, SCREENHEIGHT + 1000);
    
    self.imageView.image = [UIImage imageNamed:@"xiala_header_bg"];
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self.tableHeaderView addSubview:self.imageView];
    [self.scrollView addSubview:self.tableHeaderView];
    
    UIView *redV = [UIView new];
    redV.frame = CGRectMake(0, self.tableHeaderView.frame.size.height - 50, self.tableHeaderView.frame.size.width, 50);
    [self.tableHeaderView addSubview:redV];
    redV.backgroundColor = UIColor.redColor;

    UILabel *lab = UILabel.new;
    lab.frame = CGRectMake(0, 0, 100, 50);
    [redV addSubview:lab];
    lab.text = @"1122334455";
    lab.textColor = UIColor.blackColor;
    
    FEActivityIndicatorView *indicatorView = [[FEActivityIndicatorView alloc] init];
    indicatorView.frame = CGRectMake(120, 0, 44, 44);
    [redV addSubview:indicatorView];
    self.indicatorView = indicatorView;
    indicatorView.image = [UIImage imageNamed:@"xiala_loading"];
    indicatorView.hidesWhenStopped = NO;
    indicatorView.indicatorWH = 44;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetY = offset.y;
    if (offset.y < 0) { //下拉放大的效果 - 注意点
        CGRect rect = self.tableHeaderView.frame;
        rect.origin.y = offset.y;
        rect.size.height = CGRectGetHeight(rect) - offset.y;
        self.imageView.frame = rect;
        self.tableHeaderView.clipsToBounds=NO;
        
        // 100转一圈
        [self.indicatorView rotateWith:(-offsetY-100) * 1.5];
    }
}

/** 停止拖拽*/
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat targetY = 100;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= -targetY) { // 达到临界值 - 注意点
        [self.indicatorView startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

@end

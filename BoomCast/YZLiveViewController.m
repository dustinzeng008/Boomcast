//
//  YZLiveViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 11/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZLiveViewController.h"
#import "YZSearchViewController.h"
#import "YZMessageChannelsViewController.h"
#import "YZHomeNavigationMenu.h"
#import "YZHottestViewController.h"
#import "YZNewestViewController.h"
#import "YZFollowViewController.h"
#import "UIViewController+utils.h"

@interface YZLiveViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) YZHomeNavigationMenu *homeNavigationMenu;
@property(nonatomic, weak) UIScrollView *scrollView;
@end

@implementation YZLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messages"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clickMessageItem)];
    [self initViews];
}

- (void)clickSearchItem{
    YZSearchViewController *searchViewController = [[YZSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)clickMessageItem{
//    YZMessageChannelsViewController *messagesViewController = [[YZMessageChannelsViewController alloc] init];
//    [self.navigationController pushViewController:messagesViewController animated:YES];
    [self showAlertController:@"Coming soon! Thank you for your waiting."];
}

- (void) initViews{
    self.navigationController.navigationBar.translucent = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scrollView;
    _scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(KDeviceWidth * 3, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    YZHottestViewController *hottestVC = [[YZHottestViewController alloc] init];
    hottestVC.view.frame = CGRectMake(self.view.bounds.size.width*0, self.view.bounds.origin.y,
                                      self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:hottestVC];
    [scrollView addSubview:hottestVC.view];
    
    YZNewestViewController *newestVC = [[YZNewestViewController alloc] init];
    newestVC.view.frame = CGRectMake(self.view.bounds.size.width*1, self.view.bounds.origin.y,
                                     self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:newestVC];
    [scrollView addSubview:newestVC.view];
    
    YZFollowViewController *followVC = [[YZFollowViewController alloc] init];
    followVC.view.frame = CGRectMake(self.view.bounds.size.width*2, self.view.bounds.origin.y,
                                     self.view.bounds.size.width, self.view.bounds.size.height);
    [self addChildViewController:followVC];
    [scrollView addSubview:followVC.view];
    
    YZHomeNavigationMenu *homeNavigationMenu = [[YZHomeNavigationMenu alloc] initWithFrame:CGRectMake((KDeviceWidth - MENUITEMWIDTH * 3)/2, 7, MENUITEMWIDTH * 3, 30)];
    _homeNavigationMenu = homeNavigationMenu;
    [homeNavigationMenu setSelectedBlock:^(HomeNavigationMenuType type) {
        [self.scrollView setContentOffset:CGPointMake(type * KDeviceWidth, 0) animated:YES];
    }];
    self.navigationItem.titleView = homeNavigationMenu;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat page = scrollView.contentOffset.x / KDeviceWidth;
    CGFloat offsetX = scrollView.contentOffset.x / KDeviceWidth * (self.homeNavigationMenu.width * 0.5 - MENUITEMWIDTH * 0.5 );
    self.homeNavigationMenu.underLine.x = offsetX;
    if (page == 1 ) {
        self.homeNavigationMenu.underLine.x = offsetX ;
    }else if (page > 1){
        self.homeNavigationMenu.underLine.x = offsetX ;
    }
    self.homeNavigationMenu.selectedItemType = (int)(page + 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  YZSearchViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 11/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZSearchViewController.h"
#import <MBProgressHUD.h>
#import "YZSearchViewTableViewCell.h"
#import "YZUserInfoView.h"
@import Firebase;

@interface YZSearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userList;
@property(strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@end

@implementation YZSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // [START create_database_reference]
    self.databaseRef = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    // [END create_database_reference]
    
    [self setupLeftsearchBar];
    [self setupRightItem];
    [self initContentView];
}


#pragma mark ---- <setup searchbar>
- (void)setupLeftsearchBar {
    self.view.backgroundColor = [UIColor whiteColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KDeviceWidth - 100, 28)];
    _searchBar = searchBar;
    searchBar.placeholder = @"username";
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor mainColor];
    [searchBar becomeFirstResponder];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:searchButton];
}

#pragma mark ---- <setup navbar right item>
- (void)setupRightItem {
    //Right
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    //Font color
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [rightBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void) initContentView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.create reuseable cell
    static NSString *identifier = @"cell";
    
    YZSearchViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[YZSearchViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    User *user = [self.userList objectAtIndex:indexPath.row];
    if (user.profileImage == nil) {
        cell.imageView.image = [UIImage imageNamed:@"empty_profile"];
    } else {
        cell.imageView.image = user.profileImage;
    }
    cell.imageView.layer.cornerRadius = 22;
    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = user.username;
    cell.textLabel.textColor = [UIColor mainColor];
    cell.detailTextLabel.text = user.location;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    YZUserInfoView *userInfoView = [[YZUserInfoView alloc] initWithFrame:self.view.bounds];
    User *user = self.userList[indexPath.row];
    [userInfoView showInView:self.view withUser:user withCurrentUID:[User sharedInstance].uid animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _userList = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    FIRDatabaseQuery *query = [[self.databaseRef child:@"users"] queryOrderedByChild:@"username"];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for (int i = 0; i < snapshot.children.allObjects.count; i++) {
            FIRDataSnapshot *userItem = snapshot.children.allObjects[i];
            NSString *uid = userItem.key;
            if ([uid isEqualToString:[User sharedInstance].uid]) {
                continue;
            }
            NSString *username = userItem.value[@"username"];
            if ([username.lowercaseString containsString:[NSString trim:searchText].lowercaseString]) {
                User *user = [[User alloc] init];
                user.uid = uid;
                user.username = username;
                user.email = userItem.value[@"email"];
                user.location = userItem.value[@"location"];
                user.username = userItem.value[@"username"];
                
                [[[_databaseRef child:@"user_follow"] child:userItem.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    user.followNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
                }];
                
                [[[_databaseRef child:@"user_follower"] child:userItem.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    user.followerNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
                }];
                
                [[[self.databaseRef child:@"user-broadcasts"] child:user.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    user.broadcastNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
                }];
                
                [self.userList addObject:user];
                [self.tableView reloadData];
                
                NSString *profileImagePath = userItem.value[@"profileImagePath"];
                if (![profileImagePath isEqualToString:@""]) {
                    [[_storageRef child:profileImagePath] dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
                        if (error) {
                            YZLog(@"get profile image error---,%@", error.localizedDescription);
                            return;
                        }
                        user.profileImage = [UIImage imageWithData:data];
                        [self.tableView reloadData];
                    }];
                }
            }
            
        }
    }];
}

@end

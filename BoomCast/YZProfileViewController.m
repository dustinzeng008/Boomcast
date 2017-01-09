//
//  YZProfileViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 11/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZProfileViewController.h"
#import "YZProfileHeaderView.h"
#import "YZBaseSetting.h"
#import "YZProfileCell.h"
#import "YZSettingViewController.h"
#import <TSMessage.h>
#import <Photos/Photos.h>
#import <MBProgressHUD.h>

@import Firebase;
@import FirebaseAuth;
@import FirebaseStorage;

@interface YZProfileViewController ()<UITableViewDelegate, UITableViewDataSource,
    YZProfileHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) YZProfileHeaderView *profileHeaderView;
@property (nonatomic, strong)UITableView *tableView;

// YZBaseSettingGroupItem groups
@property (nonatomic, strong) NSMutableArray *groups;

@property(strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@end

@implementation YZProfileViewController

- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor backgroundColor];
    [TSMessage setDefaultViewController:self];
    // [START configurestorage]
    self.storageRef = [[FIRStorage storage] reference];
    self.databaseRef = [[FIRDatabase database] reference];
    // [END configurestorage]
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(setting)];
    self.navigationItem.rightBarButtonItem = setting;
    
    [self initViews];
}

- (void) initViews{
    YZProfileHeaderView *profileHeaderView = [[YZProfileHeaderView alloc] initWithFrame:CGRectMake(0, 64, KDeviceWidth, 160)];
    profileHeaderView.delegate = self;
    [self.view addSubview:profileHeaderView];
    _profileHeaderView = profileHeaderView;
    [profileHeaderView setUser:[User sharedInstance]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 224, KDeviceWidth, KDeviceHeight - 200) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    [self setUpGroup1];
    [self setUpGroup2];
}

- (void)setUpGroup1{
    YZBaseSettingArrowItem *clearCache = [YZBaseSettingArrowItem itemWithTitle:@"Clear cache" ];
    clearCache.option = ^{
        //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    };
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    YZBaseSettingArrowItem *about = [YZBaseSettingArrowItem itemWithTitle:[NSString stringWithFormat:@"App Version: %@",app_Version]];
    YZBaseSettingGroupItem *group = [[YZBaseSettingGroupItem alloc] init];
    group.items = @[clearCache,about];
    [self.groups addObject:group];
}

- (void)setUpGroup2{
    // Log out
    YZBaseSettingLabelItem *signOut = [[YZBaseSettingLabelItem alloc] init];
    signOut.text = @"Sign out";
    signOut.option = ^{
        [User sharedInstance].uid =  nil;
        [User sharedInstance].username = nil;
        [User sharedInstance].email = nil;
        [User sharedInstance].location = nil;
        [User sharedInstance].followNumber = nil;
        [User sharedInstance].followerNumber = nil;
        [User sharedInstance].broadcastNumber = nil;
        [User sharedInstance].profileImage = nil;
        
        NSError *signOutError;
        BOOL status = [[FIRAuth auth] signOut:&signOutError];
        if (!status) {
            [TSMessage showNotificationWithTitle:@"Error"
                                        subtitle:signOutError.localizedDescription
                                            type:TSMessageNotificationTypeError];
            return;
        }
    };
    
    YZBaseSettingGroupItem *group = [[YZBaseSettingGroupItem alloc] init];
    group.items = @[signOut];
    [self.groups addObject:group];
}

- (void)setting{
//    YZSettingViewController *settingViewController = [[YZSettingViewController alloc] init];
//    [self.navigationController pushViewController:settingViewController animated:YES];
}

#pragma Change Profile Image
- (void)changeProfileImage:(UIImageView *)profileImageView{
    YZLog(@"Change image...");
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self takePhoto];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Choose from Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self chooseFromPhotos];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.sourceView = profileImageView;
    popPresenter.sourceRect = profileImageView.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) chooseFromPhotos{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [User sharedInstance].profileImage = image;
    self.profileHeaderView.profileImage = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *imagePath =
    [NSString stringWithFormat:@"users/%@/profileImage.jpg", [FIRAuth auth].currentUser.uid];
    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
    metadata.contentType = @"image/jpeg";
    [[_storageRef child:imagePath] putData:imageData metadata:metadata
                                completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    if (error) {
                                        YZLog(@"Error uploading: %@", error);
                                        [TSMessage showNotificationWithTitle:@"Error"
                                                                    subtitle:error.localizedDescription
                                                                        type:TSMessageNotificationTypeError];
                                        return;
                                    }
                                    [self storeProfileImageInDB:imagePath];
                                }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)storeProfileImageInDB:(NSString *) profileImagePath{
    [[[_databaseRef child:@"users"] child:[FIRAuth auth].currentUser.uid]
     updateChildValues:@{@"profileImagePath": profileImagePath}];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YZBaseSettingGroupItem *group = self.groups[section];
    return group.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create cell
    YZProfileCell *cell = [YZProfileCell cellWithTableView:tableView];
    
    // Set model for cell
    YZBaseSettingGroupItem *group = self.groups[indexPath.section];
    YZBaseSettingItem *item = group.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get model
    YZBaseSettingGroupItem *groupItem = self.groups[indexPath.section];
    YZBaseSettingItem *item = groupItem.items[indexPath.row];
    
    if (item.option) {
        item.option();
        return;
    }
    
    
    if (item.destinationVC) {
        UIViewController *vc = [[item.destinationVC alloc] init];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    YZBaseSettingGroupItem *group = self.groups[section];
    return group.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    YZBaseSettingGroupItem *group = self.groups[section];
    return group.footerTitle;
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

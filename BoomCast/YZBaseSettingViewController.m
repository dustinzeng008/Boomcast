//
//  YZBaseSettingViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 11/27/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZBaseSettingViewController.h"
#import "YZBaseSettingGroupItem.h"
#import "YZBaseSettingItem.h"
#import "YZBaseSettingCell.h"

@interface YZBaseSettingViewController ()

@end

@implementation YZBaseSettingViewController

- (instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.backgroundColor = YZColor(211, 211, 211);
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    YZBaseSettingCell *cell = [YZBaseSettingCell cellWithTableView:tableView];
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

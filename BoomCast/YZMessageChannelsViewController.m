//
//  YZMessageChannelsViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 12/25/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZMessageChannelsViewController.h"
#import "YZMessageChannel.h"

@interface YZMessageChannelsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageChannelList;
@end

@implementation YZMessageChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageChannelList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    YZMessageChannel *messageChannel = self.messageChannelList[indexPath.row];
    cell.imageView.image = messageChannel.user.profileImage;
    cell.textLabel.text = messageChannel.user.username;
    cell.detailTextLabel.text = messageChannel.message;
    return cell;
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

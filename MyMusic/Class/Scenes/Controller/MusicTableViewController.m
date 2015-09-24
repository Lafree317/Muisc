//
//  MusicTableViewController.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/21.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "MusicTableViewController.h"
#import "MusicCell.h"
#import "ProjectHandle.h"
#import "GetDataManager.h"
#import "AudioPlayerManager.h"
#import "PlayMusicViewController.h"
@interface MusicTableViewController ()

@end

@implementation MusicTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:CEllID];
    // 通过block回调 刷新数据
    [[GetDataManager shardManager] getDataWithUrlStr:kMusicListUrl AndBlock:^{
        // 2.内部的block执行完毕 然后执行这个语句
        
        [self.tableView reloadData];
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GetDataManager shardManager].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:CEllID forIndexPath:indexPath];
    // 通过重写cell.model的set方法来赋值
    cell.model = [[GetDataManager shardManager] getModalWithIndex:indexPath.row];
    
    return cell;
}
/** 通过桥的ID跳转页面(主意 show默认是push如果没有navigation 那么show就是模态) showDetail就是模态 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"playMusic_id" sender:nil];
//    PlayMusicViewController *playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kPlayMuiscStoryBoaedID];
    PlayMusicViewController *playVC = [PlayMusicViewController sharManager];
    playVC.index = indexPath.row;
    
    [self showViewController:playVC sender:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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

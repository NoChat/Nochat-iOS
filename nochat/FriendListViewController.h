//
//  FriendListViewController.h
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btn_InviteFriend;
@property (strong, nonatomic) IBOutlet UIButton *btn_SendToBF;

@end

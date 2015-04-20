//
//  AuthViewController.h
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController<UITextFieldDelegate>{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textFieldreturn;

@property (strong, nonatomic) IBOutlet UITextField *text_PhoneNum;
@property (strong, nonatomic) IBOutlet UIButton *btn_AuthRequest;

@property NSString *userid;
@property NSString *userpwd;

- (IBAction)action_Enter:(UIButton *)sender;

@end

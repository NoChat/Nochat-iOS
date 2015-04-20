//
//  LoginViewController.h
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textFieldreturn;
@property (strong, nonatomic) IBOutlet UITextField *text_ID;
@property (strong, nonatomic) IBOutlet UITextField *text_PWD;
@property (strong, nonatomic) IBOutlet UIButton *btn_NochatStart;
- (IBAction)action_start:(UIButton *)sender;

@end

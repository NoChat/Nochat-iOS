//
//  IDPWDEnterViewController.h
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDPWDEnterViewController : UIViewController<UITextFieldDelegate>{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textFieldreturn;
@property (strong, nonatomic) IBOutlet UITextField *text_ID;
@property (strong, nonatomic) IBOutlet UITextField *text_PWD;
@property (strong, nonatomic) IBOutlet UIButton *btn_Enter;


- (IBAction)action_Enter:(id)sender;



@end

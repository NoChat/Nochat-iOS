//
//  AuthNumEnterViewController.m
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import "AuthNumEnterViewController.h"
#import "AFHTTPRequestOperationManager.h"


@interface AuthNumEnterViewController ()
@property (nonatomic, strong) NSMutableDictionary *Jsondata;

@end

@implementation AuthNumEnterViewController
@synthesize text_AuthNum,btn_NochatStart,Jsondata;

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    if([textField isEqual:text_AuthNum]){
        [text_AuthNum becomeFirstResponder];
    }
    
    return YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)action_start:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"User_Property_List.plist"];
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSString *serverURL = [savedStock objectForKey:@"serverURL"];
    NSString *api_token = [savedStock objectForKey:@"api_token"];
    NSString *user_id = [savedStock objectForKey:@"user_id"];
    NSString *user_pwd = [savedStock objectForKey:@"user_pwd"];
    NSString *phone_number = [savedStock objectForKey:@"phone_number"];
    
    //불러온 전화번호 값을 가지고 서버에 인증번호 요청 (post)
    NSString *url = [NSString stringWithFormat: @"%@/users/phone/auth", serverURL];
    NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"phoneNumber": phone_number, @"phoneNumberToken" : text_AuthNum.text};
    
    
    [manager.requestSerializer setValue:api_token forHTTPHeaderField:@"apiToken"];
    
    [manager POST:encodedUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSLog(@"JSON: %@", jsonDict);
        
        
        NSString *code = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"code"]];
        
        
        if([code isEqualToString:@"0"]){
            
            Jsondata = (NSMutableDictionary *) [jsonDict objectForKey:@"data"];
            NSLog(@"DATA: %@", Jsondata);
            
            NSString *url = [NSString stringWithFormat: @"%@/users/signin", serverURL];
            NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"loginId": user_id, @"password": user_pwd};
            
            [manager POST:encodedUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *jsonDict = (NSDictionary *) responseObject;
                NSLog(@"JSON: %@", jsonDict);
                
                
                NSString *code = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"code"]];
                
                
                if([code isEqualToString:@"0"]){
                    
                    Jsondata = (NSMutableDictionary *) [jsonDict objectForKey:@"data"];
                    NSLog(@"DATA: %@", Jsondata);
                    NSString *apiToken = [NSString stringWithFormat:@"%@", [Jsondata objectForKey:@"apiToken"]];
                    NSString *phoneNumber = [NSString stringWithFormat:@"%@", [Jsondata objectForKey:@"phoneNumber"]];
                    
                    NSLog(@"apiToken: %@", apiToken);
                    NSLog(@"phoneNumber: %@", phoneNumber);
                    
                    
                    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
                    if (mdict == nil) {
                        mdict = [[NSMutableDictionary alloc] init];
                    }
                    
                    
                    [mdict setObject:apiToken forKey: @"api_token"];
                    [mdict setObject:phoneNumber forKey: @"phone_number"];
                    
                    [mdict writeToFile:finalPath atomically:YES];
                    
                    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
                    NSString *api_token = [savedStock objectForKey:@"api_token"];
                    NSString *phone_number = [savedStock objectForKey:@"phone_number"];
                    
                    
                    NSLog(@"api_token: %@", api_token);
                    NSLog(@"phone_number: %@", phone_number);
                    
                     [self performSegueWithIdentifier:@"segueToNext" sender:self];
                    
                    
                }
                else{
                    NSString *msg = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"msg"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류!" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

        }
        else{
            NSString *msg = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"msg"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류!" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}
@end

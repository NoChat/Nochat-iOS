//
//  AuthViewController.m
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import "AuthViewController.h"
#import "AFHTTPRequestOperationManager.h"


@interface AuthViewController ()
@property (nonatomic, strong) NSMutableDictionary *Jsondata;

@end

@implementation AuthViewController
@synthesize text_PhoneNum, btn_AuthRequest,userpwd,userid,Jsondata;

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    if([textField isEqual:text_PhoneNum]){
        [text_PhoneNum becomeFirstResponder];
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

- (IBAction)action_Enter:(UIButton *)sender {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"User_Property_List.plist"];
    
            NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    
            NSString *serverURL = [savedStock objectForKey:@"serverURL"];
            NSString *api_token = [savedStock objectForKey:@"api_token"];
    
            NSLog(@"api_token: %@", api_token);
    
            //불러온 전화번호 값을 가지고 서버에 인증번호 요청 (post)
            NSString *url = [NSString stringWithFormat: @"%@/users/phone/token", serverURL];
            NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
            NSLog(@"%@, %@, %@ ", url, userid, text_PhoneNum.text);

            //AFHTTP 라이브러리를 사용
    
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"phoneNumber": text_PhoneNum.text};
    
    
            [manager.requestSerializer setValue:api_token forHTTPHeaderField:@"apiToken"];
            [manager POST:encodedUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                NSDictionary *jsonDict = (NSDictionary *) responseObject;
                NSLog(@"JSON: %@", jsonDict);
                
                NSString *code = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"code"]];
                
                if([code isEqualToString:@"0"]) {
                    
                    Jsondata = (NSMutableDictionary *) [jsonDict objectForKey:@"data"];
                    NSLog(@"DATA: %@", Jsondata);
                    
                    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
                    if (mdict == nil) {
                        mdict = [[NSMutableDictionary alloc] init];
                    }
                    
                    [mdict setObject:text_PhoneNum.text forKey: @"phone_number"];
                    [mdict writeToFile:finalPath atomically:YES];
                    
                    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
                    NSString *phone_number = [savedStock objectForKey:@"phone_number"];
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


@end

//
//  LoginViewController.m
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"


@interface LoginViewController ()
@property (nonatomic, strong) NSMutableDictionary *Jsondata;


@end

@implementation LoginViewController
@synthesize text_PWD, text_ID, btn_NochatStart, Jsondata;

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    if([textField isEqual:text_ID]){
        [text_PWD becomeFirstResponder];
    }
    
    else if([textField isEqual:text_PWD])
    {
        [text_PWD resignFirstResponder];
        [[self parentViewController] dismissModalViewControllerAnimated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)action_start:(UIButton *)sender {
    
    
    /*
     로그인
     
     /users/signin
     POST
     loginId=<로그인아이디>
     password=<패스워드>
     
     */
    
    //아이폰이 현재 사용하고 있는 지역 설정 표시
    NSLocale *locale = [NSLocale currentLocale];
    NSString *user_id = text_ID.text;
    NSString *user_pwd = text_PWD.text;
    NSString *current_locale = [locale localeIdentifier];
    NSString *os = @"iOS";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"User_Property_List.plist"];
    
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
    if (mdict == nil) {
        mdict = [[NSMutableDictionary alloc] init];
    }
    
    [mdict setObject:user_id forKey: @"user_id"];
    [mdict setObject:user_pwd forKey: @"user_pwd"];
    [mdict setObject:current_locale forKey: @"locale"];
    [mdict setObject:os forKey: @"os"];
    [mdict writeToFile:finalPath atomically:YES];
    
    
    
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    
    NSString *serverURL = [savedStock objectForKey:@"serverURL"];
    NSString *device_token = [savedStock objectForKey:@"device_token"];
    NSLog(@"%@, %@, %@ ", serverURL, current_locale, device_token);
    
    
    
    
    
    //불러온 전화번호 값을 가지고 서버에 회원가입 요청 (post)
    NSString *url = [NSString stringWithFormat: @"%@/users/signin", serverURL];
    NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    //AFHTTP 라이브러리를 사용
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"loginId": text_ID.text, @"password": text_PWD.text};
    
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
@end

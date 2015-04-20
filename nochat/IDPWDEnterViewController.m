//
//  IDPWDEnterViewController.m
//  nochat
//
//  Created by Jaeky on 2015. 3. 23..
//  Copyright (c) 2015년 Nexters. All rights reserved.
//

#import "IDPWDEnterViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AuthViewController.h"

@interface IDPWDEnterViewController ()
@property (nonatomic, strong) NSMutableDictionary *Joindata;


@end

@implementation IDPWDEnterViewController
@synthesize btn_Enter, text_ID, text_PWD,Joindata;



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

- (IBAction)action_Enter:(id)sender {
    
    /*
    회원가입
    
    /users/signup
    POST
    loginId=<로그인아이디>
    password=<패스워드>
    deviceToken=<푸시토큰>
    locale=<언어코드>
    ex) ko_KR
    os=<해당 os>
    ex) iOS, Android
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
    NSString *url = [NSString stringWithFormat: @"%@/users/signup", serverURL];
    NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"loginId": text_ID.text, @"password": text_PWD.text, @"deviceToken" : device_token, @"locale" : current_locale, @"os" : os};
    
    [manager POST:encodedUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSLog(@"JSON: %@", jsonDict);
        
        NSString *code = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"code"]];

        if([code isEqualToString:@"0"]){
        
            Joindata = (NSMutableDictionary *) [jsonDict objectForKey:@"data"];
            NSLog(@"DATA: %@", Joindata);
            NSString *apiToken = [NSString stringWithFormat:@"%@", [Joindata objectForKey:@"apiToken"]];
            NSLog(@"apiToken: %@", apiToken);
            
            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
            if (mdict == nil) {
                mdict = [[NSMutableDictionary alloc] init];
            }


            [mdict setObject:apiToken forKey: @"api_token"];
            [mdict writeToFile:finalPath atomically:YES];
            
            NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
            NSString *api_token = [savedStock objectForKey:@"api_token"];

            NSLog(@"api_token: %@", api_token);
 
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


 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if ([[segue identifier] isEqualToString:@"segueToNext"])
     {
         AuthViewController *vc = [segue destinationViewController];
         vc.userid = text_ID.text;
         vc.userpwd = text_PWD.text;
         
     }

 }


@end

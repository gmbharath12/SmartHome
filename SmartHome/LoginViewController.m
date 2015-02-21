//
//  LoginViewController.m
//  SmartHome
//
//  Created by Bharath G M on 2/18/15.
//  Copyright (c) 2015 Bharath G M. All rights reserved.
//

#import "LoginViewController.h"
#import "Device.h"
#import "HomeViewController.h"

static NSString* baseURL = @"http://54.69.170.92:8080/OASIS_Server";
static NSString* logInURL = @"http://54.69.170.92:8080/OASIS_Server/user/login";
static NSString* listOfDevicesURL = @"http://54.69.170.92:8080/OASIS_Server/user/getDevices";

@interface LoginViewController ()<UITextFieldDelegate>
{
    IBOutlet UITextField* userNameTextField;
    IBOutlet UITextField* passwordTextField;
    IBOutlet UIButton* submit;
    NSString* userName;
    NSString* password;
    Device* deviceData;
    NSArray* listOfDevices;
    HomeViewController* homeViewController;
}

@property (nonatomic, strong) NSData* data; //data for the list of devices URL

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Smart Home";
}

-(IBAction)onSubmit:(id)sender
{
    

    NSLog(@"UName = %@", userName);
    NSLog(@"Pwd = %@", password);
    
    
    if([userName isEqualToString:@""] || [password isEqualToString:@""] )
    {
        NSLog(@"Please enter both Username and Password,Login Failed!");
        
    }
    else
    {
        NSString *post =[[NSString alloc] initWithFormat:@"emailId=%@&password=%@",userName,password];
        NSLog(@"PostData: %@",post);

        NSURL *url = [NSURL URLWithString:logInURL];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSLog(@"Response data = %@",responseData);
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        
        if ([responseString isEqualToString: @"true"])
        {
            [self downloadListOfDevices];
        }

    }

}


#pragma mark--
#pragma mark GetListOfDevices

-(void)downloadListOfDevices
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       
                       NSMutableString* deviceURL = [NSMutableString stringWithString:listOfDevicesURL];
                       [deviceURL appendString:[NSString stringWithFormat:@"?emailId=%@",userName]];
                       NSLog(@"%@",deviceURL);
                       self.data = [NSData dataWithContentsOfURL:[NSURL URLWithString:deviceURL]];
                       NSLog(@"Data = %@", self.data);
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (!self.data)
                                          {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Internet appears to be offline" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                                              [alertView show];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              
                                          }
                                          else
                                          {
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              id jsonObjects = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
                                              [self performSelector:@selector(setListOfDevices:) onThread:[NSThread mainThread] withObject:jsonObjects waitUntilDone:NO];
                                          }
                                      }
                                      );
                   });

}


-(void)setListOfDevices:(id)jsonObject
{
    NSMutableArray *lObjects = [NSMutableArray array];
    NSLog(@"Json Objects = %@",jsonObject);
    for (id object in jsonObject)
    {
        deviceData = [[Device alloc] init];
        deviceData.deviceName = [object valueForKey:@"deviceName"];
        deviceData.deviceId = [object valueForKey:@"id"];
        [lObjects addObject:deviceData];
    }
    listOfDevices = [NSArray arrayWithArray:lObjects];
    if (listOfDevices)
    {
        homeViewController = [[HomeViewController alloc] init];
        homeViewController.listOfDevices = listOfDevices;
        [self.navigationController pushViewController:homeViewController animated:YES];
    }

}

#pragma mark--

#pragma mark UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == userNameTextField)
    {
       userName =  userNameTextField.text;
    }
    
    if (textField == passwordTextField)
    {
        password = passwordTextField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

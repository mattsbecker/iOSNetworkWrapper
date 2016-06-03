//
//  ViewController.m
//  NetworkWrapperExample
//
//  Created by Matt on 6/2/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestTestTableView.delegate = self;
    self.requestTestTableView.dataSource = self;
    NSDictionary *token = [NSDictionary dictionaryWithObjectsAndKeys:@"099c9ba364cf48e69d7d61b5c063b5c2", @"X-Zen-ApiKey", nil];
    self.requestHeaders = [NSMutableArray arrayWithObject:token];
    
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResponse:) name:kTestNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2; // return two cells for this section; Path and Method
    } else if (section == 1){
        return self.requestHeaders.count + 1;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    } else {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Path and Method";
    } else if (section == 1){
        return @"HTTP Headers";
    } else if (section == 2) {
        return @"Request Body";
    } else {
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // first section contains Path and Method rows
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestPathCell"];
            return cell;
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestMethodCell"];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < self.requestHeaders.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPHeaderKeyValueCell"];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPAddHeadersCell"];
            return cell;
        }
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestBodyCell"];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PerformRequestCell"];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoringCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        self.requestPath = textField.text;
        NSLog(@"Set Request Path to: %@", self.requestPath);
    }
    [textField resignFirstResponder];
    return YES;
}



- (IBAction)newHTTPHeaderBtnPress:(id)sender {
    NSInteger currentIdx = self.requestHeaders.count;
    NSString *newHeaderKey = [NSString stringWithFormat:@"new-header-%ld", currentIdx];
    NSDictionary *newHTTPHeader = [NSDictionary dictionaryWithObjectsAndKeys:@"", newHeaderKey, nil];
    [self.requestHeaders addObject:newHTTPHeader];
    [self.requestTestTableView reloadData];
}



- (IBAction)methodPOSTBtnPress:(id)sender {
    self.requestMethod = @"POST";
    NSLog(@"Set Method to: %@", self.requestMethod);
}

- (IBAction)methodGETBtnPress:(id)sender {
    self.requestMethod = @"GET";
    NSLog(@"Set Method to: %@", self.requestMethod);
}

- (IBAction)methodPUTBtnPress:(id)sender {
    self.requestMethod = @"PUT";
    NSLog(@"Set Method to: %@", self.requestMethod);
}

- (IBAction)methodDELETEBtnPress:(id)sender {
    self.requestMethod = @"DELETE";
    NSLog(@"Set Method to: %@", self.requestMethod);
}

- (IBAction)performHTTPRequestBtnPress:(id)sender {
    [self performRequestAction];
}

- (void)performRequestAction {
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"X-Zen-ApiKey", @"application/json", @"Content-Type", nil];
    
    [[NetworkWrapper sharedWrapper] performHTTPRequestWithPath:self.requestPath
                                                        method:self.requestMethod
                                                   requestBody:nil
                                                requestHeaders:headers
                                             completionHandler:^(NSData *responseData, NSError *error)
     {
         NSString *responseBody = [NSString stringWithUTF8String:[responseData bytes]];
         NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:responseBody, @"response-body", nil];
         NSLog(@"%@", responseDict);
     }];
}

- (void)handleResponse:(NSNotification *) notification {
    NSLog(@"Handling notification");
    NSLog(@"Notification data: %@", notification.userInfo);
}


@end

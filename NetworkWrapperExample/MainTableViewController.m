//
//  ViewController.m
//  NetworkWrapperExample
//
//  Created by Matt on 6/2/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()
@property (nonatomic,strong) NSString *responseBody;
@property (nonatomic, assign) NSInteger responseStatusCode;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSMutableDictionary *responseHeaders;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestTestTableView.delegate = self;
    self.requestTestTableView.dataSource = self;
    self.requestHeaders = [NSMutableArray array];
    self.responseHeaders = [NSMutableDictionary dictionary];
    [self setTitle:NSLocalizedString(@"Create Network Request", @"Create network request string")];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResponse:) name:kTestNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHistoryRequestedNotification:) name:kHistoryRequestedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- TableViewDataSource Methods ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == RequestTableViewSectionPath) {
        return 2; // return two cells for this section; Path and Method
    } else if (section == RequestTableViewSectionHeaders){
        return self.headerCount + 1;
    } else if (section == RequestTableViewSectionBody) {
        return 1;
    } else if (section == RequestTableViewSectionPerformRequest) {
        return 1;
    } else {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

#pragma mark --- UITableViewDelegate Methods ---


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
    if (indexPath.section == RequestTableViewSectionPath) {
        if (indexPath.row == 0) {
            NWRequestPathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestPathCell"];
            return cell;
        } else if (indexPath.row == RequestTableViewSectionHeaders) {
            NWRequestMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestMethodCell"];
            cell.delegate = self;
            return cell;
        }
    } else if (indexPath.section == RequestTableViewSectionHeaders) {
        if (indexPath.row < self.headerCount) {
            NWRequestHeaderKeyValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPHeaderKeyValueCell"];
            cell.headerDictionary = [self.requestHeaders objectAtIndex:indexPath.row];
            cell.delegate = self;
            cell.indexPath = indexPath.row;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPAddHeadersCell"];
            return cell;
        }
    } else if (indexPath.section == RequestTableViewSectionBody) {
        HTTPRequestBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestBodyCell"];
        return cell;
    } else if (indexPath.section == RequestTableViewSectionPerformRequest) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PerformRequestCell"];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoringCell"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == RequestTableViewSectionHeaders) {
        if (indexPath.row < self.headerCount) {
            return 88;
        }
    } else if (indexPath.section == RequestTableViewSectionBody) {
        return 176;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform Request Button
    if (indexPath.section == RequestTableViewSectionPerformRequest && indexPath.row == 0) {
        [self performRequestAction];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark --- UITextFieldDelegate Methods ---

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self handleTextFieldDismissal:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleTextFieldDismissal:textField];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --- NWRequestHeaderKeyValueTableViewCellDelegate Methods ---


-(void)tableViewCell:(NWRequestHeaderKeyValueTableViewCell*) cell didEnableHeaderValueTextField:(UITextField*) textField {
    [self handleTextFieldDismissal:textField];
}

-(void)tableViewCell:(NWRequestHeaderKeyValueTableViewCell *)cell didFinishHeaderValueInput:(UITextField *)textField {
    [self handleTextFieldDismissal:textField];
}

#pragma mark NWRequestMethodTableViewCellDelegate Methods
-(void)tableViewCell:(NWRequestMethodTableViewCell*)cell didSelectMethodButton:(NWRequestMethodButton*)button {
    if (button.method == RequestMethodPost) {
        self.requestMethod = @"POST";
    } else if (button.method == RequestMethodGet) {
        self.requestMethod = @"GET";
    } else if (button.method == RequestMethodPut) {
        self.requestMethod = @"PUT";
    } else if (button.method == RequestMethodDelete) {
        self.requestMethod = @"DELETE";
    }
}


#pragma mark --- Class Methods ---


- (IBAction)newHTTPHeaderBtnPress:(id)sender {
    // do not allow the user to create a new header row if there's already a blank one created
    if (!self.requestHeaders && self.headerCount == 1) {
        return;
    }
    
    // increment the header count for reference; create a new dictionary entry for an empty header
    self.headerCount += 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"", nil];
    [self.requestHeaders addObject:dict];
    
    // begin updating the table view; insert the row at the bottom
    [self.requestTestTableView beginUpdates];
    [self.requestTestTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(self.headerCount - 1) inSection:RequestTableViewSectionHeaders]] withRowAnimation:UITableViewRowAnimationFade];
    [self.requestTestTableView endUpdates];
}

- (void)performRequestAction {
    NSLog(@"Headers: %@", self.requestHeaders);
    
    // maintain a keys and values array. Later, we'll use this for populating a final dictionary of headers
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    // iterate through all keys and values from the dictionaries contained in the requestHeaders array;
    for (NSDictionary *dictionary in self.requestHeaders) {
        [keys addObjectsFromArray:[dictionary allKeys]];
        [values addObjectsFromArray:[dictionary allValues]];
    }
    
    NSDictionary *headers = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    [[NetworkWrapper sharedWrapper] performHTTPRequestWithPath:self.requestPath
                                                        method:self.requestMethod
                                                   requestBody:nil
                                                requestHeaders:headers
                                             completionHandler:^(NSInteger statusCode, NSDictionary *responseHeaders, NSData *responseData, NSError *error)
     {
         if (error) {
             NSLog(@"%@", error.localizedDescription);
             NSString *errorDescription = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
             NSString *underlyingError = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"NSUnderlyingError"]];
             [self buildAlertDialogWithTitle:errorDescription  message:underlyingError];
             return;
         }
         self.responseBody = [NSString stringWithUTF8String:[responseData bytes]];
         self.responseData = responseData;
         self.responseStatusCode = statusCode;
         self.responseHeaders = [NSMutableDictionary dictionaryWithDictionary:responseHeaders];
         
         // grab the last request we tried and store it so we can use it for next time
         
         // Start a segue to the Response View Controller, always do this on the main thread
         dispatch_async(dispatch_get_main_queue(), ^{
             [self performSegueWithIdentifier:@"RequestResponseSegue" sender:self];
         });
         NSLog(@"%@", [NetworkWrapper sharedWrapper].requests);
    }];
}

- (void)handleTextFieldDismissal:(UITextField *) textField {
    
    // This is the request path field; we shouldn't allow nil here!
    if ([textField tag] == 1) {
        self.requestPath = textField.text;
        NSLog(@"Set Request Path to: %@", self.requestPath);
    } else if ([textField tag] == 2) {
        
        // Request header key
        NWRequestHeaderKeyValueTableViewCell *cell = (NWRequestHeaderKeyValueTableViewCell*)textField.superview.superview;
        NSMutableDictionary *headerDictionary = [NSMutableDictionary dictionary];
        [headerDictionary setObject:@"" forKey:textField.text];
        [self.requestHeaders replaceObjectAtIndex:cell.indexPath withObject:headerDictionary];
        [cell.httpHeaderValueTxtField becomeFirstResponder];
    } else if ([textField tag] == 3) {
        
        //Request header value
        NWRequestHeaderKeyValueTableViewCell *cell = (NWRequestHeaderKeyValueTableViewCell*)textField.superview.superview;
        NSMutableDictionary *headerDictionary = [self.requestHeaders objectAtIndex:cell.indexPath];
        NSArray *key  =[headerDictionary allKeys];
        [headerDictionary setObject:textField.text forKey:[key objectAtIndex:0]];
        [self.requestHeaders replaceObjectAtIndex:cell.indexPath withObject:headerDictionary];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"RequestResponseSegue"]) {
        
        // handle the response segueue by preparing the response code, headers, and body
        ResponseDetailsTableViewController *responseViewController = (ResponseDetailsTableViewController*)[segue destinationViewController];
        [responseViewController setResponseCode:[NSString stringWithFormat:@"%ld", self.responseStatusCode]];
        NSString *responseHeaders = [NSString stringWithFormat:@"%@", self.responseHeaders];
        [responseViewController setResponseHeaders:responseHeaders];
        NSString *responseJSON = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];
        [responseViewController setResponseBody:responseJSON];
    } else if ([[segue identifier] isEqualToString:@"RequestHistorySegue"]) {
        
        // grab the requests from the wrapper (only application lifecycle history for right now) - gone once singleton is destroyed
        
        NSLog(@"%@", [NetworkWrapper sharedWrapper].requests);
        
        RequestHistoryTableViewController *requestHistoryViewController = (RequestHistoryTableViewController*)[segue destinationViewController];
        NSMutableArray *recentRequests = [NetworkWrapper sharedWrapper].requests;
        [requestHistoryViewController setRequests:recentRequests];
    }
}

- (void)handleHistoryRequestedNotification:(NSNotification*) notification {
    // show a modal view controller
    NSLog(@"Will show request history");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"RequestHistorySegue" sender:self];
    });

}

- (void)handleResponse:(NSNotification *) notification {
    NSLog(@"Handling notification");
    NSLog(@"Notification data: %@", notification.userInfo);
}

- (void)buildAlertDialogWithTitle:(NSString *)title message:(NSString *)message {
    if (!title || !message) {
        return;
    }
    UIAlertController *alertController = [[UIAlertController alloc] init];
    [alertController setTitle:title];
    [alertController setMessage:message];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

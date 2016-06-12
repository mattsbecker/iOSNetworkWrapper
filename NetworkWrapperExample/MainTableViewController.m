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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- TableViewDataSource Methods ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2; // return two cells for this section; Path and Method
    } else if (section == 1){
        return self.headerCount + 1;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NWRequestPathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestPathCell"];
            return cell;
        } else if (indexPath.row == 1) {
            NWRequestMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestMethodCell"];
            cell.delegate = self;
            return cell;
        }
    } else if (indexPath.section == 1) {
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
    } else if (indexPath.section == 2) {
        HTTPRequestBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPRequestBodyCell"];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PerformRequestCell"];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoringCell"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row < self.headerCount) {
            return 88;
        }
    } else if (indexPath.section == 2) {
        return 176;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform Request Button
    if (indexPath.section == 3 && indexPath.row == 0) {
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
    self.headerCount += 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"", nil];
    [self.requestHeaders addObject:dict];
    [self.requestTestTableView reloadData];
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
         self.responseBody = [NSString stringWithUTF8String:[responseData bytes]];
         self.responseData = responseData;
         self.responseStatusCode = statusCode;
         self.responseHeaders = [NSMutableDictionary dictionaryWithDictionary:responseHeaders];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self performSegueWithIdentifier:@"RequestResponseSegue" sender:self];
         });
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
        [self.requestTestTableView reloadData];
    } else if ([textField tag] == 3) {
        
        //Request header value
        NWRequestHeaderKeyValueTableViewCell *cell = (NWRequestHeaderKeyValueTableViewCell*)textField.superview.superview;
        NSMutableDictionary *headerDictionary = [self.requestHeaders objectAtIndex:cell.indexPath];
        NSArray *key  =[headerDictionary allKeys];
        [headerDictionary setObject:textField.text forKey:[key objectAtIndex:0]];
        [self.requestHeaders replaceObjectAtIndex:cell.indexPath withObject:headerDictionary];
        [self.requestTestTableView reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"RequestResponseSegue"]) {
        ResponseDetailsTableViewController *responseViewController = (ResponseDetailsTableViewController*)[segue destinationViewController];
        [responseViewController setResponseCode:[NSString stringWithFormat:@"%ld", self.responseStatusCode]];
        NSString *responseHeaders = [NSString stringWithFormat:@"%@", self.responseHeaders];
        [responseViewController setResponseHeaders:responseHeaders];
        NSString *responseJSON = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];
        [responseViewController setResponseBody:responseJSON];
    }
}

- (void)handleResponse:(NSNotification *) notification {
    NSLog(@"Handling notification");
    NSLog(@"Notification data: %@", notification.userInfo);
}


@end
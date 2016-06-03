//
//  ViewController.h
//  NetworkWrapperExample
//
//  Created by Matt on 6/2/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkWrapper.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *requestTestTableView;

@property (nonatomic, strong) NSMutableArray *requestHeaders; // array of dictionaries
@property (nonatomic, strong) NSString *requestMethod;
@property (nonatomic, strong) NSString *requestPath;

- (IBAction)newHTTPHeaderBtnPress:(id)sender;

- (IBAction)methodPOSTBtnPress:(id)sender;
- (IBAction)methodGETBtnPress:(id)sender;
- (IBAction)methodPUTBtnPress:(id)sender;
- (IBAction)methodDELETEBtnPress:(id)sender;
- (IBAction)performHTTPRequestBtnPress:(id)sender;

@end


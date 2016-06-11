//
//  ViewController.h
//  NetworkWrapperExample
//
//  Created by Matt on 6/2/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkWrapper.h"
#import "AppDelegate.h"
#import "NWRequestPathTableViewCell.h"
#import "NWRequestHeaderKeyValueTableViewCell.h"
#import "HTTPRequestBodyTableViewCell.h"
#import "ResponseDetailsTableViewController.h"
#import "NWRequestMethodTableViewCell.h"


@interface MainTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NWRequestHeaderKeyValueTableViewCellDelegate, NWRequestMethodTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *requestTestTableView;

@property (nonatomic, strong) NSMutableArray *requestHeaders; // array of dictionaries 
@property (nonatomic, assign) NSInteger headerCount;
@property (nonatomic, strong) NSString *requestMethod;
@property (nonatomic, strong) NSString *requestPath;

- (IBAction)newHTTPHeaderBtnPress:(id)sender;

@end


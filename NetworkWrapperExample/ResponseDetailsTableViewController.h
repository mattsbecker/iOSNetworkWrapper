//
//  ResponseDetailsTableViewController.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/10/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWResponseBodyTableViewCell.h"

@interface ResponseDetailsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseBody;
@property (strong, nonatomic) IBOutlet UITableView *responseDetailsTableView;

@end

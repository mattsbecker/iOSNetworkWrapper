//
//  ResponseDetailsTableViewController.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/10/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWResponseBodyTableViewCell.h"

enum {
    ResponseTableViewSectionCode = 0,
    ResponseTableViewSectionHeaders,
    ResponseTableViewSectionBody
};

@interface ResponseDetailsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *responseCode;
@property (nonatomic, strong) NSString *responseBody;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSMutableDictionary *responseHeaders;
@property (strong, nonatomic) IBOutlet UITableView *responseDetailsTableView;
@property (nonatomic, assign) NSInteger headerRows;

@property (nonatomic, weak) IBOutlet UIImageView *responseImage;

@property (nonatomic, assign) BOOL shouldDisplayImage;

@end

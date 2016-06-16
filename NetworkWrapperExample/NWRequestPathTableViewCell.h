//
//  NWRequestPathTableViewCell.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/5/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kHistoryRequestedNotification;

@interface NWRequestPathTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *requestPathTxtField;
@property (weak, nonatomic) IBOutlet UIButton *requestHistoryBtn;

- (IBAction)requestHistoryBtnPress:(id)sender;

@end

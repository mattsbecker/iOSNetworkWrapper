//
//  NWRequestPathTableViewCell.m
//  NetworkWrapper
//
//  Created by Matt Becker on 6/5/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NWRequestPathTableViewCell.h"

NSString *kHistoryRequestedNotification = @"HistoryRequestedNotification";

@implementation NWRequestPathTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)requestHistoryBtnPress:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kHistoryRequestedNotification object:nil];
}

@end

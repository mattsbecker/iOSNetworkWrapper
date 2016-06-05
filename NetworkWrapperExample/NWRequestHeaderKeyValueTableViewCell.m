//
//  NWRequestHeaderKeyValueTableViewCell.m
//  NetworkWrapper
//
//  Created by Matt Becker on 6/5/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NWRequestHeaderKeyValueTableViewCell.h"

@implementation NWRequestHeaderKeyValueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeaderDictionary:(NSMutableDictionary *)headerDictionary {
    if (_headerDictionary != headerDictionary) {
        _headerDictionary = headerDictionary;
    }
    
    NSArray *keyArray = [self.headerDictionary allKeys];
    NSString *key = [keyArray objectAtIndex:0];
    self.httpHeaderKeyTxtField.text = key;
    
    if (self.httpHeaderKeyTxtField.text.length > 0) {
        [self.httpHeaderValueTxtField setEnabled:YES];
        [self.httpHeaderValueTxtField becomeFirstResponder];
    } else {
        [self.httpHeaderValueTxtField setEnabled:NO];
    }
    
    NSString *value = [self.headerDictionary objectForKey:key];
    self.httpHeaderValueTxtField.text = value;
}

@end

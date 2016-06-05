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
    self.httpHeaderKeyTxtField.delegate = self;
    self.httpHeaderValueTxtField.delegate = self;
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

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self handleTextFieldDismissal:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleTextFieldDismissal:textField];
    [textField resignFirstResponder];
    return YES;
}

- (void)handleTextFieldDismissal:(UITextField *) textField {
    // This is the request path field; we shouldn't allow nil here!
    if ([textField tag] == 2) {
        // Request header key
        [textField resignFirstResponder];
        [self.httpHeaderValueTxtField setEnabled:YES];
        [self.httpHeaderValueTxtField becomeFirstResponder];
        if (self.delegate != nil) {
            [self.delegate tableViewCell:self didEnableHeaderValueTextField:textField];
        }
    } else if ([textField tag] == 3) {
        [self.httpHeaderValueTxtField resignFirstResponder];
        if (self.delegate != nil) {
            [self.delegate tableViewCell:self didFinishHeaderValueInput:textField];
        }
    }
}


@end

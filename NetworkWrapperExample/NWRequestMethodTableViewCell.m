//
//  NWRequestMethodTableViewCell.m
//  NetworkWrapper
//
//  Created by Matt Becker on 6/11/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NWRequestMethodTableViewCell.h"

@implementation NWRequestMethodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.postBtn.method = RequestMethodPost;
    self.getBtn.method = RequestMethodGet;
    self.putBtn.method = RequestMethodPut;
    self.deleteBtn.method = RequestMethodDelete;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)postBtnPress:(id)sender {
    [self.postBtn setSelected:YES];
    [self.getBtn setSelected:NO];
    [self.putBtn setSelected:NO];
    [self.deleteBtn setSelected:NO];
    [self handleButtonPress:sender];
}

- (IBAction)getBtnPress:(id)sender {
    [self.postBtn setSelected:NO];
    [self.getBtn setSelected:YES];
    [self.putBtn setSelected:NO];
    [self.deleteBtn setSelected:NO];
    [self handleButtonPress:sender];
}

- (IBAction)putBtnPress:(id)sender {
    [self.postBtn setSelected:NO];
    [self.getBtn setSelected:NO];
    [self.putBtn setSelected:YES];
    [self.deleteBtn setSelected:NO];
    [self handleButtonPress:sender];
}

- (IBAction)deleteBtnPress:(id)sender {
    [self.postBtn setSelected:NO];
    [self.getBtn setSelected:NO];
    [self.putBtn setSelected:NO];
    [self.deleteBtn setSelected:YES];
    [self handleButtonPress:sender];
}

-(void)handleButtonPress:(id)sender {
    // handle the state change and alert the delegate that the user selected a new button
    self.selectedBtn = (NWRequestMethodButton*)sender;
    if (self.delegate) {
        [self.delegate tableViewCell:self didSelectMethodButton:self.selectedBtn];
    }
}

@end

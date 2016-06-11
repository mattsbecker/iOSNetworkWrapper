//
//  NWRequestMethodButton.m
//  NetworkWrapper
//
//  Created by Matt Becker on 6/11/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NWRequestMethodButton.h"

@interface NWRequestMethodButton()

@property (nonatomic, retain) UIColor *primaryColor;

@end

@implementation NWRequestMethodButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setEnabled:(BOOL)enabled {
    self.primaryColor = self.titleLabel.textColor;
    [super setEnabled:enabled];
    if (self.enabled) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = self.primaryColor;
    } else {
        self.titleLabel.textColor = self.primaryColor;
        self.backgroundColor = [UIColor clearColor];
    }
}

@end

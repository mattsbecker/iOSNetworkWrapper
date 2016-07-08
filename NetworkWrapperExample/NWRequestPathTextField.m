//
//  NWRequestPathTextField.m
//  NetworkWrapper
//
//  Created by Matt Becker on 7/4/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "NWRequestPathTextField.h"

@implementation NWRequestPathTextField

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)handleTextDidChangeNotification:(NSNotification*)notification {
    // Get the current textfield and attributed text from the notification
    if ([notification.object class] != [NWRequestPathTextField class]) {
        return;
    }
    NWRequestPathTextField *textField = (NWRequestPathTextField*)notification.object;
    NSAttributedString *currentText = textField.attributedText;
    
    // Set the modified attributed string
    NSAttributedString *newAttributedString = [self highlightMeaningfulPathComponents:currentText];
    [textField setAttributedText:newAttributedString];
}

-(NSAttributedString*)highlightMeaningfulPathComponents:(NSAttributedString*)path {
    // search for HTTP/HTTPS and highlight appropriately – that's it for now
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:path];
    UIColor *highlightColor = [UIColor blackColor];
    
    // If the string isn't long enough to determine if it's HTTP or HTTPS yet, then just return the string
    if (path.string.length < 4) {
        return resultAttributedString;
    }
    if ([path.string containsString:@"https"] || [path.string containsString:@"HTTPS"]) {
        highlightColor = [NWUICommon standardPositiveColor];
        self.containsHTTPS = YES;
    } else if ([path.string containsString:@"http"] || [path.string containsString:@"HTTP"]) {
        highlightColor = [NWUICommon standardNegativeColor];
        self.containsHTTPS = NO;
    }
    
    // If we have HTTPS, then we're highlighting a range of 0-5; otherwise it's 0-4
    NSRange protocolRange = self.containsHTTPS?NSMakeRange(0,5):NSMakeRange(0, 4);
    
    [resultAttributedString addAttribute:NSForegroundColorAttributeName value:highlightColor range:protocolRange];
    
    // make sure the rest of the string's foreground color is black; protocolRange.length + 1 because the string is black after the protocol string.
    
    // If the string is only as long as the protocol, return. We're done here!
    if (resultAttributedString.length == protocolRange.length) {
        return resultAttributedString;
    }
    
    NSRange remainingStringRange = NSMakeRange(protocolRange.length, 1);
    
    [resultAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:remainingStringRange];
    
    return resultAttributedString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

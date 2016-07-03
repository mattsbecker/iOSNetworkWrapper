//
//  NWResponseBodyTableViewCell.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/10/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWResponseBodyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *responseBodyTxtView;
@property (weak, nonatomic) IBOutlet UIImageView *responseImageView;

@end

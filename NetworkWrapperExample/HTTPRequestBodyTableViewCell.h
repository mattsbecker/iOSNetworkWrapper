//
//  HTTPRequestBodyTableViewCell.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/5/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTTPRequestBodyTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *requestBodyTxtView;
@property (weak, nonatomic) IBOutlet UIView *requestBodyCellContentView;

@end

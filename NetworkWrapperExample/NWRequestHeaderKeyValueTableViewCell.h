//
//  NWRequestHeaderKeyValueTableViewCell.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/5/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWRequestHeaderKeyValueTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *httpHeaderKeyTxtField;
@property (weak, nonatomic) IBOutlet UITextField *httpHeaderValueTxtField;
@property (nonatomic, strong) NSMutableDictionary *headerDictionary;
@property (nonatomic, assign) NSInteger indexPath;



@end

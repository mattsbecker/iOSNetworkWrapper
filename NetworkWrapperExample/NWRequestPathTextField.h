//
//  NWRequestPathTextField.h
//  NetworkWrapper
//
//  Created by Matt Becker on 7/4/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWUICommon.h"

IB_DESIGNABLE
@interface NWRequestPathTextField : UITextField<UITextFieldDelegate>

@property (nonatomic, assign) BOOL containsHTTPS;
    
@end

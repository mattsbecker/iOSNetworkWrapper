//
//  NWRequestMethodButton.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/11/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

enum {
    RequestMethodPost = 0,
    RequestMethodGet,
    RequestMethodPut,
    RequestMethodDelete
};

@interface NWRequestMethodButton : UIButton

@property (nonatomic, assign) NSInteger method;

@end

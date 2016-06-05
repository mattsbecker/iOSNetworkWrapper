//
//  ResponseViewController.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/5/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *responseTxtView;
@property (nonatomic, strong) NSString *responseBody;
@property (nonatomic, strong) NSDictionary *responseDict;

@end

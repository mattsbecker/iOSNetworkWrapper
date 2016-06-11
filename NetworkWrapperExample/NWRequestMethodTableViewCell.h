//
//  NWRequestMethodTableViewCell.h
//  NetworkWrapper
//
//  Created by Matt Becker on 6/11/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWRequestMethodButton.h"

@interface NWRequestMethodTableViewCell : UITableViewCell

@property (nonatomic, assign) id delegate;
@property (weak, nonatomic) IBOutlet NWRequestMethodButton *postBtn;
@property (weak, nonatomic) IBOutlet NWRequestMethodButton *getBtn;
@property (weak, nonatomic) IBOutlet NWRequestMethodButton *putBtn;
@property (weak, nonatomic) IBOutlet NWRequestMethodButton *deleteBtn;

@property (nonatomic, strong) NWRequestMethodButton *selectedBtn;

- (IBAction)postBtnPress:(id)sender;
- (IBAction)getBtnPress:(id)sender;
- (IBAction)putBtnPress:(id)sender;
- (IBAction)deleteBtnPress:(id)sender;

@end

@protocol NWRequestMethodTableViewCellDelegate <NSObject>

-(void)tableViewCell:(NWRequestMethodTableViewCell*)cell didSelectMethodButton:(NWRequestMethodButton*)button;

@end
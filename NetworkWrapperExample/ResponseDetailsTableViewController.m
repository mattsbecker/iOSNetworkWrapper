//
//  ResponseDetailsTableViewController.m
//  NetworkWrapper
//
//  Created by Matt Becker on 6/10/16.
//  Copyright © 2016 Matt S Becker. All rights reserved.
//

#import "ResponseDetailsTableViewController.h"

@interface ResponseDetailsTableViewController ()
@property (nonatomic, strong) UITextView *responseTxtView;
@property (nonatomic, strong) UIImageView *responseImageView;
@end

@implementation ResponseDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // by default, we only show the "show raw headers" cell
    self.headerRows = 1;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != ResponseTableViewSectionHeaders) {
        return 1; // one per section right now
    } else {
        return self.headerRows;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // response code section
    if (section == ResponseTableViewSectionCode) {
        return @"Response Code";
    } else if (section == ResponseTableViewSectionHeaders) {
        return @"Response Headers";
    } else if (section == ResponseTableViewSectionBody) {
    // response body section
        return @"Response Body";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ResponseTableViewSectionCode) {
        return 44;
    } else if (indexPath.section == ResponseTableViewSectionHeaders) {
        if (indexPath.row == 0) {
            return 44;
        } else {
            return 352;
        }
    } else if (indexPath.section == ResponseTableViewSectionBody) {
        return 352;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == ResponseTableViewSectionCode && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPResponseStatusCodeCell" forIndexPath:indexPath];
        cell.textLabel.text = self.responseCode;
        return cell;
    } else if (indexPath.section == ResponseTableViewSectionHeaders) {
        
        // initial headers row
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPShowHeadersCell" forIndexPath:indexPath];
            return cell;
        } else if (indexPath.row == 1) {
            NWResponseBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPResponseBody" forIndexPath:indexPath];
            cell.responseBodyTxtView.text = [NSString stringWithFormat:@"%@", self.responseHeaders];
            return cell;
        }
        // row headers row
    } else if (indexPath.section == ResponseTableViewSectionBody && indexPath.row == 0) {
        NWResponseBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTPResponseBody" forIndexPath:indexPath];
        self.responseTxtView = cell.responseBodyTxtView;
        self.responseImageView = cell.responseImageView;
        [self setImageOrTextData];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == ResponseTableViewSectionHeaders && indexPath.row == 0) {
        self.headerRows = self.headerRows == 1 ? 2:1;
        [tableView beginUpdates];
        if (self.headerRows == 2) {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:ResponseTableViewSectionHeaders]] withRowAnimation:UITableViewRowAnimationTop];
        } else if (self.headerRows == 1){
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:ResponseTableViewSectionHeaders]] withRowAnimation:UITableViewRowAnimationTop];
        }
        [tableView endUpdates];
    }
}

#pragma mark Property Setters

#pragma mark Private Methods

-(void)setImageOrTextData {
    // determine if the response content-type is an image. If it is, then we'll just display the image here.
    NSString *responseContentType = [self.responseHeaders objectForKey:@"Content-Type"];
    if ([responseContentType containsString:@"image/"]) {
        self.shouldDisplayImage = YES;
    } else if ([responseContentType containsString:@"audio/"]) {
        // do stuff!
    } else {
        self.shouldDisplayImage = NO;
    }
    if (self.shouldDisplayImage) {
        self.responseImageView.image = [[UIImage alloc] initWithData:self.responseData];
        self.responseImageView.hidden = NO;
        self.responseTxtView.hidden = YES;
    } else {
        NSString *responseBodyString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        self.responseTxtView.text = [NSString stringWithFormat:@"%@", responseBodyString];
        self.responseImageView.image = nil;
        self.responseImageView.hidden = YES;
        self.responseTxtView.hidden = NO;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

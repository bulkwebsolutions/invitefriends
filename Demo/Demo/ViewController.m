//
//  ViewController.m
//  Demo
//
//  Created by Alex Cruz on 25/04/15.
//  Copyright (c) 2015 Alex Cruz. All rights reserved.
//

#import "ViewController.h"
#import "KTSContactsManager.h"
#import <MessageUI/MessageUI.h>

@interface ViewController () <KTSContactsManagerDelegate, MFMessageComposeViewControllerDelegate> {
    NSIndexPath* checkedIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *selectedUsers;
@property (strong, nonatomic) NSMutableArray *stateArray;
@property (strong, nonatomic) NSMutableArray *selectedRows;
@property (strong, nonatomic) NSMutableArray *recipients;


@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@property (strong, nonatomic) KTSContactsManager *contactsManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    [self loadData];
    
    self.stateArray = [[NSMutableArray alloc] init];
    self.selectedRows = [[NSMutableArray alloc] init];
  
}

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         [self.tableView reloadData];
         NSLog(@"contacts: %@",contacts);
     }];
}

-(void)addressBookDidChange
{
    NSLog(@"Address Book Change");
    [self loadData];
}

-(BOOL)filterToContact:(NSDictionary *)contact
{
    return YES;
    return ![contact[@"company"] isEqualToString:@""];
}

- (IBAction)addContact:(UIBarButtonItem *)sender
{
    
    NSLog(@"%@", self.selectedUsers);
    
    [self showSMS:self.selectedUsers];
    

//    [self.contactsManager addContactName:@"John"
//                                lastName:@"Smith"
//                                  phones:@[@{
//                                               @"value":@"+7-903-469-97-48",
//                                               @"label":@"Mobile"
//                                            }]
//                                  emails:@[@{
//                                               @"value":@"mail@mail.com",
//                                               @"label": @"home e-mail"
//                                               }]
//                                birthday:[NSDate dateWithTimeInterval:22 * 365 * 24 * 60 * 60 sinceDate:[NSDate date]]
//                                   image:[UIImage imageNamed:@"newContact"]
//                              completion:^(BOOL wasAdded) {
//                                  NSLog(@"Contact was %@ added",wasAdded ? @"" : @"NOT");
//                              }];
}

#pragma mark - TableView Methods

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
//    
//    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];
//    
//    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
//    NSString *firstName = contact[@"firstName"];
//    nameLabel.text = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
//    
//    UILabel *phoneNumber = (UILabel *)[cell viewWithTag:2];
//    NSArray *phones = contact[@"phones"];
//    
//    if ([phones count] > 0) {
//        NSDictionary *phoneItem = phones[0];
//        phoneNumber.text = phoneItem[@"value"];
//    }
//    
//    UIImageView *cellIconView = (UIImageView *)[cell.contentView viewWithTag:888];
//    
//    UIImage *image = contact[@"image"];
//    
//    cellIconView.image = (image != nil) ? image : [UIImage imageNamed:@"smiley-face"];
//    cellIconView.contentScaleFactor = UIViewContentModeScaleAspectFill;
//    cellIconView.layer.cornerRadius = CGRectGetHeight(cellIconView.frame) / 2;
// 
//  
//    return cell;
//}


///////////Working/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];

        /* create cell here */
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
        NSString *firstName = contact[@"firstName"];
        nameLabel.text = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
        
        UILabel *phoneNumber = (UILabel *)[cell viewWithTag:2];
        NSArray *phones = contact[@"phones"];
        
        if ([phones count] > 0) {
            NSDictionary *phoneItem = phones[0];
            phoneNumber.text = phoneItem[@"value"];
        }
        
        UIImageView *cellIconView = (UIImageView *)[cell.contentView viewWithTag:888];
        
        UIImage *image = contact[@"image"];
        
        cellIconView.image = (image != nil) ? image : [UIImage imageNamed:@"smiley-face"];
        cellIconView.contentScaleFactor = UIViewContentModeScaleAspectFill;
        cellIconView.layer.cornerRadius = CGRectGetHeight(cellIconView.frame) / 2;
       
    
    if([_checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
        // Add Selected rows to array to use with SMS
     //   self.selectedRows = self.selectedRows;
      //  NSLog(@"%@", self.selectedRows);
    

    
    return cell;
}

#pragma didSelectRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this is working
//    for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
//        [self.selectedRows addObject:self.tableData[indexPath.row]];
//    }
//    
//    self.selectedUsers = self.selectedRows;
//    NSLog(@"%@", self.selectedUsers);
//    
//    // Uncheck the previous checked row
//    if(_checkedIndexPath)
//    {
//        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:_checkedIndexPath];
//        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    _checkedIndexPath = indexPath;
    
    
    
    for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
        [self.selectedRows addObject:self.tableData[indexPath.row]];
    }
    
    self.selectedUsers = self.selectedRows;
    NSLog(@"%@", self.selectedUsers);
    
    // Uncheck the previous checked row
    if([self.checkedIndexPath isEqual:indexPath])
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedUsers removeLastObject];
        self.checkedIndexPath = nil;
        
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
    }

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
///////////DoneWorking/////////////////////////////////////////////////////////////////////////////////////////////////////////



// add checkmarks
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    // Adding selected row to an Array
//    // Then send a SMS to all phone number
//    NSMutableArray *selectedRows = [[NSMutableArray alloc] init];
//    for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
//        [selectedRows addObject:self.tableData[indexPath.row]];
//    }
//    // Add Selected rows to array to use with SMS
//    self.selectedUsers = selectedRows;
//    NSLog(@"%@", selectedRows);
//    
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    
//}
//
//// remove checkmarks //
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//}

///////////End/////////////////////////////////////////////////////////////////////////////////////////////////////////


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

#pragma SMS

- (void)showSMS:(NSArray *)selectedItems {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    
    
   // Go inside pull the numbers from the users and save in an NSArray
   NSArray *contacts = self.selectedUsers;
   self.recipients = [[NSMutableArray alloc] init];
   

    for (NSDictionary* dict in contacts) {
        
        // Grab phones
         NSDictionary *contactNumber = [dict objectForKey:@"phones"];
        
        for (NSDictionary* dict2 in contactNumber) {
        
         // Grabs the phone numbers
         NSString* value = [dict2 objectForKey:@"value"];
         [_recipients addObject:value];
        }
      
    }


   NSLog(@"Phone Numbers: %@",_recipients);
    

    
    
    
    // Please Download Bold at www.applestore.com/bold/
    NSString *message = [NSString stringWithFormat:@"Sign up to your app link!"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:_recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

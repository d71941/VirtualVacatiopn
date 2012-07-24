//
//  VacationPhotosTableViewController.m
//  VirtualVacation
//
//  Created by d71941 on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VacationPhotosTableViewController.h"
#import "VacationHelper.h"
#import "FlickrHelper.h"
#import "Photo.h"

@interface VacationPhotosTableViewController ()
@property (nonatomic, strong) UIManagedDocument *vacation;
@end

@implementation VacationPhotosTableViewController
@synthesize vacation = _vacation;
@synthesize placeName = _placeName;

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"place.name = %@", self.placeName];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [VacationHelper openVacation:DEFAULT_VACATION_NAME usingBlock:^(UIManagedDocument *vacation){
        self.vacation = vacation;
        [self setupFetchedResultsController];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationPhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }    
    // Configure the cell...
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSDictionary *info = [FlickrHelper getInfoForPhoto:[NSKeyedUnarchiver unarchiveObjectWithData:photo.data]];

    cell.textLabel.text = [info valueForKey:@"title"];
    cell.detailTextLabel.text = [info valueForKey:@"subtitle"];
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]) {
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:photo.data];
        [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:data];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

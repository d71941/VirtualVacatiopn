//
//  VacationPlacesTableViewController.m
//  VirtualVacation
//
//  Created by d71941 on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VacationPlacesTableViewController.h"
#import "VacationHelper.h"
#import "Place.h"

@interface VacationPlacesTableViewController ()
@property (nonatomic, strong) UIManagedDocument *vacation;
@end

@implementation VacationPlacesTableViewController
@synthesize vacation = _vacation;


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    // no predicate because we want ALL the Photographers
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacation.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)setVacation:(UIManagedDocument *)vacation
{
    if (vacation != _vacation)
    {
        _vacation = vacation;
        [self setupFetchedResultsController];
    }
}

- (void)viewDidLoad
{
    [VacationHelper openVacation:DEFAULT_VACATION_NAME usingBlock:^(UIManagedDocument *vacation){
        self.vacation = vacation;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationPlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }    
    // Configure the cell...
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [place.photos count]];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setPlaceName:)]) {
        [segue.destinationViewController setTitle:place.name];
        [segue.destinationViewController performSelector:@selector(setPlaceName:) withObject:place.name];
    }
}

@end

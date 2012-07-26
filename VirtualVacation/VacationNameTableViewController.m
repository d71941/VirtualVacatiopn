//
//  VirtualVacationNameTableViewController.m
//  VirtualVacation
//
//  Created by d71941 on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VacationNameTableViewController.h"
#import "VacationSearchTableViewController.h"
#import "VacationHelper.h"

@interface VacationNameTableViewController ()
@property (nonatomic,strong) NSArray *vacationNames;
@end

@implementation VacationNameTableViewController
@synthesize vacationNames = _vacationNames;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.vacationNames = [VacationHelper getVacationNames];
    NSLog(@"%@", self.vacationNames);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vacationNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VacationNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }  
    // Configure the cell...
    cell.textLabel.text = [self.vacationNames objectAtIndex:indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VacationSearch"])
    {
        VacationSearchTableViewController *searchTableViewController = segue.destinationViewController;
        searchTableViewController.vacationName = [self.vacationNames objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
    }
}

@end

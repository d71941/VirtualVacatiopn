//
//  VacationSearchTableViewControllerViewController.m
//  VirtualVacation
//
//  Created by d71941 on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VacationSearchTableViewController.h"
#import "VacationHelper.h"
#import "VacationPlacesTableViewController.h"
#import "VacationTagsTableViewController.h"

@interface VacationSearchTableViewController ()

@end

@implementation VacationSearchTableViewController
@synthesize vacationName = _vacationName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vacationName = DEFAULT_VACATION_NAME;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VacationPlaces"])
    {
        VacationPlacesTableViewController *placesTableViewController = segue.destinationViewController;
        placesTableViewController.vacationName = self.vacationName;
    }
    else if ([segue.identifier isEqualToString:@"VacationTags"])
    {
        VacationTagsTableViewController *tagsTableViewController = segue.destinationViewController;
        tagsTableViewController.vacationName = self.vacationName;        
    }
}

@end

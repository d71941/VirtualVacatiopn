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

- (void)setVacationName:(NSString *)vacationName
{
    if (vacationName != _vacationName)
    {
        _vacationName = vacationName;
        self.title = vacationName;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VacationPlaces"] || [segue.identifier isEqualToString:@"VacationTags"])
    {
        id viewController = segue.destinationViewController;
        
        if ([viewController respondsToSelector:@selector(setVacationName:)])
        {
            [viewController performSelector:@selector(setVacationName:) withObject:self.vacationName];
        }
    }
}

@end

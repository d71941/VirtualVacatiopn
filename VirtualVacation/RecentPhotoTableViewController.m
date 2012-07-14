//
//  recentNavigationController.m
//  TopPlaces
//
//  Created by admin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotoTableViewController.h"


@implementation RecentPhotoTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.dataArray = [prefs objectForKey:@"photos"];
    if(self.dataArray == nil)
    {
        self.dataArray = [[NSArray alloc] init];
    }
    
    [self.tableView reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

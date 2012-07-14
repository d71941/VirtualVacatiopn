//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by admin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "FlickrFetcher.h"
#import "MapViewController.h"

@interface FlickrTableViewController() <MapViewControllerDelegate>
@property (readonly, nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation FlickrTableViewController

@synthesize dataArray = _dataArray;
@synthesize spinner = _spinner;

-(UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}

-(void)didTappedAccessoryControlOfAnnotation:(id <MKAnnotation>)annotation
{
}

- (UIActivityIndicatorView *)spinner
{
    if(!_spinner)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_spinner setColor:[UIColor grayColor]];
    }
    
    return _spinner;
}

-(void)showSpinner:(BOOL) isShow
{
    if (isShow)
    {
        self.tableView.scrollEnabled = NO;
        //NSLog(@"%@", self.tableView.separatorColor);
        //self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.spinner startAnimating];
    }
    else
    {
        self.tableView.scrollEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //self.tableView.separatorColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        [self.spinner stopAnimating];
    }
}

-(void)setDataArray:(NSArray *)dataArray
{
    if(_dataArray != dataArray)
    {
        _dataArray = dataArray;
        [self showSpinner:NO];
        [self.tableView reloadData];
    }
}

- (NSDictionary *)getDataForRow:(NSInteger)row
{
    return nil;
}

- (NSArray *)mapAnnotations
{
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowMap"])
    {
        MapViewController *mvc = [segue destinationViewController];
        mvc.delegate = self;
        mvc.annotations = [self mapAnnotations];
        return;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.view addSubview:self.spinner];
    [self showSpinner:(self.dataArray==NULL)];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.spinner.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [[self getDataForRow:indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [[self getDataForRow:indexPath.row] valueForKey:@"subtitle"];

    return cell;
}
@end

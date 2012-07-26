//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by admin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrAnnotation.h"
#import "FlickrHelper.h"
#import "MapViewController.h"

@interface TopPlacesTableViewController() <MapViewControllerDelegate>
@end

@implementation TopPlacesTableViewController 
//@synthesize dataArray = _dataArray;

-(UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}

-(void)didTappedAccessoryControlOfAnnotation:(id <MKAnnotation>)annotation
{
    [self performSegueWithIdentifier:@"ShowPhotos" sender: annotation];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.spinner startAnimating];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *places = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = places;
        });
    });
    dispatch_release(downloadQueue);
    //self.dataArray = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]]];
}
-(NSDictionary *)getInfoForRow:(NSInteger)row
{
    return [FlickrHelper getInfoForPlace:[self.dataArray objectAtIndex:row]];
}
- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.dataArray count]];
    for (NSDictionary *place in self.dataArray) {
        [annotations addObject:[FlickrAnnotation annotationForPlace:place]];
    }
    return annotations;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];

    if([segue.identifier isEqualToString:@"ShowPhotos"])
    {   
        NSDictionary *place;
        FlickrTableViewController *flickrTableViewController = [segue destinationViewController];
        
        if([sender isKindOfClass:[UITableViewCell class]])
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            place = [self.dataArray objectAtIndex:indexPath.row];
        }
        else if([sender isKindOfClass:[FlickrAnnotation class]])
        {
            place = [sender place];
        }
        
        flickrTableViewController.title = [[FlickrHelper getInfoForPlace:place] objectForKey:@"title"];
        //[flickrTableViewController.spinner startAnimating];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:50];
            dispatch_async(dispatch_get_main_queue(), ^{
                flickrTableViewController.dataArray = photos;
            });
        });
        dispatch_release(downloadQueue);
        return;
    }
}

@end

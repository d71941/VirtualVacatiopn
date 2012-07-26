//
//  PhotoTableViewController.m
//  TopPlaces
//
//  Created by admin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "PhotoScrollViewController.h"
#import "FlickrFetcher.h"
#import "FlickrAnnotation.h"
#import "FlickrHelper.h"
#import "MapViewController.h"
#import "FlickrImageCache.h"
#import "VacationHelper.h"

@interface PhotoTableViewController() <MapViewControllerDelegate>
@end

@implementation PhotoTableViewController

-(UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    FlickrAnnotation *fa = (FlickrAnnotation *)annotation;
    FlickrImageCache *imageCache = [[FlickrImageCache alloc] init];
    UIImage* image;
    
    image = [imageCache getImageFromCacheWithIdentifier:[[fa.photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".small"]];
    
    if(!image)
    {
        NSURL *url = [FlickrFetcher urlForPhoto:fa.photo format:FlickrPhotoFormatSquare];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [imageCache addImageToCache:image withIdentifier: [[fa.photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".small"]];
    }
    return image;
}

-(void)didTappedAccessoryControlOfAnnotation:(id<MKAnnotation>)annotation
{
    FlickrAnnotation *flickrAnnotation = annotation;
    
    NSDictionary *photo = flickrAnnotation.photo;
    [self showPhoto:photo];
}

-(NSDictionary *)getInfoForRow:(NSInteger)row
{
    return [FlickrHelper getInfoForPhoto:[self.dataArray objectAtIndex:row]];
}

-(void)showPhoto:(NSDictionary *)photo
{
    if (self.splitViewController)
    {
        UINavigationController *navigationController = [self.splitViewController.childViewControllers objectAtIndex:1];
        PhotoScrollViewController *photoScrollViewController = (PhotoScrollViewController *)[navigationController visibleViewController];
        //PhotoScrollViewController *photoScrollViewController = [self.splitViewController.childViewControllers objectAtIndex:1];
        [self prepareImageForPhotoScrollViewController:photoScrollViewController withPhoto:photo];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowImage" sender: photo];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = [self.dataArray objectAtIndex:indexPath.row];
    [self showPhoto:photo];
    
}
- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.dataArray count]];
    for (NSDictionary *photo in self.dataArray) {
        [annotations addObject:[FlickrAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}
-(void)prepareImageForPhotoScrollViewController:(PhotoScrollViewController *)photoScrollViewController withPhoto:(NSDictionary *)photo
{
    photoScrollViewController.photo = photo;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"ShowImage"]){
        NSDictionary *photo = sender;
        PhotoScrollViewController *photoScrollViewController = [segue destinationViewController];
        photoScrollViewController.vacationName = DEFAULT_VACATION_NAME;
        
        [self prepareImageForPhotoScrollViewController:photoScrollViewController withPhoto:photo];
    }

    //NSLog(@"%@\n",photo);
}
@end


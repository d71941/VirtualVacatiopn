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
#import "MapViewController.h"
#import "FlickrImageCache.h"

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


+(NSDictionary *)getDataForPhoto:(NSDictionary *)photo
{
    NSString *title, *subtitle;
    
    if ([[photo valueForKey:FLICKR_PHOTO_TITLE] length])
    {
        title = [photo valueForKey:FLICKR_PHOTO_TITLE];
    }
    else if([[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] length])
    {
        title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    else
    {
        title = @"Unknown";
    }
    
    subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",subtitle,@"subtitle",nil];
}

-(NSDictionary *)getDataForRow:(NSInteger)row
{
    return [PhotoTableViewController getDataForPhoto:[self.dataArray objectAtIndex:row]];
}

-(void)storePhotoToRecent:(NSDictionary *)photo
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *discardedItems = [NSMutableArray array];
    NSMutableArray *photoArray = [[prefs objectForKey:@"photos"] mutableCopy];
    
    if (photoArray == nil)
    {
        photoArray = [[NSMutableArray alloc]  init];
    }
    
    for (NSDictionary *oldPhoto in photoArray)
    {
        if ([[photo valueForKey:FLICKR_PHOTO_ID] isEqual:[oldPhoto valueForKey:FLICKR_PHOTO_ID]])
        {
            [discardedItems addObject:oldPhoto];
            break;
        }
    }

    [photoArray removeObjectsInArray:discardedItems];
    [photoArray insertObject:photo atIndex:0];
    
    [prefs setObject:photoArray forKey:@"photos"];
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
    [self storePhotoToRecent:photo];
    photoScrollViewController.photo = photo;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"ShowImage"]){
        NSDictionary *photo = sender;
        PhotoScrollViewController *photoScrollViewController = [segue destinationViewController];
        
        [self prepareImageForPhotoScrollViewController:photoScrollViewController withPhoto:photo];
    }

    //NSLog(@"%@\n",photo);
}
@end

//
//  FlickrAnnotation.m
//  TopPlaces
//
//  Created by admin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrAnnotation.h"
#import "FlickrFetcher.h"
#import "FlickrHelper.h"

@implementation FlickrAnnotation
@synthesize photo = _photo;
@synthesize place = _place;

+ (FlickrAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrAnnotation *annotation = [[FlickrAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

+ (FlickrAnnotation *)annotationForPlace:(NSDictionary *)place
{
    FlickrAnnotation *annotation = [[FlickrAnnotation alloc] init];
    annotation.place = place;
    return annotation;    
}


#pragma mark - MKAnnotation

- (NSString *)title
{
    NSString *title;

    if(self.photo)
    {
        title = [[FlickrHelper getInfoForPhoto:self.photo] objectForKey:@"title"];
    }
    else if (self.place)
    {
        title = [[FlickrHelper getInfoForPlace:self.place] objectForKey:@"title"];
    }
    
    return title;
}

- (NSString *)subtitle
{
    NSString *subtitle;
    
    if(self.photo)
    {
        subtitle = [[FlickrHelper getInfoForPhoto:self.photo] objectForKey:@"subtitle"];
    }
    else if (self.place)
    {
        subtitle = [[FlickrHelper getInfoForPlace:self.place] objectForKey:@"subtitle"];
    }
    
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    NSDictionary *data;
    
    if(self.photo)
    {
        data = self.photo;
    }
    else if(self.place)
    {
        data = self.place;
    }
    
    coordinate.latitude = [[data objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[data objectForKey:FLICKR_LONGITUDE] doubleValue];

    return coordinate;
}

@end


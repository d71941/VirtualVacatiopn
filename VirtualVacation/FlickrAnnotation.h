//
//  FlickrAnnotation.h
//  TopPlaces
//
//  Created by admin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FlickrAnnotation : NSObject <MKAnnotation>
@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) NSDictionary *place;

+ (FlickrAnnotation *)annotationForPhoto:(NSDictionary *)photo;
+ (FlickrAnnotation *)annotationForPlace:(NSDictionary *)place;

@end

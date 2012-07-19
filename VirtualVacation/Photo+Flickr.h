//
//  Photo+Flickr.h
//  VirtualVacation
//
//  Created by d71941 on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photo *)getPhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deletePhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;
@end

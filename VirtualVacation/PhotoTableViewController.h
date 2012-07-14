//
//  PhotoTableViewController.h
//  TopPlaces
//
//  Created by admin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrTableViewController.h"

@interface PhotoTableViewController : FlickrTableViewController
+(NSDictionary *)getDataForPhoto:(NSDictionary *)photo;
@end

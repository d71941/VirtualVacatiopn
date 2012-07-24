//
//  FlickrHelper.m
//  VirtualVacation
//
//  Created by d71941 on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrHelper.h"
#import "FlickrFetcher.h"

@implementation FlickrHelper
+(NSDictionary *)getInfoForPhoto:(NSDictionary *)photo
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

+(NSDictionary *)getInfoForPlace:(NSDictionary *)place
{
    NSString *content = [place valueForKey:FLICKR_PLACE_NAME];
    NSString *title = [[content componentsSeparatedByString:@", "] objectAtIndex:0];
    NSString *subtitle = [content substringFromIndex:[title length]+2];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",subtitle,@"subtitle",nil];
}


@end

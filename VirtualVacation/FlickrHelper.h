//
//  FlickrHelper.h
//  VirtualVacation
//
//  Created by d71941 on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrHelper : NSObject
+(NSDictionary *)getInfoForPhoto:(NSDictionary *)photo;
+(NSDictionary *)getInfoForPlace:(NSDictionary *)place;
@end

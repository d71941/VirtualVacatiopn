//
//  FlickrImageCache.h
//  TopPlaces
//
//  Created by admin on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrImageCache : NSObject
- (void)addImageToCache:(UIImage *)image withIdentifier:(NSString *)identifier;
- (UIImage *)getImageFromCacheWithIdentifier:(NSString *)identifier;
@end

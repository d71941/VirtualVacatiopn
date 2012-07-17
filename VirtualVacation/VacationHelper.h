//
//  VacationHelper.h
//  VirtualVacation
//
//  Created by d71941 on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completion_block_t)(UIManagedDocument *vacation);

@interface VacationHelper : NSObject
+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock;
@end

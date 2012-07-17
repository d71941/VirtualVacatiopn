//
//  VacationHelper.m
//  VirtualVacation
//
//  Created by d71941 on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VacationHelper.h"

#define VACATIONS_PATH @"Vavations"

static NSMutableDictionary *vacationsForName;

@implementation VacationHelper
+ (void)addVacation:(UIManagedDocument *)vacation withName:(NSString *)vacationName
{
    if(!vacationsForName)
    {
        vacationsForName = [[NSMutableDictionary alloc] init];
    }

    [vacationsForName setObject:vacation forKey:vacationName];
}

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    UIManagedDocument *vacation = [vacationsForName objectForKey:vacationName];

    if(!vacation)
    {
        NSURL *url = [[[fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:VACATIONS_PATH];
        url = [url URLByAppendingPathComponent:vacationName];

        vacation = [[UIManagedDocument alloc] initWithFileURL:url];
        [self addVacation:vacation withName:vacationName];
    }
    
    if (![fileMgr fileExistsAtPath:[vacation.fileURL path]])
    {
        [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success)
            {
                completionBlock(vacation);
            }
        }];
    }
    else if(vacation.documentState == UIDocumentStateClosed)
    {
        [vacation openWithCompletionHandler:^(BOOL success){
            completionBlock(vacation);
        }];
    }
    else if(vacation.documentState == UIDocumentStateNormal)
    {
        completionBlock(vacation);
    }
}
@end

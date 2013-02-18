//
//  ANEZipUtilContextData.m
//  ANEZipFile
//
//  Created by Pedro Casaubon on 15/02/13.
//  Copyright (c) 2013 xperiments. All rights reserved.
//

#import "ANEZipUtilContextData.h"
#import "ANEZipFileDelegate.h"

@implementation ANEZipUtilContextData


- (id)initWithContext:(FREContext)context
{
    self = [super init];
    if (self) {
        // init delegate
        self->delegate = [[ANEZipFileDelegate alloc] initWithContext:context ];
        self->bytearrayUnzip = nil;
        
    }
    return self;
}

@end

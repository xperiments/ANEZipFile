//
//  ANEZipUtilContextData.h
//  ANEZipFile
//
//  Created by Pedro Casaubon on 15/02/13.
//  Copyright (c) 2013 xperiments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANEZipFileDelegate.h"

@interface ANEZipUtilContextData : NSObject
{
@public
    
    ANEZipFileDelegate* delegate;
    NSMutableData* bytearrayUnzip;
}

- (id)initWithContext:(FREContext)context;
@end


//
//  ANEZipFileSSArchive.m
//  ANEZipFile
//
//  Created by Pedro Casaubon on 10/02/13.
//  Copyright (c) 2013 xperiments. All rights reserved.
//

#import "ANEZipFileDelegate.h"
#import "FlashRuntimeExtensions.h"
#import "ANEZipFileEventMessages.h"

#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)

@implementation ANEZipFileDelegate

- (id)initWithContext:(FREContext)context
{
    self = [super init];
    if (self)
    {
        ctx = context;
    }
    return self;
}

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo
{
    DISPATCH_STATUS_EVENT( ctx, UNZIP_START, (const uint8_t*)"" );
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {    
    NSString* info = [NSString stringWithFormat:@"{\"source\":\"%@\",\"destination\":\"%@\"}", path ,unzippedPath ];
    DISPATCH_STATUS_EVENT( ctx, UNZIP_END, (const uint8_t*)[info UTF8String] );
}

- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo {
    NSString* info = [NSString stringWithFormat:@"{\"current\":\"%d\",\"total\":\"%d\",\"path\":\"%@\"}", fileIndex+1, totalFiles, archivePath ];
    DISPATCH_STATUS_EVENT( ctx, UNZIP_PROGRESS, (const uint8_t*)[info UTF8String] );

}

- (void)zipArchiveWillZipArchiveAtPath:(NSString *)path
{
    NSString* info = [NSString stringWithFormat:@"{\"path\":\"%@\"}", path ];
    DISPATCH_STATUS_EVENT( ctx, ZIP_START, (const uint8_t*)[info UTF8String] );
}

- (void)zipArchiveDidZipArchiveAtPath:(NSString *)path withSuccess:(BOOL)success
{
    NSString* info = [NSString stringWithFormat:@"{\"path\":\"%@\",\"success\":\"%d\"}", path, success ];
    DISPATCH_STATUS_EVENT( ctx, ZIP_END, (const uint8_t*)[info UTF8String] );
}

- (void)zipArchiveDidProgress:(int)current on:(int)total
{
    NSString* info = [NSString stringWithFormat:@"{\"current\":\"%d\",\"total\":\"%d\"}", current, total ];
    DISPATCH_STATUS_EVENT( ctx, ZIP_PROGRESS, (const uint8_t*)[info UTF8String] );

}

@end

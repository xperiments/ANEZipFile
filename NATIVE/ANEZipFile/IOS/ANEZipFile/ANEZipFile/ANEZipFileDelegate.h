//
//  ANEZipFileSSArchive.h
//  ANEZipFile
//
//  Created by Pedro Casaubon on 10/02/13.
//  Copyright (c) 2013 xperiments. All rights reserved.
//

#import "SSZipArchive.h"
#import "FlashRuntimeExtensions.h"

@interface ANEZipFileDelegate : NSObject <SSZipArchiveDelegate>
{
@public
    FREContext ctx;
}

- (id)initWithContext:(FREContext)context;

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo;
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath;

//- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;


- (void)zipArchiveWillZipArchiveAtPath:(NSString *)path;
- (void)zipArchiveDidZipArchiveAtPath:(NSString *)path withSuccess:(BOOL)success;
- (void)zipArchiveDidProgress:(int)current on:(int)total;


@end

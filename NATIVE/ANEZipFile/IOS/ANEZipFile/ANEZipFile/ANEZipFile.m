//
//  ANEZipFile.m
//  ANEZipFile
//
//  Created by ANEBridgeCreator on 10/02/2013.
//  Copyright (c)2013 Pedro Casaubon. All rights reserved.
//
#import "FRETypeUtils.h"
#import "FlashRuntimeExtensions.h"
#import "ANEZipFileDelegate.h"
#import "ANEZipFileEventMessages.h"
#import "ANEZipUtilContextData.h"
#import "ANEZipFileContextData.h"


#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

/* CONTEXT DATA HELPERS */
ANEZipUtilContextData* getZipUtilContextData( FREContext ctx )
{
    ANEZipUtilContextData *contextData;
    FREGetContextNativeData(ctx, (void**) &contextData);
    return contextData;
}

ANEZipFileContextData* getZipFileContextData( FREContext ctx )
{
    ANEZipFileContextData *contextData;
    FREGetContextNativeData(ctx, (void**) &contextData);
    return contextData;
}


/****************************************************************************************
 *	ANEFileZip Methods																	*
 ****************************************************************************************/

/* ANEFileZip -> INIT ZIP FILE LOCATION */
DEFINE_ANE_FUNCTION( initWithPath )
{
    
    ANEZipFileContextData *contextData = [[[ANEZipFileContextData alloc] init ] autorelease];

	NSString *path = nil;
    FREGetObjectAsString(argv[0], &path);
    contextData->zipFile = [[SSZipArchive alloc] initWithPath:path];
    
    FRESetContextNativeData(context, contextData);
    
	return NULL;
}

/* ANEFileZip -> OPEN ZIP FILE FOR CREATE NEW ZIP*/
DEFINE_ANE_FUNCTION( openMethod )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
    
	uint32_t resultFromBoolean= [contextData->zipFile open];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
}

/* ANEFileZip -> OPEN ZIP FILE FOR APPENING DATA */
DEFINE_ANE_FUNCTION( openForAppendMethod )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
    
	uint32_t resultFromBoolean= [contextData->zipFile openForAppend];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
}

/* ANEFileZip -> CLOSE ZIP FILE */
DEFINE_ANE_FUNCTION( closeMethod )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
    
	uint32_t resultFromBoolean= [contextData->zipFile close];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
}

/* ANEFileZip -> WRITE BYTEARRAY TO ZIP */
DEFINE_ANE_FUNCTION( writeData )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
    
    FREObject objectByteArray = argv[ 0 ];
    FREByteArray byteArray;
    NSString *fileName = nil;
    
    FREAcquireByteArray( objectByteArray, &byteArray );
    FREReleaseByteArray( objectByteArray );
    
    FREGetObjectAsString(argv[1], &fileName);
	
	uint32_t resultFromBoolean= [contextData->zipFile writeData:[NSData dataWithBytes:byteArray.bytes length:byteArray.length ] filename:fileName ];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
    
	return ane_resultFromBoolean;
    
}

/* ANEFileZip -> WRITE BYTEARRAY TO ZIP ASYNC*/
DEFINE_ANE_FUNCTION( writeDataAsync )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
	
    FREObject objectByteArray = argv[ 0 ];
    FREByteArray byteArray;
    NSString *fileName = nil;
    
    FREAcquireByteArray( objectByteArray, &byteArray );
    FREReleaseByteArray( objectByteArray );
    
    FREGetObjectAsString(argv[1], &fileName);
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [contextData->zipFile writeData:[NSData dataWithBytes:byteArray.bytes length:byteArray.length ] filename:fileName ];
        DISPATCH_STATUS_EVENT( context, ZIP_WRITE_BYTES, (uint8_t*)"" );
    });
    
	return NULL;
    
}

/* ANEFileZip -> WRITE FILE TO ZIP */
DEFINE_ANE_FUNCTION( writeFile )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
    
	NSString *path = nil;
	
    FREGetObjectAsString( argv[0], &path );
    
	uint32_t resultFromBoolean=[contextData->zipFile writeFile:path];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
	return ane_resultFromBoolean;
    
}

/* ANEFileZip -> WRITE FILE TO ZIP ASYNC*/
DEFINE_ANE_FUNCTION( writeFileAsync )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
    
	NSString *path = nil;
	
    FREGetObjectAsString( argv[0], &path );
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [contextData->zipFile writeFile:path];
        DISPATCH_STATUS_EVENT( context, ZIP_WRITE_FILE, (uint8_t*)"" );
    });
    return NULL;
    
}

/* ANEFileZip -> WRITE FILE TO ZIP SPECIFYING DESTINATION FILE */
DEFINE_ANE_FUNCTION( writeFileAtPath )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
	
	NSString *path = nil;
	NSString *filePath = nil;
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &filePath );
	
	uint32_t resultFromBoolean=[contextData->zipFile writeFileAtPath:path filePath:filePath];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
	return ane_resultFromBoolean;
    
}

/* ANEFileZip -> WRITE FILE TO ZIP ASYNC SPECIFYING DESTINATION FILE */
DEFINE_ANE_FUNCTION( writeFileAtPathAsync )
{
    ANEZipFileContextData* contextData = getZipFileContextData( context );
	
	NSString *path = nil;
	NSString *filePath = nil;
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &filePath );
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [contextData->zipFile writeFileAtPath:path filePath:filePath ];
        DISPATCH_STATUS_EVENT( context, ZIP_WRITE_FILE, (uint8_t*)"" );
    });
	
	return NULL;
    
}


/****************************************************************************************
 *	ANEZipUtils Methods																	*
 ****************************************************************************************/



/* ANEZipUtils --> EXTRACT SINGLE FILE FROM ZIP */
DEFINE_ANE_FUNCTION( extractFile )
{
	
	NSString *path = nil;
	NSString *filePath = nil;
    NSString *password = nil;
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &filePath );
    FREGetObjectAsString( argv[2], &password );
    
    NSMutableData* fileData = [SSZipArchive unzipFileFrom:path withName:filePath password:password];
    
    
    FREObject length = NULL;
    FRENewObjectFromUint32([fileData length], &length);
    FRESetObjectProperty(argv[3], (const uint8_t*) "length", length, NULL);
    
    
    FREObject objectBA = argv[3];
    FREByteArray baData;
    FREAcquireByteArray(objectBA, &baData);
    uint8_t *ba = baData.bytes;
    
    memcpy(ba, [fileData bytes], [fileData length]);
    
    FREReleaseByteArray(objectBA);
    
    
	return NULL;
    
}


/* ANEZipUtils --> EXTRACT SINGLE FILE FROM ZIP ASYNC */
DEFINE_ANE_FUNCTION( extractFileAsync )
{
    ANEZipUtilContextData* contextData = getZipUtilContextData( context );
	
	NSString *path = nil;
	NSString *filePath = nil;
    NSString *password = nil;
    
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &filePath );
    FREGetObjectAsString( argv[2], &password );
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        contextData->bytearrayUnzip = [[NSMutableData alloc] initWithData:[SSZipArchive unzipFileFrom:path withName:filePath password:password] ];
        DISPATCH_STATUS_EVENT( context, UNZIP_FILE_BYTES, (uint8_t*)"" );
        
    });
    
	return NULL;
}

/* ANEZipUtils --> CALLED FROM AS3 TO RETRIEVE THE EXTRACTED FILE CONTENT */
DEFINE_ANE_FUNCTION( extractFileAsyncResult )
{
    ANEZipUtilContextData* contextData = getZipUtilContextData( context );
    
    FRESetObjectPropertyUint(argv[0], (const uint8_t*) "length", [contextData->bytearrayUnzip length]);
    
    FREObject objectBA = argv[0];
    FREByteArray baData;
    FREAcquireByteArray(objectBA, &baData);
    uint8_t *ba = baData.bytes;
    
    memcpy(ba, [contextData->bytearrayUnzip bytes], [contextData->bytearrayUnzip length]);
    
    FREReleaseByteArray(objectBA);
    
    [contextData->bytearrayUnzip setLength:0];
    
	return NULL;
    
}


/* ANEZipUtils --> GET FILES IN ZIP */
DEFINE_ANE_FUNCTION( getFilesInZip )
{
    
	NSString *path = nil;
    NSString *password = nil;
    NSString* outputString = nil;
    NSMutableArray* outputArray = nil;
    FREObject retStr;
    
    FREGetObjectAsString(argv[0], &path );
    FREGetObjectAsString(argv[1], &password );
    
    outputArray = [SSZipArchive getFilesInZip:path password:password];
    if( outputArray != NULL && [outputArray count] > 0 )
    {
        outputString = [ outputArray componentsJoinedByString:@","];
    }
    else
    {
        outputString = @"-1";
    }
    
    FRENewObjectFromString( outputString, &retStr );
    
	return retStr;
    
}


/* ANEZipUtils --> ZIP FILES */
DEFINE_ANE_FUNCTION( zipFiles )
{
    ANEZipUtilContextData* contextData = getZipUtilContextData( context );
    
	NSString *path = nil;
	NSString *withFilesAtPaths = nil;
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &withFilesAtPaths );
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [SSZipArchive createZipFileAtPath:path withFilesAtPaths:[withFilesAtPaths componentsSeparatedByString:@","] andDelegate:contextData->delegate];
    });
    
    return NULL;
    
    
}

/* ANEZipUtils --> ZIP FILES SPECIFYING DESTINATION PATHS */
DEFINE_ANE_FUNCTION( zipFilesWithPaths )
{
    ANEZipUtilContextData* contextData = getZipUtilContextData( context );
    
	NSString *path = nil;
	NSString *withFilesAtPaths = nil;
    NSString *toFilesAtPaths = nil;
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &withFilesAtPaths );
    FREGetObjectAsString( argv[2], &toFilesAtPaths );
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [SSZipArchive createZipFileAtPath:path withFilesAtPaths:[withFilesAtPaths componentsSeparatedByString:@","] atPaths:[toFilesAtPaths componentsSeparatedByString:@","] andDelegate:contextData->delegate];
    });
    
    return NULL;
    
    
}


/* ANEZipUtils --> UNZIP */
DEFINE_ANE_FUNCTION( unzip )
{
    
    
    ANEZipUtilContextData* contextData = getZipUtilContextData( context );
    
    
	NSString *path = nil;
	NSString *destination = nil;
    NSString *password = nil;
    
    FREGetObjectAsString( argv[0], &path );
    FREGetObjectAsString( argv[1], &destination );
    FREGetObjectAsString( argv[3], &password );
    
	uint32_t overwrite_C;
	if( FREGetObjectAsBool(argv[2], &overwrite_C) != FRE_OK ) return NULL;
	
    if( [password length]==0 )
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:@"" error:nil delegate:contextData->delegate ];
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:password error:nil delegate:contextData->delegate ];
        });
        
    }
	return NULL;
}


/* ANEZipUtils --> UNZIP */
/*
 DEFINE_ANE_FUNCTION( newunzip )
 {
 
 
 
 NSString *path = nil;
 NSString *destination = nil;
 NSString *password = nil;
 
 FREGetObjectAsString( argv[0], &path );
 FREGetObjectAsString( argv[1], &destination );
 FREGetObjectAsString( argv[3], &password );
 
 uint32_t overwrite_C;
 if( FREGetObjectAsBool(argv[2], &overwrite_C) != FRE_OK ) return NULL;
 
 ANESSZipArchive *newdelegate;
 FREGetContextNativeData(context, (void**) &newdelegate);
 
 if( [password length]==0 )
 {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 BOOL result = [newdelegate unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:@""];
 });
 }
 else
 {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 BOOL result = [newdelegate unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:password];
 });
 
 }
 return NULL;
 }
 */

/* ANEZipUtils --> UNZIP */
DEFINE_ANE_FUNCTION( isPasswordProtected )
{
	NSString *path = nil;
    
    FREGetObjectAsString( argv[0], &path );
    
	uint32_t resultFromBoolean = [SSZipArchive isPasswordProtected:path];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
    
}



/****************************************************************************************
 *	EXTENSION & CONTEXT																	*
 ****************************************************************************************/


FRENamedFunction ANEZipUtilsFunctions [] = {
    
    MAP_FUNCTION( extractFile, NULL ),
    MAP_FUNCTION( extractFileAsync, NULL ),
    MAP_FUNCTION( extractFileAsyncResult, NULL ),
    MAP_FUNCTION( getFilesInZip, NULL ),
    MAP_FUNCTION( isPasswordProtected, NULL ),
    MAP_FUNCTION( unzip, NULL ),
    MAP_FUNCTION( zipFilesWithPaths, NULL ),
    MAP_FUNCTION( zipFiles, NULL )
    
};

FRENamedFunction ANEZipFileFunctions [] = {
    MAP_FUNCTION( closeMethod ,NULL ),
    MAP_FUNCTION( initWithPath ,NULL ),
    MAP_FUNCTION( openMethod ,NULL ),
    MAP_FUNCTION( openForAppendMethod ,NULL ),
    MAP_FUNCTION( writeData ,NULL ),
    MAP_FUNCTION( writeDataAsync ,NULL ),
    MAP_FUNCTION( writeFile ,NULL ),
    MAP_FUNCTION( writeFileAtPath ,NULL ),
    MAP_FUNCTION( writeFileAsync ,NULL ),
    MAP_FUNCTION( writeFileAtPathAsync ,NULL )
};



void ANEZipFileContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    NSLog(@"Entering ANEZipFileContextInitializer()");
    if ( 0 == strcmp( (const char*) ctxType, "ANEZipUtils" ) )
    {
        *numFunctionsToSet = sizeof( ANEZipUtilsFunctions ) / sizeof( FRENamedFunction );
        *functionsToSet = ANEZipUtilsFunctions;
        
        ANEZipUtilContextData *zipUtilContextData = [[[ANEZipUtilContextData alloc] initWithContext:ctx] autorelease];
        FRESetContextNativeData(ctx, zipUtilContextData);
        
    }
    else
    {
        *numFunctionsToSet = sizeof( ANEZipFileFunctions ) / sizeof( FRENamedFunction );
        *functionsToSet = ANEZipFileFunctions;
        
        //ANEZipFileContextData *zipFileContextData = [[[ANEZipFileContextData alloc] init ] autorelease];
        //FRESetContextNativeData(ctx, zipFileContextData);
    }
    NSLog(@"Exiting ANEZipFileContextInitializer()");

    
}
void ANEZipFileContextFinalizer( FREContext ctx )
{
	NSLog(@"Entering ANEZipFileContextFinalizer()");
    

    
    
    
	NSLog(@"Exiting ANEZipFileContextFinalizer()");
	return;
}
void ANEZipFileExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
	NSLog(@"Entering ANEZipFileExtensionInitializer()");
    
    
	extDataToSet = NULL;  // This example does not use any extension data.
	*ctxInitializerToSet = &ANEZipFileContextInitializer;
	*ctxFinalizerToSet = &ANEZipFileContextFinalizer;
}
void ANEZipFileExtensionFinalizer()
{
	NSLog(@"Entering ANEZipFileExtensionFinalizer()");
	return;
}





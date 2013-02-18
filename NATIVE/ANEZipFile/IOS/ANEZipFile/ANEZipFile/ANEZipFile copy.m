//
//  ANEZipFile.m
//  ANEZipFile
//
//  Created by ANEBridgeCreator on 10/02/2013.
//  Copyright (c)2013 ANEBridgeCreator. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "ZipFileDelegate.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

#define ASSERT_ARGC_IS(fn_name, required)																	\
if(argc != (required))																						\
{																											\
DISPATCH_INTERNAL_ERROR(context, #fn_name ": Wrong number of arguments. Expected exactly " #required);	\
return NULL;																							\
}
#define ASSERT_ARGC_AT_LEAST(fn_name, required)																\
if(argc < (required))																						\
{																											\
DISPATCH_INTERNAL_ERROR(context, #fn_name ": Wrong number of arguments. Expected at least " #required);	\
return NULL;																							\
}


SSZipArchive* zipFile;
ZipFileDelegate* delegate;
NSMutableData *bytearrayUnzip;


/* INSTANCE METHODS */
DEFINE_ANE_FUNCTION( initWithPath )
{
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
    zipFile = [[SSZipArchive alloc] initWithPath:path];
	return NULL;
}


DEFINE_ANE_FUNCTION( openMethod )
{
	uint32_t resultFromBoolean= [zipFile open];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
}

DEFINE_ANE_FUNCTION( openForAppendMethod )
{
	uint32_t resultFromBoolean= [zipFile openForAppend];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
}

DEFINE_ANE_FUNCTION( closeMethod )
{
	uint32_t resultFromBoolean= [zipFile close];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	return ane_resultFromBoolean;
}

DEFINE_ANE_FUNCTION( writeFile )
{

	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	uint32_t resultFromBoolean=[zipFile writeFile:path];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
	return ane_resultFromBoolean;
    
}

DEFINE_ANE_FUNCTION( writeFileAsync )
{
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [zipFile writeFile:path];
    });
    
    return NULL;
    
}





/*
DEFINE_ANE_FUNCTION( unzipFile )
{
    NSError* error;
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
    
	//  destination:String = argument[1];
    
	uint32_t destinationLength;
	const uint8_t *destination_CString;
	FREGetObjectAsUTF8(argv[1], &destinationLength, &destination_CString);
	NSString *destination = [NSString stringWithUTF8String:(char*)destination_CString];
	
    
	//  overwrite:Boolean = argument[2];
    
	uint32_t overwrite_C;
	if( FREGetObjectAsBool(argv[2], &overwrite_C) != FRE_OK ) return NULL;
	
    
	//  password:String = argument[3];
    
	uint32_t passwordLength;
	const uint8_t *password_CString;
	FREGetObjectAsUTF8(argv[3], &passwordLength, &password_CString);
	NSString *password = [NSString stringWithUTF8String:(char*)password_CString];
	
    
    
	//  return->as3 ( resultFromBoolean as Boolean );
	uint32_t resultFromBoolean;
    if( passwordLength==0 )
    {
        resultFromBoolean = [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:@"" error:&error delegate:delegate ];
    }
    else
    {
        resultFromBoolean = [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:password error:&error delegate:delegate ];
    }
    

	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
	return ane_resultFromBoolean;
    
}*/




/****************************************************************************************
 * @method:writeData( data:ByteArray,fileName:String):Boolean
 ****************************************************************************************/
DEFINE_ANE_FUNCTION( writeData )
{
	
    FREObject objectByteArray = argv[ 0 ];
    FREByteArray byteArray;
    FREAcquireByteArray( objectByteArray, &byteArray );
    FREReleaseByteArray( objectByteArray );
    
	uint32_t fileNameLength;
	const uint8_t *fileName_CString;
	FREGetObjectAsUTF8(argv[1], &fileNameLength, &fileName_CString);
	NSString *fileName = [NSString stringWithUTF8String:(char*)fileName_CString];
	
    
    
	//  return->as3 ( resultFromBoolean as Boolean );
	uint32_t resultFromBoolean= [zipFile writeData:[NSData dataWithBytes:byteArray.bytes length:byteArray.length ] filename:fileName ];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
    
	return ane_resultFromBoolean;
    
}



/****************************************************************************************
 * @method:writeFile( path:String):Boolean
 ****************************************************************************************/
DEFINE_ANE_FUNCTION( writeFileAtPath )
{
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	//  filePath:String = argument[0];
    
	uint32_t filePathLength;
	const uint8_t *filePath_CString;
	FREGetObjectAsUTF8(argv[1], &filePathLength, &filePath_CString);
	NSString *filePath = [NSString stringWithUTF8String:(char*)filePath_CString];
    
	//  return->as3 ( resultFromBoolean as Boolean );
	uint32_t resultFromBoolean=[zipFile writeFileAtPath:path filePath:filePath];
	FREObject ane_resultFromBoolean= nil;
	FRENewObjectFromBool(resultFromBoolean, &ane_resultFromBoolean);
	
	return ane_resultFromBoolean;
    
}
/****************************************************************************************
 * @method:writeFile( path:String):Boolean
 ****************************************************************************************/
DEFINE_ANE_FUNCTION( writeFileAtPathAsync )
{
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	//  filePath:String = argument[0];
    
	uint32_t filePathLength;
	const uint8_t *filePath_CString;
	FREGetObjectAsUTF8(argv[1], &filePathLength, &filePath_CString);
	NSString *filePath = [NSString stringWithUTF8String:(char*)filePath_CString];
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [zipFile writeFileAtPath:path filePath:filePath ];
    });
	
	return NULL;
    
}

DEFINE_ANE_FUNCTION( unzipFileFrom )
{
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	//  filePath:String = argument[0];
    
	uint32_t filePathLength;
	const uint8_t *filePath_CString;
	FREGetObjectAsUTF8(argv[1], &filePathLength, &filePath_CString);
	NSString *filePath = [NSString stringWithUTF8String:(char*)filePath_CString];
    

    NSMutableData* fileData = [SSZipArchive unzipFileFrom:path withName:filePath];
    
    
    FREObject length = NULL;
    FRENewObjectFromUint32([fileData length], &length);
    FRESetObjectProperty(argv[2], (const uint8_t*) "length", length, NULL);
    
    
    FREObject objectBA = argv[2];
    FREByteArray baData;
    FREAcquireByteArray(objectBA, &baData);
    uint8_t *ba = baData.bytes;
    
    memcpy(ba, [fileData bytes], [fileData length]);
    
    FREReleaseByteArray(objectBA);


	return NULL;
    
}


void setData( NSMutableData* data, FREContext context )
{
    bytearrayUnzip = [[NSMutableData alloc] initWithData:data];
    NSString* uu = [[NSString alloc] initWithFormat:@"{\"data\":%d}", [bytearrayUnzip length]];
    FREDispatchStatusEventAsync(context, (const uint8_t*)"UNZIPSYNC", (const uint8_t*)[uu UTF8String]);
}

DEFINE_ANE_FUNCTION( unzipFileFrom2 )
{
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	//  filePath:String = argument[0];
    
	uint32_t filePathLength;
	const uint8_t *filePath_CString;
	FREGetObjectAsUTF8(argv[1], &filePathLength, &filePath_CString);
	NSString *filePath = [NSString stringWithUTF8String:(char*)filePath_CString];
    

    

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            setData( [SSZipArchive unzipFileFrom:path withName:filePath] , context );
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        //setData( pepe , context );
        //});
        
    });

    
    
	return NULL;
    
}

/* HELPERS */

DEFINE_ANE_FUNCTION( getFilesInZip )
{
    
	
	//  path:String = argument[0];
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
    NSString* outputString = [ [SSZipArchive getFilesInZip:path password:@""] componentsJoinedByString:@","];
    
    // Convert Obj-C string to C UTF8String
    const char *str = [outputString UTF8String];
    
    // Prepare for AS3
    FREObject retStr;
	FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &retStr);
    
    // Return data back to ActionScript
	return retStr;
    
}

DEFINE_ANE_FUNCTION( unzipResult )
{
	
    FREObject length = NULL;
    FRENewObjectFromUint32([bytearrayUnzip length], &length);
    FRESetObjectProperty(argv[0], (const uint8_t*) "length", length, NULL);
    
    
    FREObject objectBA = argv[0];
    FREByteArray baData;
    FREAcquireByteArray(objectBA, &baData);
    uint8_t *ba = baData.bytes;
    
    memcpy(ba, [bytearrayUnzip bytes], [bytearrayUnzip length]);
    
    FREReleaseByteArray(objectBA);
    
    [bytearrayUnzip setLength:0];
    
	return NULL;
    
}




/* STATIC METHODS */
/* compress array of files*/
DEFINE_ANE_FUNCTION( zipFiles )
{
    
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	uint32_t withFilesAtPathsLength;
	const uint8_t *withFilesAtPaths_CString;
	FREGetObjectAsUTF8(argv[1], &withFilesAtPathsLength, &withFilesAtPaths_CString);
	NSString *withFilesAtPaths = [NSString stringWithUTF8String:(char*)withFilesAtPaths_CString];
    
    delegate = [[ZipFileDelegate alloc] init];
    [delegate setContext:context];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [SSZipArchive createZipFileAtPath:path withFilesAtPaths:[withFilesAtPaths componentsSeparatedByString:@","] andDelegate:delegate];
    });
    
    return NULL;
    
    
}

DEFINE_ANE_FUNCTION( unzipFileAsync )
{
	uint32_t pathLength;
	const uint8_t *path_CString;
	FREGetObjectAsUTF8(argv[0], &pathLength, &path_CString);
	NSString *path = [NSString stringWithUTF8String:(char*)path_CString];
	
	uint32_t destinationLength;
	const uint8_t *destination_CString;
	FREGetObjectAsUTF8(argv[1], &destinationLength, &destination_CString);
	NSString *destination = [NSString stringWithUTF8String:(char*)destination_CString];
	
	uint32_t overwrite_C;
	if( FREGetObjectAsBool(argv[2], &overwrite_C) != FRE_OK ) return NULL;
	
	uint32_t passwordLength;
	const uint8_t *password_CString;
	FREGetObjectAsUTF8(argv[3], &passwordLength, &password_CString);
	NSString *password = [NSString stringWithUTF8String:(char*)password_CString];
	
    if( passwordLength==0 )
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:@"" error:nil delegate:delegate ];
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:overwrite_C password:password error:nil delegate:delegate ];
        });
        
    }
	return NULL;
}




/****************************************************************************************
 *																						*
 *	EXTENSION & CONTEXT																	*
 *																						*
 ****************************************************************************************/

void ANEZipFileContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
	static FRENamedFunction functionMap[] = {
		// METHODS
		MAP_FUNCTION( closeMethod, NULL ),
		MAP_FUNCTION( zipFiles, NULL ),
		MAP_FUNCTION( initWithPath, NULL ),
		MAP_FUNCTION( openMethod, NULL ),
		MAP_FUNCTION( openForAppendMethod, NULL ),
        MAP_FUNCTION( unzipFileAsync, NULL ),
        
        MAP_FUNCTION( getFilesInZip, NULL ),
        MAP_FUNCTION( unzipFileFrom, NULL ),
        MAP_FUNCTION( unzipFileFrom2, NULL ),
        MAP_FUNCTION( unzipResult, NULL ),
        
        
        
		MAP_FUNCTION( writeData, NULL ),
		MAP_FUNCTION( writeFile, NULL ),
        MAP_FUNCTION( writeFileAsync, NULL ),
        MAP_FUNCTION( writeFileAtPath, NULL ),
        MAP_FUNCTION( writeFileAtPathAsync, NULL )
        
	};
    delegate = [[ZipFileDelegate alloc] init];
    [delegate setContext:ctx];
	*numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
	*functionsToSet = functionMap;
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





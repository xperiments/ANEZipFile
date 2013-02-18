#import "SSZipArchiveReadStream.h"
#include "unzip.h"


@implementation SSZipArchiveReadStream


- (id) initWithUnzFileStruct:(unzFile)unzFile fileNameInZip:(NSString *)fileNameInZip {
	if (self= [super init]) {
		_unzFile= unzFile;
		_fileNameInZip= fileNameInZip;
	}
	
	return self;
}

- (NSUInteger) readDataWithBuffer:(NSMutableData *)buffer {
	int err= unzReadCurrentFile(_unzFile, [buffer mutableBytes], [buffer length]);

	
	return err;
}

- (void) finishedReading {
    unzCloseCurrentFile(_unzFile);
}


@end

#import <Foundation/Foundation.h>
#include "unzip.h"


@interface SSZipArchiveReadStream : NSObject {
	NSString *_fileNameInZip;
	
@private
	unzFile _unzFile;
}

- (id) initWithUnzFileStruct:(unzFile)unzFile fileNameInZip:(NSString *)fileNameInZip;

- (NSUInteger) readDataWithBuffer:(NSMutableData *)buffer;
- (void) finishedReading;

@end

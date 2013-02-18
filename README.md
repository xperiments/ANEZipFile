# ANEZipFile

Adobe AIR iOS Native Extension to zip/unzip files.

Uses a slightly modified verion of SSZipArchive Obj-C https://github.com/soffes/ssziparchive

## Features:


### Unzip

* Unzip Files Asynchronously
* Unzip password protected files
* Unzip single file from zip to ByteArray  ( Sync/Async ) 
* List Files inside zip
* Determine if zip is password protected

### Zip
* Zip contents of a directory from FileSystem Asynchronously
* Zip group of Files from Filesystem Asynchronously
* Append files from FileSystem to zip ( Sync/Async ) 
* Append ByteArray Data to a file inside zip ( Sync/Async ) 


## Todo
 * Add working example
 * Enable creation of password protected zips

## Actionscript Classes

### ANEZipUtils Methods

#### listDirToZip(folder : File) : Array;

    List Directory contents of folder.
    Returns an array of file paths.

#### extractFile(zipfile : File, fileName : String, password : String = "") : ByteArray;

    Synchronously gets the contents of a single file in zip.
    Return ByteArray data of the extracted file.
    Pass a password if the zip file is password protected
    
#### extractFileAsync(zipfile : File, fileName : String, password : String = "") : void;

    ASynchronously gets the contents of a single file in zip.
    Pass a password if the zip file is password protected.
    Dispatches ANEZipFileEvent.UNZIP_FILE_BYTES.
        event.resultBytes -> will contain the file ByteArray representation.

#### getZipContents(zipfile : File) : Array;

    Get a list of the files inside the zip

#### isPasswordProtected(zipfile : File) : Boolean;

    Determines if the provided zip file is password protected

#### unzip(zipfile : File, destination : File, overwrite : Boolean = false, password : String = "") : void;

    Unzips a zip file to the filesystem.
    
    Dispatches ANEZipFileEvent.UNZIP_START when the process is started.
    
    Dispatches ANEZipFileEvent.UNZIP_END when the process is finished.
        event.eventData will contain:
        * source        -> path of original zip file
        * destination   -> path of the destination dir
        
    Dispatches ANEZipFileEvent.UNZIP_PROGRESS while processing.
        event.eventData will contain:
        * current   -> current index of decompressed file
        * total     -> total files to decompress inside zip
        * path      -> current decompressed file path

#### zipDirectory(outputZip : File, sourceDirectory : File) : void;

    Zips the contents of a directory
    
    Dispatches ANEZipFileEvent.ZIP_START when the process is started.
        event.eventData will contain:
        * path   -> Path to the generated zip file
    
    Dispatches ANEZipFileEvent.ZIP_END when the process is finished.
        event.eventData will contain:
        * path      -> Path to the generated zip file
        * success   -> Success of the zip action
        
    Dispatches ANEZipFileEvent.ZIP_PROGRESS while processing.
        event.eventData will contain:
        * current   -> current index of compressed file
        * total     -> total files to compress inside zip
 

#### zipFiles(outputZip : File, sourceFiles : Array, destinationFiles : Array = null) : void;

    Zips files to a zip.

    Dispatches ANEZipFileEvent.ZIP_START when the process is started.
        event.eventData will contain:
        * path   -> Path to the generated zip file
    
    Dispatches ANEZipFileEvent.ZIP_END when the process is finished.
        event.eventData will contain:
        * path      -> Path to the generated zip file
        * success   -> Success of the zip action
        
    Dispatches ANEZipFileEvent.ZIP_PROGRESS while processing.
        event.eventData will contain:
        * current   -> current index of compressed file
        * total     -> total files to compress inside zip
        
### ANEZipFile Methods      

#### addFile(file : File, destination : String = "") : Boolean;

    Add a file to the zip
    
#### addFileAsync(file : File, destination : String = "") : void;

    Add a file to the zip ASynchronously

#### close() : Boolean;

    Closes de current zip file

#### dispose() : void;

    Disposes instance

#### open(zipfile : File, fileMode : uint = 0) : Boolean;

    Open a zip file for create / append files.
    
    Avaliable filemodes are:
        * ANEZipFile.FILE_MODE_CREATE
        * ANEZipFile.FILE_MODE_APPEND

#### writeBytes(bytes : ByteArray, fileName : String) : Boolean;

    Write ByteArray data to a file in zip

#### writeBytesAsync(bytes : ByteArray, fileName : String) : void;

    Write ByteArray data to a file in zip ASynchronously

## License

<!-- Creative Commons License -->
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/"><img alt="Creative Commons License" border="0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" class="cc-button"/></a><div class="cc-info"><span xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"><span id="work_title" property="dc:title">ANEZipFile</span> by <a rel="cc:attributionURL" property="cc:attributionName" href="http://www.xperiments.es">Pedro Casaubon</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/">Creative Commons Attribution-ShareAlike 3.0 License</a>. <span rel="dc:source" href="https://github.com/xperiments/ANEFileSyncInterface"/></span></div>

A slightly modified version of [SSZipArchive](https://github.com/soffes/ssziparchive) that is licensed under the [MIT license](https://github.com/samsoffes/ssziparchive/raw/master/LICENSE)
## Thanks

Thanks [soffes](http://soff.es/) for creating [SSZipArchive](https://github.com/soffes/ssziparchive) which ANEZipFile is based on

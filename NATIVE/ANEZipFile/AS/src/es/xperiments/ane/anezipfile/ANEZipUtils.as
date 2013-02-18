//
//  ANEZipUtils.as
//
//  Created by ANEBridgeCreator on 10/02/2013.
//  Copyright (c)2013 Pedro Casaubon. All rights reserved.
//
package es.xperiments.ane.anezipfile
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import es.xperiments.ane.anezipfile.ANEZipFileEvent;		
	import flash.utils.Endian;

	public class ANEZipUtils extends EventDispatcher
	{

		private var _context:ExtensionContext;
		private var _inUse:Boolean = false;

		private static var _listDirectoryFiles:Array;
        private static function _listDirectory( folder:File, start:Boolean = true ):Array
        {
			if( !folder || !folder.exists || !folder.isDirectory )
			{
				throw new Error("ANEZipUtils.listDirToZip Source folder not exists or is a file");
			};

        	if( start ){ _listDirectoryFiles = []; }

            const files:Array = folder.getDirectoryListing();
            
            for (var f:uint = 0; f < files.length; f++)
            {
                if (files[f].isDirectory)
                {
                    if (files[f].name !="." && files[f].name !=".."){ _listDirectory( files[f], false ); }
                }
            	else
            	{
                	_listDirectoryFiles.push( files[f].nativePath);
            	}
            }            
            return _listDirectoryFiles;
        }
		public static function listDirToZip( folder:File ):Array{ return _listDirectory( folder, true ); }


		public function ANEZipUtils( )
		{
			init();
		}

		private function init():void
		{
			_context = ExtensionContext.createExtensionContext("es.xperiments.ane.anezipfile.ANEZipFile","ANEZipUtils");
			_context.addEventListener( StatusEvent.STATUS, onContextStatusEvent );
		}

        public function getZipContents( zipfile:File ):Array
        {
			if( !zipfile || !zipfile.exists || zipfile.isDirectory )
			{
				throw new Error("ANEZipUtils.getZipContents Source zip file not exists or is a directory");
			};        	
        	const resultString:String = _context.call('getFilesInZip', zipfile.nativePath ) as String;
        	const resultArray:Array = resultString.split(',');
        	return resultArray;
        }

		public function zipFiles( outputZip:File, sourceFiles:Array, destinationFiles:Array = null ):void
		{
        	if( _inUse ) return;
        	_inUse = true;		

			if( !sourceFiles || sourceFiles.length==0 )
			{
				throw new Error("ANEZipUtils.zipFiles sourceFiles is empty");
			};

			if( destinationFiles!=null && destinationFiles.length != sourceFiles.length )
			{
				throw new Error("ANEZipUtils.zipFiles sourceFiles and destinationFiles count don't match");
			};			

			if( destinationFiles!=null )
			{
				_context.call( 'zipFilesWithPaths', outputZip.nativePath, sourceFiles.join(','), destinationFiles.join(',') );
			}
			else
			{
				_context.call( 'zipFiles',outputZip.nativePath, sourceFiles.join(','));
			}
		};

		public function zipDirectory( outputZip:File, sourceDirectory:File ):void
		{
        	if( _inUse ) return;
        	_inUse = true;			
			if( !sourceDirectory || !sourceDirectory.exists || !sourceDirectory.isDirectory )
			{
				throw new Error("ANEZipUtils.zipDirectory sourceDirectory not exists or is a file");
			};

			const filesInDir:Array = listDirToZip( sourceDirectory );

			if( filesInDir.length==0 ) return;
			const destinationFiles:Array = [];
			for( var i:uint=0; i<filesInDir.length; i++ )
			{
				destinationFiles.push( filesInDir[i].split( sourceDirectory.nativePath+'/' )[1] );
			}
			_context.call( 'zipFilesWithPaths', outputZip.nativePath, filesInDir.join(','), destinationFiles.join(',') );
		};

		public function unzip( zipfile:File, destination:File, overwrite:Boolean = false, password:String = "" ):void
		{
        	if( _inUse ) return;
        	_inUse = true;			
			if( !zipfile.exists || zipfile.isDirectory )
			{
				throw new Error("ANEZipUtils.unzip zipFile not exists or is a directory");
			}
			_context.call( 'unzip',zipfile.nativePath, destination.nativePath, overwrite, password );
		};					

		public function isPasswordProtected( zipfile:File ):Boolean
		{
			if( !zipfile.exists || zipfile.isDirectory )
			{
				throw new Error("ANEZipUtils.isPasswordProtected zipFile not exists or is a directory");
			}
			return _context.call( 'isPasswordProtected', zipfile.nativePath ) as Boolean;
		}
		public function extractFile( zipfile:File, fileName:String, password:String = "" ):ByteArray
		{
        	if( _inUse ) return null;
        	_inUse = true;			
			if( !zipfile.exists || zipfile.isDirectory )
			{
				throw new Error("ANEZipUtils.extractFile zipFile not exists or is a directory");
			}
			if( !fileName || fileName.length == 0 )
			{
				throw new Error("ANEZipUtils.extractFile fileName to extract is null or empty");
			}			
			var ba:ByteArray = new ByteArray();
			_context.call( 'extractFile', zipfile.nativePath, fileName, password, ba );
			_inUse = false;
			ba.position = 0;
			return ba;
		};			

		public function extractFileAsync( zipfile:File, fileName:String, password:String = "" ):void
		{
        	if( _inUse ) return;
        	_inUse = true;			
			if( !zipfile.exists || zipfile.isDirectory )
			{
				throw new Error("ANEZipUtils.extractFile zipFile not exists or is a directory");
			}
			if( !fileName || fileName.length == 0 )
			{
				throw new Error("ANEZipUtils.extractFile fileName to extract is null or empty");
			}
			_context.call( 'extractFileAsync', zipfile.nativePath, fileName, password );
			_inUse = false;

		};

		public static function get isSupported():Boolean
		{
			return true;
		}
		
		public function dispose():void
		{
			_context.removeEventListener(StatusEvent.STATUS,onContextStatusEvent);
			_context.dispose();
			_context = null;
		}
		
		private function onContextStatusEvent( e:StatusEvent ):void
		{
			switch( e.code )
			{
				// EXTRACT FILE
				case ANEZipFileEvent.UNZIP_FILE_BYTES:
					var ba:ByteArray = new ByteArray();
					_context.call('extractFileAsyncResult', ba );
					
					var event:ANEZipFileEvent = new ANEZipFileEvent( ANEZipFileEvent.UNZIP_FILE_BYTES );
					event.resultBytes = ba;
					dispatchEvent( event );
				break;			

				// UNZIP	
				case ANEZipFileEvent.UNZIP_START:
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.UNZIP_START ) );
				break;
				case ANEZipFileEvent.UNZIP_END:
					_inUse = false;
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.UNZIP_END, e.level ) );
					
				break;
				case ANEZipFileEvent.UNZIP_PROGRESS:
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.UNZIP_PROGRESS, e.level ) );
				break;
		
				// ZIP
				case ANEZipFileEvent.ZIP_START:
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.ZIP_START, e.level ) );
				break;
				case ANEZipFileEvent.ZIP_END:
					_inUse = false;
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.ZIP_END, e.level ) );
					
				break;
				case ANEZipFileEvent.ZIP_PROGRESS:
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.ZIP_PROGRESS, e.level ) );
				break;												
			}
		}
	}

}

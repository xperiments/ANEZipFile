//
//  ANEZipFile.as
//
//  Created by ANEBridgeCreator on 10/02/2013.
//  Copyright (c)2013 ANEBridgeCreator. All rights reserved.
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


	public class ANEZipFile extends EventDispatcher
	{

		public static const FILE_MODE_CREATE:uint=0;
		public static const FILE_MODE_APPEND:uint=1;
	
		/**
		 * Declare instance context
		 */
		private var _context:ExtensionContext;
		private var _opened:Boolean = false;

		public function ANEZipFile()
		{
			init();
		}
		private function init():void
		{
			_context = ExtensionContext.createExtensionContext("es.xperiments.ane.anezipfile.ANEZipFile","ANEZipFile");
			_context.addEventListener( StatusEvent.STATUS, onContextStatusEvent );
		}
		public function open( zipfile:File , fileMode:uint = FILE_MODE_CREATE ):Boolean
		{
			if( _opened ) return false;
			_opened = true;
			_context.call( 'initWithPath', zipfile.nativePath ) ;

			return	_context.call( fileMode == FILE_MODE_CREATE ? 'openMethod':'openForAppendMethod' ) as Boolean;
		};
		
		public function close( ):Boolean
		{
			if( !_opened ) return false;
			_opened = false;
			return	_context.call( 'closeMethod' ) as Boolean;
		};

		public function writeBytes( bytes:ByteArray, fileName:String ):Boolean
		{
			if( !fileName || fileName.length == 0 )
			{
				throw new Error("ANEZipFile.writeBytes fileName must be not empty");
			};
			return	_context.call( 'writeData', bytes, fileName ) as Boolean;
		};
		
		public function writeBytesAsync( bytes:ByteArray, fileName:String ):void
		{
			if( !fileName || fileName.length == 0 )
			{
				throw new Error("ANEZipFile.writeBytes fileName must be not empty");
			};			
			_context.call( 'writeDataAsync', bytes, fileName );
		};

		public function addFile( file:File, destination:String="" ):Boolean
		{
			if( !file.exists || file.isDirectory )
			{
				throw new Error("ANEZipFile.addFile Source file not exists or is a directory");
			};

			var result:Boolean;
			if( destination=="")
			{
				result = _context.call( 'writeFile', file.nativePath ) as Boolean;
			}
			else
			{
				result = _context.call( 'writeFileAtPath', file.nativePath, destination ) as Boolean;
			}
			return result;
		};

		public function addFileAsync( file:File, destination:String="" ):void
		{
			if( !file.exists || file.isDirectory )
			{
				throw new Error("ANEZipFile.addFile Source file not exists or is a directory");
			};

			if( destination=="")
			{
				_context.call( 'writeFileAsync', file.nativePath );
			}
			else
			{
				_context.call( 'writeFileAtPathAsync', file.nativePath, destination );
			}
		};					
	
		public static function get isSupported():Boolean
		{
			return true;
		}
		
		public function dispose():void
		{
			_context.dispose();
			_context = null;
		}

		private function onContextStatusEvent( e:StatusEvent ):void
		{
			switch( e.code )
			{

				case ANEZipFileEvent.ZIP_WRITE_BYTES:
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.ZIP_WRITE_BYTES ) );
				break;
				case ANEZipFileEvent.ZIP_WRITE_FILE:
					dispatchEvent( new ANEZipFileEvent( ANEZipFileEvent.ZIP_WRITE_FILE ) );
				break;				
												
			}
		}					
		
	}

}

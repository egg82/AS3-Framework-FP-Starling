/**
 * Copyright (c) 2015 egg82 (Alexander Mason)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package egg82.utils {
	import egg82.events.ImageDecoderEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.utils.interfaces.IImageDecoder;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class ImageDecoder implements IImageDecoder, IPrototype {
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:Loader;
		private var _file:String;
		private var _isLoading:Boolean = false;
		
		private var context:LoaderContext;
		
		private var _loadedBytes:Number = 0;
		private var _totalBytes:Number = 0;
		
		//constructor
		public function ImageDecoder() {
			
		}
		
		//public
		public function decode(bytes:ByteArray, file:String = ""):void {
			if (_isLoading) {
				return;
			}
			
			loader = new Loader();
			_file = file;
			_loadedBytes = 0;
			_totalBytes = 0;
			
			if (!_file) {
				_file = "";
			}
			
			context = new LoaderContext();
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			
			loader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			
			_isLoading = true;
			
			loader.loadBytes(bytes, context);
		}
		public function load(file:String):void {
			if (_isLoading) {
				return;
			}
			
			loader = new Loader();
			_file = file;
			_loadedBytes = 0;
			_totalBytes = 0;
			
			context = new LoaderContext();
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			
			loader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			
			_isLoading = true;
			
			loader.load(new URLRequest(file), context);
		}
		
		public function get file():String {
			return _file;
		}
		public function isLoading():Boolean {
			return _isLoading;
		}
		
		public function get loadedBytes():Number {
			return _loadedBytes;
		}
		public function get totalBytes():Number {
			return _totalBytes;
		}
		
		public function cancel():void {
			if (!_isLoading) {
				return;
			}
			
			_file = "";
			loader.close();
			
			_isLoading = false;
		}
		
		public function clone():IPrototype {
			return new ImageDecoder();
		}
		
		//private
		private function onAsyncError(e:AsyncErrorEvent):void {
			loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			
			_isLoading = false;
			
			dispatch(ImageDecoderEvent.ERROR, e.text);
		}
		private function onIOError(e:IOErrorEvent):void {
			loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			
			_isLoading = false;
			
			dispatch(ImageDecoderEvent.ERROR, e.text);
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			
			_isLoading = false;
			
			dispatch(ImageDecoderEvent.ERROR, e.text);
		}
		
		private function onProgress(e:ProgressEvent):void {
			_loadedBytes = e.bytesLoaded;
			_totalBytes = e.bytesTotal;
			dispatch(ImageDecoderEvent.PROGRESS, {
				"loaded": e.bytesLoaded,
				"total": e.bytesTotal
			});
		}
		
		private function onComplete(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			
			_isLoading = false;
			
			dispatch(ImageDecoderEvent.COMPLETE, (loader.content as Bitmap).bitmapData);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			//trace("[" + event + "] (" + _file + ") " + JSON.stringify(data));
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
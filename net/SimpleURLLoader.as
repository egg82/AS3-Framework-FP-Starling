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

package egg82.net {
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.net.interfaces.ISimpleURLLoader;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class SimpleURLLoader implements ISimpleURLLoader, IPrototype {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:flash.net.URLLoader = new flash.net.URLLoader();
		private var _loading:Boolean = false;
		private var _file:String = "";
		
		private var _loadedBytes:Number = 0;
		private var _totalBytes:Number = 0;
		
		//constructor
		public function SimpleURLLoader() {
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onResponseStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.addEventListener(Event.COMPLETE, onComplete);
		}
		
		//public
		public function load(url:String):void {
			if (_loading) {
				return;
			}
			
			_loading = true;
			_file = url;
			_loadedBytes = 0;
			_totalBytes = 0;
			loader.load(new URLRequest(url));
		}
		public function loadRequest(request:URLRequest):void {
			if (_loading) {
				return;
			}
			
			_loading = true;
			_file = request.url;
			_loadedBytes = 0;
			_totalBytes = 0;
			loader.load(request);
		}
		
		public function cancel():void {
			if (!_loading) {
				return;
			}
			
			_file = "";
			loader.close();
			
			_loading = false;
		}
		
		public function get loading():Boolean {
			return _loading;
		}
		public function get file():String {
			return _file;
		}
		
		public function get loadedBytes():Number {
			return _loadedBytes;
		}
		public function get totalBytes():Number {
			return _totalBytes;
		}
		
		public function clone():IPrototype {
			return new SimpleURLLoader();
		}
		
		//private
		private function onResponseStatus(e:HTTPStatusEvent):void {
			dispatch(SimpleURLLoaderEvent.RESPONSE_STATUS, e.status);
		}
		private function onIoError(e:IOErrorEvent):void {
			_loading = false;
			dispatch(SimpleURLLoaderEvent.ERROR, e.text);
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			_loading = false;
			dispatch(SimpleURLLoaderEvent.ERROR, e.text);
		}
		private function onProgress(e:ProgressEvent):void {
			_loadedBytes = e.bytesLoaded;
			_totalBytes = e.bytesTotal;
			dispatch(SimpleURLLoaderEvent.PROGRESS, {
				"loaded": e.bytesLoaded,
				"total": e.bytesTotal
			});
		}
		private function onComplete(e:Event):void {
			_loading = false;
			dispatch(SimpleURLLoaderEvent.COMPLETE, loader.data);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			//trace("[" + event + "] (" + _file + ") " + JSON.stringify(data));
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
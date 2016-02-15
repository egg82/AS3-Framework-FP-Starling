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

package egg82.base {
	import egg82.events.base.BasePreloaderEvent;
	import egg82.patterns.Observer;
	import egg82.startup.Start;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class BasePreloader extends Sprite {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var _loaded:Number = 0;
		private var _total:Number = 0;
		
		private var _preInitState:Class = null;
		private var _preInitStateArgs:Array = null;
		private var _postInitState:Class = null;
		private var _postInitStateArgs:Array = null;
		
		//constructor
		public function BasePreloader(preInitState:Class, postInitState:Class, preInitStateArgs:Array = null, postInitStateArgs:Array = null) {
			if (!preInitState) {
				throw new Error("preInitState cannot be null");
			}
			if (!postInitState) {
				throw new Error("postInitState cannot be null");
			}
			
			_preInitState = preInitState;
			_preInitStateArgs = preInitStateArgs;
			_postInitState = postInitState;
			_postInitStateArgs = postInitStateArgs;
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		//public
		public function get loaded():Number {
			return _loaded;
		}
		public function get total():Number {
			return _total;
		}
		
		public function start():void {
			addChild(new Start(_preInitState, _preInitStateArgs, _postInitState, _postInitStateArgs));
		}
		
		//private
		private function onProgress(e:ProgressEvent):void {
			_loaded = e.bytesLoaded;
			_total = e.bytesTotal;
			
			dispatch(BasePreloaderEvent.PROGRESS, {
				"loaded": _loaded,
				"total": _total
			});
		}
		private function onComplete(e:Event):void {
			var url:String = loaderInfo.url;
			
			if (url.indexOf("file://") > -1) {
				url = url.substring(0, url.lastIndexOf("/"));
			}
			
			if (!_preInitStateArgs) {
				_preInitStateArgs = new Array();
			}
			_preInitStateArgs.push({
				"url": url
			});
			
			dispatch(BasePreloaderEvent.COMPLETE);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
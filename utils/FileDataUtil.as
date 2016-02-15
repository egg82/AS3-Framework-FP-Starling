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
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.net.SimpleURLLoader;
	import egg82.patterns.objectPool.DynamicObjectPool;
	import egg82.patterns.Observer;
	import egg82.patterns.prototype.interfaces.IPrototype;
	import egg82.events.util.FileDataUtilEvent;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class FileDataUtil {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var imageDecoders:DynamicObjectPool = new DynamicObjectPool("imageDecoder", new ImageDecoder());
		private var urlLoaders:DynamicObjectPool = new DynamicObjectPool("simpleUrlLoader", new SimpleURLLoader());
		
		private var imageDecoderObserver:Observer = new Observer();
		private var urlLoaderObserver:Observer = new Observer();
		
		//constructor
		public function FileDataUtil() {
			
		}
		
		//public
		public function create():void {
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			urlLoaderObserver.add(onUrlLoaderObserverNotify);
			Observer.add(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
		}
		public function destroy():void {
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			Observer.remove(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
		}
		
		public function getFile(url:String):void {
			(urlLoaders.getObject() as SimpleURLLoader).load(url);
		}
		public function decodeImage(data:ByteArray, name:String):void {
			(imageDecoders.getObject() as ImageDecoder).decode(data, name);
		}
		
		//private
		private function onImageDecoderObserverNotify(sender:Object, event:String, data:Object):void {
			if (Util.vectorPos(sender, imageDecoders.usedPool) == -1) {
				return;
			}
			
			if (event == ImageDecoderEvent.COMPLETE) {
				dispatch(FileDataUtilEvent.DECODE_COMPLETE, data);
				imageDecoders.returnObject(sender as IPrototype);
			} else if (event == ImageDecoderEvent.ERROR) {
				dispatch(FileDataUtilEvent.DECODE_ERROR, data);
				imageDecoders.returnObject(sender as IPrototype);
			}
		}
		private function onUrlLoaderObserverNotify(sender:Object, event:String, data:Object):void {
			if (Util.vectorPos(sender, urlLoaders.usedPool) == -1) {
				return;
			}
			
			if (event == SimpleURLLoaderEvent.COMPLETE) {
				dispatch(FileDataUtilEvent.FILE_COMPLETE, data);
				urlLoaders.returnObject(sender as IPrototype);
			} else if (event == SimpleURLLoaderEvent.ERROR) {
				dispatch(FileDataUtilEvent.FILE_ERROR, data);
				urlLoaders.returnObject(sender as IPrototype);
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
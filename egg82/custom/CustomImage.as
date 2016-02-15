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

package egg82.custom {
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.ServiceType;
	import egg82.events.custom.CustomImageEvent;
	import egg82.events.ImageDecoderEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import egg82.utils.ImageDecoder;
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomImage extends Image {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:ImageDecoder = new ImageDecoder();
		private var path2:String;
		
		private var _isLoaded:Boolean = false;
		
		private var imageDecoderObserver:Observer = new Observer();
		private var registryUtilObserver:Observer = new Observer();
		
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		//constructor
		public function CustomImage(url:String) {
			var texture:Texture = registryUtil.getTexture("null");
			super(texture);
			
			if (!url || url == "") {
				throw new Error("url cannot be null.");
			}
			
			path2 = registryUtil.stripURL(url);
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			if (registryUtil.getTexture(url)) {
				texture = registryUtil.getTexture(url);
				_isLoaded = true;
			} else if (registryUtil.getBitmapData(url)) {
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				texture = registryUtil.getTexture(url);
				_isLoaded = true;
			} else {
				loader.load(url);
			}
			
			this.texture = texture;
			
			smoothing = registryUtil.getOption(OptionsRegistryType.VIDEO, "textureFiltering") as String;
			touchable = false;
		}
		
		//public
		public function create():void {
			if (_isLoaded) {
				dispatch(CustomImageEvent.COMPLETE);
			}
		}
		
		public function destroy():void {
			var url:String;
			
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			if (loader.file) {
				name = registryUtil.stripURL(loader.file);
			} else {
				name = path2;
			}
			
			dispose();
			//registryUtil.setTexture(url, null);
			//RegTextures.disposeBMD(name);
		}
		
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		//private
		private function onImageDecoderObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== loader) {
				return;
			}
			
			if (event == ImageDecoderEvent.COMPLETE) {
				onLoadComplete(data as BitmapData);
			} else if (event == ImageDecoderEvent.ERROR) {
				onLoadError(data as String);
			} else if (event == ImageDecoderEvent.PROGRESS) {
				
			}
		}
		
		private function onLoadError(error:String):void {
			dispatch(CustomImageEvent.ERROR, error);
			
			var url:String = loader.file;
			
			if (registryUtil.getTexture(url)) {
				texture = registryUtil.getTexture(url);
			} else if (registryUtil.getBitmapData(url)) {
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				texture = registryUtil.getTexture(url);
			} else {
				return;
			}
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_isLoaded = true;
			dispatch(CustomImageEvent.COMPLETE);
		}
		private function onLoadComplete(bmd:BitmapData):void {
			var url:String = loader.file;
			
			if (registryUtil.getTexture(url)) {
				bmd.dispose();
				texture = registryUtil.getTexture(url);
			} else if (registryUtil.getBitmapData(url)) {
				bmd.dispose();
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				texture = registryUtil.getTexture(url);
			} else {
				registryUtil.setBitmapData(url, bmd);
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				texture = registryUtil.getTexture(url);
			}
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_isLoaded = true;
			dispatch(CustomImageEvent.COMPLETE);
		}
		
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.VIDEO && name == "textureFiltering") {
				smoothing = value as String;
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
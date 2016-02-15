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
	import egg82.events.custom.CustomAtlasImageEvent;
	import egg82.events.ImageDecoderEvent;
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.net.SimpleURLLoader;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import egg82.utils.ImageDecoder;
	import egg82.utils.MathUtil;
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CustomAtlasImage extends Image {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:ImageDecoder = new ImageDecoder();
		private var xmlLoader:SimpleURLLoader = new SimpleURLLoader();
		
		private var atlas:TextureAtlas;
		private var atlasRows:uint;
		private var atlasCols:uint;
		
		private var texRow:uint = 0;
		private var texCol:uint = 0;
		
		private var path2:String;
		private var xmlUrl:String;
		
		private var _isLoaded:Boolean = false;
		private var _xmlLoaded:Boolean = false;
		private var _bmd:BitmapData = null;
		
		private var imageDecoderObserver:Observer = new Observer();
		private var simpleURLLoaderObserver:Observer = new Observer();
		private var registryUtilObserver:Observer = new Observer();
		
		private var registryUtil:IRegistryUtil = ServiceLocator.getService(ServiceType.REGISTRY_UTIL) as IRegistryUtil;
		
		//constructor
		public function CustomAtlasImage(url:String, xmlUrl:String = null, atlasRows:uint = 0, atlasCols:uint = 0) {
			var texture:Texture = registryUtil.getTexture("null");
			super(texture);
			
			if (!url || url == "") {
				throw new Error("url cannot be null.");
			}
			
			path2 = registryUtil.stripURL(url);
			this.xmlUrl = xmlUrl;
			
			this.atlasRows = atlasRows;
			this.atlasCols = atlasCols;
			
			if (url == "null") {
				_isLoaded = true;
				return;
			}
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			simpleURLLoaderObserver.add(onSimpleURLLoaderObserverNotify);
			Observer.add(SimpleURLLoader.OBSERVERS, simpleURLLoaderObserver);
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			if (registryUtil.getAtlas(url)) {
				atlas = registryUtil.getAtlas(url);
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
			} else if (registryUtil.getTexture(url)) {
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
			} else if (registryUtil.getBitmapData(url)) {
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
			} else {
				loader.load(url);
				if (xmlUrl) {
					xmlLoader.load(xmlUrl);
				} else {
					_xmlLoaded = true;
				}
			}
			
			this.texture = texture;
			
			smoothing = registryUtil.getOption(OptionsRegistryType.VIDEO, "textureFiltering") as String;
			touchable = false;
		}
		
		//public
		public function create():void {
			if (_isLoaded) {
				dispatch(CustomAtlasImageEvent.COMPLETE);
			}
		}
		
		public function destroy():void {
			var url:String;
			
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
			Observer.remove(SimpleURLLoader.OBSERVERS, simpleURLLoaderObserver);
			Observer.remove(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			if (loader.file) {
				url = registryUtil.stripURL(loader.file);
			} else {
				url = path2;
			}
			
			dispose();
		}
		
		public function load(url:String, xmlUrl:String = null, atlasRows:uint = 0, atlasCols:uint = 0):void {
			if (!url || url == "") {
				throw new Error("url cannot be null.");
			}
			
			loader.cancel();
			xmlLoader.cancel();
			
			_isLoaded = false;
			_xmlLoaded = false;
			
			path2 = registryUtil.stripURL(url);
			this.xmlUrl = xmlUrl;
			
			this.atlasRows = atlasRows;
			this.atlasCols = atlasCols;
			
			if (url == "null") {
				_isLoaded = true;
				return;
			}
			
			if (registryUtil.getAtlas(url)) {
				atlas = registryUtil.getAtlas(url);
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
				
				this.texture = texture;
			} else if (registryUtil.getTexture(url)) {
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
				
				this.texture = texture;
			} else if (registryUtil.getBitmapData(url)) {
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
				texture = atlas.getTexture(atlas.getNames()[0]);
				_isLoaded = true;
				
				this.texture = texture;
			} else {
				loader.load(url);
				if (xmlUrl) {
					xmlLoader.load(xmlUrl);
				} else {
					_xmlLoaded = true;
				}
			}
		}
		
		public function setTexture(row:uint, col:uint):void {
			if (!atlas) {
				return;
			}
			
			texRow = row;
			texCol = col;
			
			if (!atlas.getTexture(col + "_" + row)) {
				texture = registryUtil.getTexture("null");
			} else {
				texture = atlas.getTexture(col + "_" + row);
			}
			
			scaleX = scaleY = 1;
		}
		public function setTextureFromName(name:String):void {
			if (!atlas) {
				return;
			}
			
			if (!atlas.getTexture(name)) {
				texture = registryUtil.getTexture("null");
			} else {
				texture = atlas.getTexture(name);
			}
			
			scaleX = scaleY = 1;
			
			readjustSize();
		}
		public function getTextureXY():uint {
			if (!atlas) {
				return 0;
			}
			
			return MathUtil.toXY(atlasCols, texCol, texRow);
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
		private function onSimpleURLLoaderObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== xmlLoader) {
				return;
			}
			
			if (event == SimpleURLLoaderEvent.COMPLETE) {
				onXMLLoadComplete(data as ByteArray);
			} else if (event == SimpleURLLoaderEvent.ERROR) {
				onXMLLoadError(data as String);
			} else if (event == SimpleURLLoaderEvent.PROGRESS) {
				
			}
		}
		
		private function onLoadError(error:String):void {
			dispatch(CustomAtlasImageEvent.ERROR, error);
			
			var url:String = loader.file;
			
			if (registryUtil.getAtlas(url)) {
				atlas = registryUtil.getAtlas(url);
			} else if (registryUtil.getTexture(url)) {
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
			} else if (registryUtil.getBitmapData(url)) {
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
			} else {
				return;
			}
			
			texture = atlas.getTexture(atlas.getNames()[0]);
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_isLoaded = true;
			dispatch(CustomAtlasImageEvent.COMPLETE);
		}
		private function onLoadComplete(bmd:BitmapData):void {
			_bmd = bmd;
			
			if (_xmlLoaded) {
				complete();
			}
		}
		
		private function onXMLLoadError(error:String):void {
			onLoadError(error);
		}
		private function onXMLLoadComplete(data:ByteArray):void {
			var url:String = loader.file;
			
			registryUtil.setXML(url, new XML(data.readUTFBytes(data.length)));
			_xmlLoaded = true;
			
			if (_bmd) {
				complete();
			}
		}
		
		private function complete():void {
			var url:String = loader.file;
			
			if (registryUtil.getAtlas(url)) {
				_bmd.dispose();
				atlas = registryUtil.getAtlas(url);
			} else if (registryUtil.getTexture(url)) {
				_bmd.dispose();
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
			} else if (registryUtil.getBitmapData(url)) {
				_bmd.dispose();
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
			} else {
				registryUtil.setBitmapData(url, _bmd);
				registryUtil.setTexture(url, TextureUtil.getTexture(registryUtil.getBitmapData(url)));
				if (registryUtil.getXML(xmlUrl)) {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlasXML(registryUtil.getTexture(url), registryUtil.getXML(xmlUrl)));
				} else {
					registryUtil.setAtlas(url, TextureUtil.getTextureAtlas(registryUtil.getTexture(url), atlasRows, atlasCols));
				}
				atlas = registryUtil.getAtlas(url);
			}
			
			texture = atlas.getTexture(atlas.getNames()[0]);
			
			if (width == 1 && height == 1) {
				width = texture.width;
				height = texture.height;
			}
			
			_bmd = null;
			_isLoaded = true;
			dispatch(CustomAtlasImageEvent.COMPLETE);
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
		
		private function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
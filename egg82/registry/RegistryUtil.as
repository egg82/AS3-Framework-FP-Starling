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

package egg82.registry {
	import egg82.enums.ServiceType;
	import egg82.events.registry.RegistryUtilEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import flash.display.BitmapData;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class RegistryUtil implements IRegistryUtil {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var initialized:Boolean = false;
		
		private var fileRegistry:IRegistry;
		private var fontRegistry:IRegistry;
		private var optionsRegistry:IRegistry;
		private var textureRegistry:IRegistry;
		
		//constructor
		public function RegistryUtil() {
			
		}
		
		//public
		public function initialize():void {
			if (initialized) {
				return;
			}
			initialized = true;
			
			fileRegistry = ServiceLocator.getService(ServiceType.FILE_REGISTRY) as IRegistry;
			fontRegistry = ServiceLocator.getService(ServiceType.FONT_REGISTRY) as IRegistry;
			optionsRegistry = ServiceLocator.getService(ServiceType.OPTIONS_REGISTRY) as IRegistry;
			textureRegistry = ServiceLocator.getService(ServiceType.TEXTURE_REGISTRY) as IRegistry;
			
			fileRegistry.initialize();
			fontRegistry.initialize();
			optionsRegistry.initialize();
			textureRegistry.initialize();
		}
		
		public function setFile(type:String, name:String, url:String):void {
			if (!fileRegistry.getRegister(type)) {
				fileRegistry.setRegister(type, new Array());
			}
			
			(fileRegistry.getRegister(type) as Array).push({
				"name": name,
				"url": url
			});
			
			dispatch(RegistryUtilEvent.VALUE_ADDED, {
				"registry": "fileRegistry",
				"type": type,
				"name": name,
				"value": url
			});
		}
		public function getFile(type:String, name:String):String {
			if (!fileRegistry.getRegister(type)) {
				return null;
			}
			
			var arr:Array = fileRegistry.getRegister(type) as Array;
			
			for (var i:uint = 0; i < arr.length; i++) {
				if (arr[i].name == name) {
					return arr[i].url as String;
				}
			}
			
			return null;
		}
		/*public function removeFile(type:String, name:String):void {
			
		}*/
		
		public function setFont(name:String, font:Class):void {
			var event:String = (fontRegistry.getRegister(name)) ? ((font) ? RegistryUtilEvent.VALUE_CHANGED : RegistryUtilEvent.VALUE_REMOVED) : RegistryUtilEvent.VALUE_ADDED;
			
			Font.registerFont(font);
			fontRegistry.setRegister(name, font);
			
			dispatch(event, {
				"registry": "fontRegistry",
				"type": null,
				"name": name,
				"value": font
			});
		}
		public function getFont(name:String):Class {
			return fontRegistry.getRegister(name) as Class;
		}
		/*public function removeFont(name:String):void {
			
		}*/
		
		public function setOption(type:String, name:String, value:*):void {
			var event:String = (optionsRegistry.getRegister(type)) ? (((optionsRegistry.getRegister(type) as Object)[name]) ? ((value) ? RegistryUtilEvent.VALUE_CHANGED : RegistryUtilEvent.VALUE_REMOVED) : RegistryUtilEvent.VALUE_ADDED) : RegistryUtilEvent.VALUE_ADDED;
			
			if (!optionsRegistry.getRegister(type)) {
				optionsRegistry.setRegister(type, new Object());
			}
			(optionsRegistry.getRegister(type) as Object)[name] = value;
			
			dispatch(event, {
				"registry": "optionsRegistry",
				"type": type,
				"name": name,
				"value": value
			});
		}
		public function getOption(type:String, name:String):* {
			if (!optionsRegistry.getRegister(type)) {
				return null;
			}
			
			return (optionsRegistry.getRegister(type) as Object)[name];
		}
		/*public function removeOption(type:String, name:String):void {
			
		}*/
		
		public function setBitmapData(url:String, data:BitmapData):void {
			var event:String = (textureRegistry.getRegister(stripURL(url) + "_bmd")) ? ((data) ? RegistryUtilEvent.VALUE_CHANGED : RegistryUtilEvent.VALUE_REMOVED) : RegistryUtilEvent.VALUE_ADDED;
			
			textureRegistry.setRegister(stripURL(url) + "_bmd", data);
			
			dispatch(event, {
				"registry": "textureRegistry",
				"type": null,
				"name": url,
				"value": data
			});
		}
		public function getBitmapData(url:String):BitmapData {
			return textureRegistry.getRegister(stripURL(url) + "_bmd") as BitmapData;
		}
		/*public function removeBitmapData(url:String):void {
			
		}*/
		
		public function setTexture(url:String, texture:Texture):void {
			var event:String = (textureRegistry.getRegister(stripURL(url) + "_tex")) ? ((texture) ? RegistryUtilEvent.VALUE_CHANGED : RegistryUtilEvent.VALUE_REMOVED) : RegistryUtilEvent.VALUE_ADDED;
			
			textureRegistry.setRegister(stripURL(url) + "_tex", texture);
			
			dispatch(event, {
				"registry": "textureRegistry",
				"type": null,
				"name": url,
				"value": texture
			});
		}
		public function getTexture(url:String):Texture {
			return textureRegistry.getRegister(stripURL(url) + "_tex") as Texture;
		}
		/*public function removeTexture(url:String):void {
			
		}*/
		
		public function setAtlas(url:String, atlas:TextureAtlas):void {
			var event:String = (textureRegistry.getRegister(stripURL(url) + "_atlas")) ? ((atlas) ? RegistryUtilEvent.VALUE_CHANGED : RegistryUtilEvent.VALUE_REMOVED) : RegistryUtilEvent.VALUE_ADDED;
			
			textureRegistry.setRegister(stripURL(url) + "_atlas", atlas);
			
			dispatch(event, {
				"registry": "textureRegistry",
				"type": null,
				"name": url,
				"value": atlas
			});
		}
		public function getAtlas(url:String):TextureAtlas {
			return textureRegistry.getRegister(stripURL(url) + "_atlas") as TextureAtlas;
		}
		/*public function removeAtlas(url:String):void {
			
		}*/
		
		public function setXML(url:String, xml:XML):void {
			var event:String = (textureRegistry.getRegister(stripURL(url) + "_xml")) ? ((xml) ? RegistryUtilEvent.VALUE_CHANGED : RegistryUtilEvent.VALUE_REMOVED) : RegistryUtilEvent.VALUE_ADDED;
			
			textureRegistry.setRegister(stripURL(url) + "_xml", xml);
			
			dispatch(event, {
				"registry": "textureRegistry",
				"type": null,
				"name": url,
				"value": xml
			});
		}
		public function getXML(url:String):XML {
			return textureRegistry.getRegister(stripURL(url) + "_xml") as XML;
		}
		/*public function removeXML(url:String):void {
			
		}*/
		
		public function stripURL(url:String):String {
			return url.replace(/\W|_/g, "_");
		}
		
		//private
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
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

package egg82.startup.states.inits {
	import egg82.base.BaseState;
	import egg82.enums.FileRegistryType;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.ImageDecoderEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.ImageDecoder;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.TextureUtil;
	import flash.display.BitmapData;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class TextureInitState extends BaseState {
		//vars
		private var centerText:TextField;
		
		private var textureDecoders:Vector.<ImageDecoder>;
		private var currentFile:uint;
		private var loadedFiles:Number;
		private var totalFiles:Number;
		
		private var imageDecoderObserver:Observer = new Observer();
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		private var textureRegistry:IRegistry = ServiceLocator.getService("textureRegistry") as IRegistry;
		private var fileRegistry:IRegistry = ServiceLocator.getService("fileRegistry") as IRegistry;
		
		//constructor
		public function TextureInitState() {
			
		}
		
		//public
		override public function create(args:Array = null):void {
			super.create(args);
			
			_nextState = AudioInitState;
			
			textureRegistry.setRegister("null_bmd", new BitmapData(1, 1, true, 0x00000000));
			textureRegistry.setRegister("null_tex", TextureUtil.getTexture(textureRegistry.getRegister("null_bmd") as BitmapData));
			textureRegistry.setRegister("null_atlas", TextureUtil.getTextureAtlas(textureRegistry.getRegister("null_tex") as Texture, 0, 0));
			
			if (!optionsRegistry.getRegister(OptionsRegistryType.NETWORK).preloadTextures || (fileRegistry.getRegister(FileRegistryType.TEXTURE) as Array).length == 0) {
				nextState();
				return;
			}
			
			imageDecoderObserver.add(onImageDecoderObserverNotify);
			Observer.add(ImageDecoder.OBSERVERS, imageDecoderObserver);
			
			centerText = new TextField(0, 0, "Loading textures", "visitor", 22, 0x000000, false);
			centerText.hAlign = HAlign.CENTER;
			centerText.vAlign = VAlign.CENTER;
			addChild(centerText);
			
			var fileArr:Array = fileRegistry.getRegister(FileRegistryType.TEXTURE) as Array;
			loadedFiles = 0;
			totalFiles = fileArr.length;
			
			centerText.text = "Loading textures\n" + loadedFiles + "/" + totalFiles + "\n" + ((loadedFiles / totalFiles) * 100).toFixed(2) + "%";
			
			textureDecoders = new Vector.<ImageDecoder>();
			var toLoad:uint = currentFile = Math.min(optionsRegistry.getRegister(OptionsRegistryType.NETWORK).threads, totalFiles);
			var loaded:uint = 0;
			
			currentFile--;
			
			while (loaded < toLoad) {
				textureDecoders.push(new ImageDecoder());
				textureDecoders[textureDecoders.length - 1].load(fileArr[loaded].url);
				
				loaded++;
			}
		}
		
		override public function resize():void {
			super.resize();
			
			if (centerText) {
				centerText.width = stage.stageWidth;
				centerText.height = stage.stageHeight;
			}
		}
		
		override public function destroy():void {
			super.destroy();
			
			Observer.remove(ImageDecoder.OBSERVERS, imageDecoderObserver);
		}
		
		//private
		private function onImageDecoderObserverNotify(sender:Object, event:String, data:Object):void {
			var isInVec:Boolean = false;
			
			for (var i:uint = 0; i < textureDecoders.length; i++) {
				if (sender === textureDecoders[i]) {
					isInVec = true;
					break;
				}
			}
			
			if (!isInVec) {
				return;
			}
			
			if (event == ImageDecoderEvent.COMPLETE) {
				onTextureDecoderComplete(sender as ImageDecoder, data as BitmapData);
			} else if (event == ImageDecoderEvent.ERROR) {
				centerText.text = "Error loading file\n" + (data as String);
			}
		}
		
		private function onTextureDecoderComplete(loader:ImageDecoder, bmd:BitmapData):void {
			var name:String = loader.file;
			name = name.replace(/\W|_/g, "_");
			textureRegistry.setRegister(name + "_bmd", bmd);
			
			loadedFiles++;
			centerText.text = "Loading textures\n" + loadedFiles + "/" + totalFiles + "\n" + ((loadedFiles / totalFiles) * 100).toFixed(2) + "%";
			
			if (currentFile < totalFiles - 1) {
				currentFile++;
				
				if (currentFile > totalFiles - 1) {
					trace("Skipping loading file " + currentFile);
					
					if (loadedFiles == totalFiles) {
						nextState();
						return;
					}
				}
				
				loader.load((fileRegistry.getRegister(FileRegistryType.TEXTURE) as Array)[currentFile].url);
			} else {
				if (loadedFiles == totalFiles) {
					nextState();
				}
			}
		}
	}
}
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
	import egg82.enums.OptionsRegistryType;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class TextureUtil {
		//vars
		
		//constructor
		public function TextureUtil() {
			
		}
		
		//public
		public static function getTextureAtlas(tex:Texture, rows:uint, cols:uint):TextureAtlas {
			var atlas:TextureAtlas = new TextureAtlas(tex);
			var width:Number = tex.width / cols;
			var height:Number = tex.height / rows;
			
			for (var i:uint = 0; i < cols; i++) {
				for (var j:uint = 0; j < rows; j++) {
					var rect:Rectangle = new Rectangle(i * width, j * height, width, height);
					
					atlas.addRegion((i + 1) + "_" + (j + 1), rect);
					atlas.addRegion((((i + 1) * cols) + (j + 1)).toString(), rect);
				}
			}
			
			return atlas;
		}
		public static function getTextureAtlasXML(tex:Texture, xml:XML):TextureAtlas {
			return new TextureAtlas(tex, xml);
		}
		
		public static function splitBMD(bmd:BitmapData, rows:uint, cols:uint):Vector.<BitmapData> {
			var retArr:Vector.<BitmapData> = new Vector.<BitmapData>();
			var width:Number = bmd.width / cols;
			var height:Number = bmd.height / rows;
			var copyPoint:Point = new Point();
			
			for (var i:uint = 0; i < rows; i++) {
				for (var j:uint = 0; j < cols; j++) {
					var rect:Rectangle = new Rectangle(j * width, i * height, width, height);
					var newBMD:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
					
					newBMD.copyPixels(bmd, rect, copyPoint);
					
					retArr.push(newBMD);
				}
			}
			
			return retArr;
		}
		
		public static function resizeBMD(bmd:BitmapData, width:uint, height:uint):BitmapData {
            var result:BitmapData = new BitmapData(width, height, true, 0x00000000);
            var matrix:Matrix = new Matrix();
			
            matrix.scale(width / bmd.width, height / bmd.height);
            result.draw(bmd, matrix);
			
            return result;
        }
		
		public static function getTexture(bmd:BitmapData):Texture {
			var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
			return Texture.fromBitmapData(bmd, optionsRegistry.getRegister(OptionsRegistryType.VIDEO).mipmap as Boolean, true);
		}
		public static function getImage(texture:Texture):Image {
			var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
			var retImage:Image = new Image(texture);
			
			retImage.smoothing = optionsRegistry.getRegister(OptionsRegistryType.VIDEO).textureFiltering as String;
			retImage.touchable = false;
			
			return retImage;
		}
		
		//private
		
	}
}
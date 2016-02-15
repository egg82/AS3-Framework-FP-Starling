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

package egg82.registry.nulls {
	import egg82.registry.interfaces.IRegistryUtil;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NullRegistryUtil implements IRegistryUtil {
		//vars
		
		//constructor
		public function NullRegistryUtil() {
			
		}
		
		//public
		public function initialize():void {
			
		}
		
		public function setFile(type:String, name:String, url:String):void {
			
		}
		public function getFile(type:String, name:String):String {
			return null;
		}
		/*public function removeFile(type:String, name:String):void {
			
		}*/
		
		public function setFont(name:String, font:Class):void {
			
		}
		public function getFont(name:String):Class {
			return null;
		}
		/*public function removeFont(name:String):void {
			
		}*/
		
		public function setOption(type:String, name:String, value:*):void {
			
		}
		public function getOption(type:String, name:String):* {
			return null;
		}
		/*public function removeOption(type:String, name:String):void {
			
		}*/
		
		public function setBitmapData(url:String, data:BitmapData):void {
			
		}
		public function getBitmapData(url:String):BitmapData {
			return null;
		}
		/*public function removeBitmapData(url:String):void {
			
		}*/
		
		public function setTexture(url:String, texture:Texture):void {
			
		}
		public function getTexture(url:String):Texture {
			return null;
		}
		/*public function removeTexture(url:String):void {
			
		}*/
		
		public function setAtlas(url:String, atlas:TextureAtlas):void {
			
		}
		public function getAtlas(url:String):TextureAtlas {
			return null;
		}
		/*public function removeAtlas(url:String):void {
			
		}*/
		
		public function setXML(url:String, xml:XML):void {
			
		}
		public function getXML(url:String):XML {
			return null;
		}
		/*public function removeXML(url:String):void {
			
		}*/
		
		public function stripURL(url:String):String {
			return null;
		}
		
		//private
		
	}
}
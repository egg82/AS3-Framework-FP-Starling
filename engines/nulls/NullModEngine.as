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

package egg82.engines.nulls {
	import egg82.engines.interfaces.IModEngine;
	import egg82.mod.Mod;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NullModEngine implements IModEngine {
		//vars
		
		//constructor
		public function NullModEngine() {
			
		}
		
		//public
		public function initialize():void {
		
		}
		
		public function load(url:String):uint {
			return 0;
		}
		public function loadBytes(bytes:ByteArray):uint {
			return 0;
		}
		public function unload(mod:uint):void {
		
		}
		
		public function createChannel(name:String):void {
		
		}
		public function removeChannel(name:String):void {
		
		}
		public function sendMessage(mod:uint, channel:String, data:Object):void {
		
		}
		
		public function getMod(index:uint):Mod {
			return null;
		}
		public function getIndex(mod:Mod):int {
			return -1;
		}
		public function get numMods():uint {
			return 0;
		}
		
		//private
		
	}
}
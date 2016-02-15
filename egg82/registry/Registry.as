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
	import egg82.events.registry.RegistryEvent;
	import egg82.patterns.Observer;
	import egg82.registry.interfaces.IRegistry;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Registry implements IRegistry {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		protected var initialized:Boolean = false;
		
		protected var registry:Array = new Array();
		
		//constructor
		public function Registry() {
			
		}
		
		//public
		public function initialize():void {
			initialized = true;
		}
		
		public function setRegister(type:String, data:*):void {
			var event:String = (registry[type]) ? ((data) ? RegistryEvent.VALUE_CHANGED : RegistryEvent.VALUE_REMOVED) : RegistryEvent.VALUE_ADDED;
			
			registry[type] = data;
			
			dispatch(event, {
				"name": type,
				"value": data
			});
		}
		public function getRegister(type:String):* {
			return registry[type];
		}
		
		public function clearRegistry():void {
			registry = new Array();
		}
		public function resetRegistry():void {
			
		}
		
		public function get registryNames():Vector.<String> {
			var retVec:Vector.<String> = new Vector.<String>();
			
			for (var i:String in registry) {
				retVec.push(i);
			}
			
			return retVec;
		}
		
		//private
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
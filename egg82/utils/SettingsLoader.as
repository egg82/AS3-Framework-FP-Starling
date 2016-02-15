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
	import egg82.events.SettingsLoaderEvent;
	import egg82.patterns.Observer;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.interfaces.ISettingsLoader;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class SettingsLoader implements ISettingsLoader {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		//constructor
		public function SettingsLoader() {
			
		}
		
		//public
		public function load(path:String, registry:IRegistry):void {
			var str:String = CookieUtil.getData(path, "data") as String;
			
			if (!str) {
				str = "";
			}
			
			var json:Object;
			
			try {
				json = JSON.parse(str);
			} catch (ex:Error) {
				dispatch(SettingsLoaderEvent.ERROR, "Error loading settings (" + ex.message + ")");
			}
			
			if (json) {
				setRegistry(json, registry);
			}
		}
		public function save(path:String, registry:IRegistry):void {
			var names:Vector.<String> = registry.registryNames;
			var arr:Object = new Object();
			
			for (var i:uint = 0; i < names.length; i++) {
				arr[names[i]] = registry.getRegister(names[i]);
			}
			
			CookieUtil.setData(path, "data", JSON.stringify(arr));
		}
		
		public function loadSave(path:String, registry:IRegistry):void {
			//load
			var str:String = CookieUtil.getData(path, "data") as String;
			
			if (!str) {
				str = "";
			}
			
			var json:Object;
			
			try {
				json = JSON.parse(str);
			} catch (ex:Error) {
				dispatch(SettingsLoaderEvent.ERROR, "Error loading settings (" + ex.message + ")");
			}
			
			if (json) {
				setRegistry(json, registry);
			}
			
			//save
			var names:Vector.<String> = registry.registryNames;
			var arr:Object = new Object();
			
			for (var i:uint = 0; i < names.length; i++) {
				arr[names[i]] = registry.getRegister(names[i]);
			}
			
			CookieUtil.setData(path, "data", JSON.stringify(arr));
		}
		
		//private
		private function setRegistry(from:Object, to:IRegistry):void {
			for (var i:String in from) {
				if (to.getRegister(i)) {
					if (from[i] is Array) {
						var arr:Array = to.getRegister(i) as Array;
						deepCopy(from[i], arr);
						to.setRegister(i, arr);
					} else if (getQualifiedClassName(from[i]) == "Object") {
						var obj:Object = to.getRegister(i) as Object;
						deepCopy(from[i], obj);
						to.setRegister(i, obj);
					} else {
						to.setRegister(i, from[i]);
					}
				}
			}
		}
		private function deepCopy(from:Object, to:Object):void {
			for (var i:String in from) {
				if (i in to) {
					if (from[i] is Array || getQualifiedClassName(from[i]) == "Object") {
						deepCopy(from[i], to[i]);
					} else {
						to[i] = from[i];
					}
				}
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
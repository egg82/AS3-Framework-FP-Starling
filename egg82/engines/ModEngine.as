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

package egg82.engines {
	import egg82.engines.interfaces.IModEngine;
	import egg82.events.engines.ModEngineEvent;
	import egg82.events.mod.ModEvent;
	import egg82.mod.Mod;
	import egg82.patterns.Observer;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class ModEngine implements IModEngine {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var mods:Vector.<Mod> = new Vector.<Mod>();
		private static var _initialized:Boolean = false;
		
		private var modObserver:Observer = new Observer();
		
		//constructor
		public function ModEngine() {
			
		}
		
		//public
		public function initialize():void {
			if (_initialized) {
				throw new Error("ModEngine already initialized");
			}
			_initialized = true;
			
			modObserver.add(onModObserverNotify);
			Observer.add(Mod.OBSERVERS, modObserver);
		}
		
		public function load(url:String):uint {
			mods.push(new Mod());
			mods[mods.length - 1].load(url);
			return mods.length - 1;
		}
		public function loadBytes(bytes:ByteArray):uint {
			mods.push(new Mod());
			mods[mods.length - 1].loadBytes(bytes);
			return mods.length - 1;
		}
		public function unload(mod:uint):void {
			if (mod >= mods.length) {
				return;
			}
			
			mods[mod].unload();
			mods.splice(mod, 1);
		}
		
		public function createChannel(name:String):void {
			for (var i:uint = 0; i < mods.length; i++) {
				mods[i].createChannel(name);
			}
		}
		public function removeChannel(name:String):void {
			for (var i:uint = 0; i < mods.length; i++) {
				mods[i].removeChannel(name);
			}
		}
		public function sendMessage(mod:uint, channel:String, data:Object):void {
			if (mod >= mods.length) {
				return;
			}
			
			mods[mod].sendMessage(channel, data);
		}
		
		public function getMod(index:uint):Mod {
			if (index >= mods.length) {
				return null;
			}
			
			return mods[index];
		}
		public function getIndex(mod:Mod):int {
			for (var i:uint = 0; i < mods.length; i++) {
				if (mods[i] === mod) {
					return i;
				}
			}
			
			return -1;
		}
		public function get numMods():uint {
			return mods.length;
		}
		
		//private
		private function onModObserverNotify(sender:Object, event:String, data:Object):void {
			var senderIndex:int = -1;
			
			for (var i:uint = 0; i < mods.length; i++) {
				if (sender === mods[i]) {
					senderIndex = i;
					break;
				}
			}
			
			if (senderIndex < 0) {
				return;
			}
			
			if (event == ModEvent.MESSAGE) {
				dispatch(ModEngineEvent.MOD_MESSAGE, {
					"mod": senderIndex,
					"channel": data.channel,
					"data": data.data
				});
			} else if (event == ModEvent.PROGRESS) {
				dispatch(ModEngineEvent.MOD_PROGRESS, {
					"mod": senderIndex,
					"loaded": data.loaded,
					"total": data.total
				});
			} else if (event == ModEvent.DATA_LOADED) {
				dispatch(ModEngineEvent.MOD_DATA_LOADED, senderIndex);
			} else if (event == ModEvent.LOADED) {
				dispatch(ModEngineEvent.MOD_LOADED, senderIndex);
				checkLoaded();
			} else if (event == ModEvent.ERROR) {
				dispatch(ModEngineEvent.MOD_ERROR, {
					"mod": senderIndex,
					"error": data.error
				});
			} else if (event == ModEvent.TERMINATED) {
				dispatch(ModEngineEvent.MOD_TERMINATED, {
					"mod": senderIndex
				});
			}
		}
		
		private function checkLoaded():void {
			for (var i:uint = 0; i < mods.length; i++) {
				if (!mods[i].loaded) {
					return;
				}
			}
			
			dispatch(ModEngineEvent.LOADED);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
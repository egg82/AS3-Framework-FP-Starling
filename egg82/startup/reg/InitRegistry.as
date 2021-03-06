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

package egg82.startup.reg {
	import egg82.registry.Registry;
	import egg82.utils.CryptoUtil;
	import egg82.utils.MathUtil;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class InitRegistry extends Registry {
		//vars
		
		//constructor
		public function InitRegistry() {
			
		}
		
		//public
		override public function initialize():void {
			if (initialized) {
				return;
			}
			super.initialize();
			
			setRegister("preInitState", null);
			setRegister("postInitState", null);
			setRegister("logging", false);
			setRegister("frameworkVersion", "0.1a");
			setRegister("debug", Capabilities.isDebugger);
			
			if (Capabilities.isDebugger) {
				var str:String = "";
				var len:int = (20971520 - 24) / 2;
				for (var i:uint = 0; i < len; i++) {
					str += "0";
				}
				setRegister("memoryHandicap", str);
				
				setRegister("cpuHandicap", new Timer(17));
				(getRegister("cpuHandicap") as Timer).addEventListener(TimerEvent.TIMER, onCPUTimer, false, 0, true);
				(getRegister("cpuHandicap") as Timer).start();
			}
		}
		
		//private
		private function onCPUTimer(e:TimerEvent):void {
			var bytes:ByteArray = new ByteArray();
			
			for (var i:uint = 0; i < 256; i++) {
				bytes.writeByte(MathUtil.betterRoundedRandom(-256, 256));
			}
			
			bytes.compress();
			CryptoUtil.hashMd5(CryptoUtil.toString(CryptoUtil.encode(bytes)));
		}
	}
}
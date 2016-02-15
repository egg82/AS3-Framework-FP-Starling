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

package egg82.engines.loggers {
	import egg82.engines.ModEngine;
	import egg82.enums.LogLevel;
	import egg82.log.interfaces.ILogger;
	import egg82.mod.Mod;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.Util;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author egg82
	 */
	public class LoggingModEngine extends ModEngine {
		//vars
		private var logger:ILogger = ServiceLocator.getService("logger") as ILogger;
		
		//constructor
		public function LoggingModEngine() {
			
		}
		
		//public
		override public function initialize():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Initialized", LogLevel.INFO);
			super.initialize();
		}
		
		override public function load(url:String):uint {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([url]), LogLevel.INFO);
			return super.load(url);
		}
		override public function loadBytes(bytes:ByteArray):uint {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([bytes]), LogLevel.INFO);
			return super.loadBytes(bytes);
		}
		override public function unload(mod:uint):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([mod]), LogLevel.INFO);
			super.unload(mod);
		}
		
		override public function createChannel(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.createChannel(name);
		}
		override public function removeChannel(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.removeChannel(name);
		}
		override public function sendMessage(mod:uint, channel:String, data:Object):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([mod, channel, data]), LogLevel.INFO);
			super.sendMessage(mod, channel, data);
		}
		
		override public function getMod(index:uint):Mod {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([index]), LogLevel.INFO);
			return super.getMod(index);
		}
		override public function getIndex(mod:Mod):int {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([mod]), LogLevel.INFO);
			return super.getIndex(mod);
		}
		
		//private
		override protected function dispatch(event:String, data:Object = null):void {
			try {
				logger.writeLog("[" + getQualifiedClassName(this) + "] Dispatched event \"" + event + "\" with data " + JSON.stringify(data), LogLevel.INFO);
			} catch (ex:Error) {
				//logger.writeLog("[" + getQualifiedClassName(this) + "] Error while dispatching event \"" + event + "\": " + ex.message, LogLevel.WARNING);
			}
			
			super.dispatch(event, data);
		}
	}
}
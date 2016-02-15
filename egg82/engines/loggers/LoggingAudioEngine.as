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
	import egg82.engines.AudioEngine;
	import egg82.enums.LogLevel;
	import egg82.log.interfaces.ILogger;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.Util;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class LoggingAudioEngine extends AudioEngine {
		//vars
		private var logger:ILogger = ServiceLocator.getService("logger") as ILogger;
		
		//constructor
		public function LoggingAudioEngine() {
			
		}
		
		//public
		override public function initialize():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Initialized", LogLevel.INFO);
			super.initialize();
		}
		
		override public function setAudio(name:String, fileType:String, audioType:String, data:ByteArray):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name, fileType, audioType, data]), LogLevel.INFO);
			super.setAudio(name, fileType, audioType, data);
		}
		override public function getAudio(name:String):ByteArray {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			return super.getAudio(name);
		}
		override public function removeAudio(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.removeAudio(name);
		}
		
		override public function playAudio(name:String, repeat:Boolean = false):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name, repeat]), LogLevel.INFO);
			super.playAudio(name, repeat);
		}
		override public function pauseAudio(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.pauseAudio(name);
		}
		override public function stopAudio(name:String):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name]), LogLevel.INFO);
			super.stopAudio(name);
		}
		override public function setAudioPosition(name:String, position:Number):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([name, position]), LogLevel.INFO);
			super.setAudioPosition(name, position);
		}
		
		override public function resetVolumes():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this), LogLevel.INFO);
			super.resetVolumes();
		}
		
		//private
		override protected function dispatch(event:String, data:Object = null):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Dispatched event \"" + event + "\" with data " + JSON.stringify(data), LogLevel.INFO);
			super.dispatch(event, data);
		}
	}
}
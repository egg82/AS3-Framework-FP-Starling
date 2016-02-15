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
	import egg82.engines.InputEngine;
	import egg82.enums.LogLevel;
	import egg82.events.engines.InputEngineEvent;
	import egg82.log.interfaces.ILogger;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.Util;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	public class LoggingInputEngine extends InputEngine {
		//vars
		private var logger:ILogger = ServiceLocator.getService("logger") as ILogger;
		
		//constructor
		override public function LoggingInputEngine() {
			
		}
		
		//public
		override public function initialize():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Initialized", LogLevel.INFO);
			super.initialize();
		}
		
		override public function isKeysDown(keyCodes:Array):Boolean {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([keyCodes]), LogLevel.INFO);
			return super.isKeysDown(keyCodes);
		}
		override public function isButtonsDown(controller:uint, buttonCodes:Array):Boolean {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([controller, buttonCodes]), LogLevel.INFO);
			return super.isButtonsDown(controller, buttonCodes);
		}
		override public function isSticksPressed(controller:uint, stickCodes:Array):Boolean {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([controller, stickCodes]), LogLevel.INFO);
			return super.isSticksPressed(controller, stickCodes);
		}
		
		override public function isMouseDown(mouseCodes:Array):Boolean {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([mouseCodes]), LogLevel.INFO);
			return super.isMouseDown(mouseCodes);
		}
		
		override public function getTrigger(controller:uint, trigger:uint):Number {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([controller, trigger]), LogLevel.INFO);
			return super.getTrigger(controller, trigger);
		}
		override public function getStickProperties(controller:uint, stick:uint):Point {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([controller, stick]), LogLevel.INFO);
			return super.getStickProperties(controller, stick);
		}
		override public function getStick(controller:uint, stick:uint):Point {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([controller, stick]), LogLevel.INFO);
			return super.getStick(controller, stick);
		}
		
		override public function isUsingController():Boolean {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this), LogLevel.INFO);
			return super.isUsingController();
		}
		
		//private
		override protected function dispatch(event:String, data:Object = null):void {
			if (event == InputEngineEvent.UPDATE || event == InputEngineEvent.POST_UPDATE) {
				return;
			}
			
			try {
				logger.writeLog("[" + getQualifiedClassName(this) + "] Dispatched event \"" + event + "\" with data " + JSON.stringify(data), LogLevel.INFO);
			} catch (ex:Error) {
				//logger.writeLog("[" + getQualifiedClassName(this) + "] Error while dispatching event \"" + event + "\": " + ex.message, LogLevel.WARNING);
			}
			
			super.dispatch(event, data);
		}
	}
}
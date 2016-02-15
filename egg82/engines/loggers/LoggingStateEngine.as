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
	import egg82.base.BaseState;
	import egg82.engines.StateEngine;
	import egg82.enums.LogLevel;
	import egg82.events.engines.StateEngineEvent;
	import egg82.log.interfaces.ILogger;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.Util;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class LoggingStateEngine extends StateEngine {
		//vars
		private var logger:ILogger = ServiceLocator.getService("logger") as ILogger;
		
		//constructor
		public function LoggingStateEngine() {
			
		}
		
		//public
		override public function initialize(initState:Class, initStateArgs:Array = null):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Initialized with params" + JSON.stringify([getQualifiedClassName(initState)]), LogLevel.INFO);
			super.initialize(initState, initStateArgs);
		}
		
		override public function addState(newState:Class, newStateArgs:Array = null, addAt:uint = 0):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([getQualifiedClassName(newState), addAt]), LogLevel.INFO);
			super.addState(newState, newStateArgs, addAt);
		}
		override public function swapStates(newState:Class, newStateArgs:Array = null, swapAt:uint = 0):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([getQualifiedClassName(newState), swapAt]), LogLevel.INFO);
			super.swapStates(newState, newStateArgs, swapAt);
		}
		override public function removeState(index:uint):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([index]), LogLevel.INFO);
			super.removeState(index);
		}
		
		override public function getState(index:uint):BaseState {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([index]), LogLevel.INFO);
			return super.getState(index);
		}
		
		override public function get deltaTime():Number {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this), LogLevel.INFO);
			return super.deltaTime;
		}
		
		override public function resize():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this), LogLevel.INFO);
			super.resize();
		}
		
		//private
		override protected function dispatch(event:String, data:Object = null):void {
			if (calculatedSteps > 1 && event == StateEngineEvent.UPDATE) {
				logger.writeLog("[" + getQualifiedClassName(this) + "] Skipped " + calculatedSteps + " steps", LogLevel.WARNING);
			}
			
			if (event == StateEngineEvent.UPDATE || event == StateEngineEvent.DRAW) {
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
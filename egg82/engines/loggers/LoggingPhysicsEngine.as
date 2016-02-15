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
	import egg82.engines.PhysicsEngine;
	import egg82.enums.LogLevel;
	import egg82.log.interfaces.ILogger;
	import egg82.patterns.ServiceLocator;
	import egg82.utils.Util;
	import flash.utils.getQualifiedClassName;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class LoggingPhysicsEngine extends PhysicsEngine {
		//vars
		private var logger:ILogger = ServiceLocator.getService("logger") as ILogger;
		
		//constructor
		public function LoggingPhysicsEngine() {
		
		}
		
		//public
		override public function initialize():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Initialized", LogLevel.INFO);
			super.initialize();
		}
		
		override public function addBody(body:Body):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([body]), LogLevel.INFO);
			super.addBody(body);
		}
		override public function removeBody(body:Body):void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([body]), LogLevel.INFO);
			super.removeBody(body);
		}
		override public function removeAllBodies():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this), LogLevel.INFO);
			super.removeAllBodies();
		}
		
		override public function refactor():void {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this), LogLevel.INFO);
			super.refactor();
		}
		
		override public function getBody(index:uint):Body {
			logger.writeLog("[" + getQualifiedClassName(this) + "] Called " + Util.getFunctionName(arguments.callee, this) + " with params " + JSON.stringify([index]), LogLevel.INFO);
			return super.getBody(index);
		}
		
		//private
		
	}
}
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

package egg82.log.nulls {
	import egg82.log.interfaces.ILogger;
	import egg82.log.Log;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NullLogger implements ILogger {
		//vars
		
		//constructor
		public function NullLogger() {
			
		}
		
		//public
		public function writeLog(info:String, level:String):void {
			
		}
		public function flushLogs():void {
			
		}
		
		public function getLog(index:uint):Log {
			return null;
		}
		public function getLogIndex(log:Log):int {
			return -1;
		}
		
		public function get numLogs():uint {
			return 0;
		}
		
		//private
		
	}
}
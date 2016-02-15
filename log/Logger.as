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

package egg82.log {
	import egg82.log.interfaces.ILogger;
	import egg82.utils.CookieUtil;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Logger implements ILogger {
		//vars
		private var dateFormatter:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
		private var timeFormatter:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
		
		private var currentLog:Vector.<Log> = new Vector.<Log>();
		private var logFiles:Vector.<String> = new Vector.<String>();
		private var logFileLevels:Vector.<String> = new Vector.<String>();
		
		private var cookieName:String = "logs";
		
		//constructor
		public function Logger(cookieName:String = "logs") {
			if (cookieName && cookieName != "") {
				this.cookieName = cookieName;
			}
			
			dateFormatter.setDateTimePattern("dd-MM-yyyy");
			timeFormatter.setDateTimePattern("HH:mm:ss.SSSS");
		}
		
		//public
		public function writeLog(info:String, level:String):void {
			var date:Date = new Date();
			var compiledPath:String = dateFormatter.format(date) + "-" + level.toLocaleLowerCase();
			
			if (logFiles.indexOf(compiledPath) == -1) {
				logFiles.push(compiledPath);
				logFileLevels.push(level);
			}
			
			currentLog.push(new Log(info, level, date));
			trace("[" + timeFormatter.format(date) + "] [" + level.toLocaleUpperCase() + "] " + info);
		}
		public function flushLogs():void {
			for (var i:uint = 0; i < logFiles.length; i++) {
				var compiled:String = "";
				for (var j:uint = 0; j < currentLog.length; j++) {
					if (currentLog[j].level == logFileLevels[i]) {
						compiled += "[" + timeFormatter.format(currentLog[j].date) + "] [" + currentLog[j].level.toLocaleUpperCase() + "] " + currentLog[j].info + "\n";
					}
				}
				
				if (compiled != "") {
					var str:String = CookieUtil.getData(cookieName, logFiles[i]) as String;
					str += compiled;
					CookieUtil.setData(cookieName, logFiles[i], str);
				}
			}
			
			currentLog = new Vector.<Log>();
			logFiles = new Vector.<String>();
			logFileLevels = new Vector.<String>();
		}
		
		public function getLog(index:uint):Log {
			if (index >= currentLog.length) {
				return null;
			}
			 
			return currentLog[index];
		}
		public function getLogIndex(log:Log):int {
			for (var i:uint = 0; i < currentLog.length; i++) {
				if (log === currentLog[i]) {
					return i;
				}
			}
			 
			return -1;
		}
		public function get numLogs():uint {
			return currentLog.length;
		}
		
		//private
		
	}
}
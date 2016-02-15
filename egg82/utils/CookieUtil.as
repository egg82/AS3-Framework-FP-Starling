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
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CookieUtil {
		//vars
		private static var _cookieCache:Array = new Array();
		
		//constructor
		public function CookieUtil() {
			
		}
		
		//public
		public static function getAllData(name:String):Object {
			var cookie:SharedObject;
			
			cookie = _cookieCache[name];
			if (!cookie) {
				cookie = SharedObject.getLocal(name);
				_cookieCache[name] = cookie;
			}
			
			return cookie.data;
		}
		public static function getData(name:String, type:String):* {
			var cookie:SharedObject;
			
			cookie = _cookieCache[name];
			if (!cookie) {
				cookie = SharedObject.getLocal(name);
				_cookieCache[name] = cookie;
			}
			
			return cookie.data[type];
		}
		public static function setData(name:String, type:String, data:*):void {
			var cookie:SharedObject;
			
			cookie = _cookieCache[name];
			if (!cookie) {
				cookie = SharedObject.getLocal(name);
				_cookieCache[name] = cookie;
			}
			
			cookie.data[type] = data;
			cookie.flush();
		}
		
		public static function deleteCookie(name:String):void {
			var cookie:SharedObject;
			
			cookie = _cookieCache[name];
			
			if (!cookie) {
				cookie = SharedObject.getLocal(name);
			}
			
			cookie.clear();
			_cookieCache[name] = null;
		}
		
		//private
		
	}
}
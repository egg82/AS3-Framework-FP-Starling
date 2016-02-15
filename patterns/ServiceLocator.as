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

package egg82.patterns {
	import egg82.engines.InputEngine;
	import egg82.engines.AudioEngine;
	import egg82.engines.StateEngine;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class ServiceLocator {
		//vars
		private static var services:Array = new Array();
		private static var initializedServices:Array = new Array();
		
		//constructor
		public function ServiceLocator() {
			
		}
		
		//public
		public static function getService(type:String):Object {
			if (!initializedServices[type] && services[type]) {
				initializedServices[type] = new services[type]();
			}
			
			if (initializedServices[type]) {
				return initializedServices[type];
			}
			
			return null;
		}
		public static function provideService(type:String, service:Object, lazy:Boolean = true):void {
			if (initializedServices[type]) {
				var serviceObj:Object = initializedServices[type];
				
				if ("destroy" in serviceObj && serviceObj["destroy"] is Function) {
					(serviceObj["destroy"] as Function).call();
				} else if ("dispose" in serviceObj && serviceObj["dispose"] is Function) {
					serviceObj.dispose();
				}
			}
			
			services[type] = service;
			
			if (!lazy) {
				initializedServices[type] = new services[type]();
			}
		}
		
		//private
		
	}
}
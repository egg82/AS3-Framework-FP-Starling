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
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author ...
	 */
	
	public class Observer extends Signal {
		//vars
		
		//constructor
		public function Observer() {
			super(Object, String, Object)
		}
		
		//public
		public static function add(list:Vector.<Observer>, observer:Observer):void {
			if (!list || !observer) {
				return;
			}
			
			var index:int = list.indexOf(observer);
			
			if (index > -1) {
				return;
			}
			
			list.push(observer);
		}
		public static function remove(list:Vector.<Observer>, observer:Observer):void {
			if (!list || !observer) {
				return;
			}
			
			var index:int = list.indexOf(observer);
			
			if (index > -1) {
				list.splice(index, 1);
			}
		}
		
		public static function dispatch(list:Vector.<Observer>, sender:Object, event:String, data:Object = null):void {
			if (!list || list.length == 0) {
				return;
			}
			
			for (var i:uint = 0; i < list.length; i++) {
				list[i].dispatch(sender, event, data);
			}
		}
		
		//private
		
	}
}
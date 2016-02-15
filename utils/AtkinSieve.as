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
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class AtkinSieve {
		//vars
		
		//constructor
		public function AtkinSieve() {
		
		}
		
		//public
		public static function generate(max:int):Vector.<Boolean> {
			if (max < 3) {
				max = 3;
			}
			
			var sqrt:Number = Math.sqrt(max);
			var ret:Vector.<Boolean> = new Vector.<Boolean>();
			var n:uint;
			var x:uint;
			var i:uint;
			
			for (i = 0; i < max; i++) {
				ret[i] = false;
			}
			ret[2] = true;
			ret[3] = true;
			
			for (x = 1; x <= sqrt; x++) {
				for (var y:uint = 1; y <= sqrt; y++) {
					n = (4 * x * x) + (y * y);
					if (n <= max && (n % 12 == 1 || n % 12 == 5)) {
						ret[n] = !ret[n];
					}
					
					n = (3 * x * x) + (y * y);
					if (n <= max && n % 12 == 7) {
						ret[n] = !ret[n];
					}
					
					n = (3 * x * x) - (y * y);
					if (x > y && n <= max && n % 12 == 11) {
						ret[n] = !ret[n];
					}
				}
			}
			
			for (n = 5; n <= sqrt; n++) {
				if (ret[n]) {
					x = n * n;
					for (i = x; i <= max; i += x) {
						ret[i] = false;
					}
				}
			}
			
			return ret;
		}
		public static function normalize(raw:Vector.<Boolean>, min:uint, max:uint):Vector.<uint> {
			var ret:Vector.<uint> = new Vector.<uint>();
			
			if (max >= raw.length) {
				max = raw.length - 1;
			}
			
			for (var i:uint = min; i < max; i++) {
				if (raw[i]) {
					ret.push(i);
				}
			}
			
			return ret;
		}
		
		//private
		
	}
}
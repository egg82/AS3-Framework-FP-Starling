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
	
	public class MathUtil {
		//vars
		
		//constructor
		public function MathUtil() {
			
		}
		
		//public
		public static function random(min:Number, max:Number):Number {
			return Math.random() * (max - min) + min;
		}
		public static function betterRoundedRandom(min:int, max:int):int {
			var num:int;
			max++;
			
			do {
				num = Math.floor(Math.random() * (max - min) + min);
			} while (num > max - 1);
			
			return num;
		}
		
		public static function toXY(width:uint, x:uint, y:uint):uint {
			return y * width + x;
		}
		public static function toX(width:uint, xy:uint):uint {
			return xy % width;
		}
		public static function toY(width:uint, xy:uint):uint {
			return Math.floor(xy / width);
		}
		
		//private
		
	}
}
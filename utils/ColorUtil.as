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
	
	public class ColorUtil {
		//vars
		
		//constructor
		public function ColorUtil() {
			
		}
		
		//public
		public static function getA(color:uint):uint {
			return (color >> 24) & 0xFF
		}
		public static function getR(color:uint):uint {
			return color >> 16;
		}
		public static function getG(color:uint):uint {
			return (color >> 8) & 0xFF;
		}
		public static function getB(color:uint):uint {
			return color & 0x00FF;
		}
		
		public static function setColor(r:uint, g:uint, b:uint, a:uint):uint {
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
		//private
		
	}
}
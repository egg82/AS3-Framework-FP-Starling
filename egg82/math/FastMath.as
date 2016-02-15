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

package egg82.math {
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class FastMath {
		//vars
		
		//costructor
		public function FastMath() {
			
		}
		
		//public
		/**
		 * Faster Math.abs, 2x speed with 0% deviation
		 * 
		 * @param	val The number whose absolute value is returned.
		 * @return The absolute value of the specified paramater.
		 */
		public static function abs(val:Number):Number {
			return (val < 0) ? -val : val;
		}
		
		/*public static function acos(val:Number):Number {
			
		}
		
		public static function asin(val:Number):Number {
			
		}
		
		public static function atan(val:Number):Number {
			
		}*/
		
		/**
		 * Faster Math.atan2, 9x speed with 1% deviation
		 * 
		 * @param	y The y coordinate of the point.
		 * @param	x The x coordinate of the point.
		 * @return A number.
		 */
		public static function atan2(y:Number, x:Number):Number {
			if (y > 0) {
				if (x >= 0) {
					return 0.78539816339744830961566084581988 - 0.78539816339744830961566084581988 * (x - y) / (x + y);
				} else {
					return 2.3561944901923449288469825374596 - 0.78539816339744830961566084581988 * (x + y) / (y - x);
				}
			} else {
				if (x >= 0) {
					return -0.78539816339744830961566084581988 + 0.78539816339744830961566084581988 * (x + y) / (x - y);            
				}
			}
			
			return -2.3561944901923449288469825374596 - 0.78539816339744830961566084581988 * (x - y) / (y + x);
		}
		
		/**
		 * Faster Math.ceil, 6x speed with 0% deviation
		 * 
		 * @param	val A number or expression.
		 * @return An integer that is both closest to, and greater than or equal to, the parameter val.
		 */
		public static function ceil(val:Number):int {
			return (int(val) == val) ? val : ((val > 0) ? int(val + 1) : int(val));
		}
		
		/**
		 * Faster Math.cos, either 8x or 14x speed with 0% or 5% deviation
		 * 
		 * @param	angleRadians A number that represents an angle measured in radians.
		 * @param	fast False = 8x speed increase with 0% deviation, true = 14x speed increase with 5% deviation
		 * @return A number from -1.0 to 1.0.
		 */
		public static function cos(angleRadians:Number, fast:Boolean = false):Number {
			if (angleRadians < -3.14159265) {
				angleRadians += 6.28318531;
			} else if (angleRadians > 3.14159265) {
				angleRadians -= 6.28318531;
			}
			
			angleRadians += 1.57079632;
			if (angleRadians > 3.14159265) {
				angleRadians -= 6.28318531;
			}
			
			if (fast) {
				if (angleRadians < 0) {
					return 1.27323954 * angleRadians + 0.405284735 * angleRadians * angleRadians;
				} else {
					return 1.27323954 * angleRadians - 0.405284735 * angleRadians * angleRadians;
				}
			} else {
				var cos:Number;
				
				if (angleRadians < 0) {
					cos = 1.27323954 * angleRadians + 0.405284735 * angleRadians * angleRadians;
					
					if (cos < 0) {
						return 0.225 * (cos * -cos - cos) + cos;
					} else {
						return 0.225 * (cos * cos - cos) + cos;
					}
				} else {
					cos = 1.27323954 * angleRadians - 0.405284735 * angleRadians * angleRadians;
					
					if (cos < 0) {
						return 0.225 * (cos * -cos - cos) + cos;
					} else {
						return 0.225 * (cos * cos - cos) + cos;
					}
				}
			}
		}
		
		/*public static function exp(val:Number):Number {
			
		}*/
		
		/**
		 * Faster Math.floor, 6x speed with 0% deviation
		 * 
		 * @param	val A number or expression.
		 * @return The integer that is both closest to, and less than or equal to, the parameter val.
		 */
		public static function floor(val:Number):int {
			return (int(val) == val) ? val : ((val < 0) ? int(val - 1) : int(val));
		}
		
		/*public static function log(val:Number):Number {
			
		}
		
		public static function max(val1:Number, val2:Number, ...rest):Number {
			
		}
		
		public static function min(val1:Number, val2:Number, ...rest):Number {
			
		}
		
		public static function pow(base:Number, pow:Number):Number {
			
		}*/
		
		/**
		 * Faster Math.random, 15x speed with infinite deviation
		 * 
		 * @param	seed The seed value. Each seed generates a new number, however the same seed will generate the same number.
		 * @return
		 */
		public static function random(seed:Number):Number {
			return ((seed * 16807) % 2147483647) / 2147483647;
		}
		
		/*public static function round(val:Number):Number {
			
		}*/
		
		/**
		 * Faster Math.sin, either 8x or 14x speed with 0% or 5% deviation
		 * 
		 * @param	angleRadians A number that represents an angle measured in radians.
		 * @param	fast False = 8x speed increase with 0% deviation, true = 14x speed increase with 5% deviation
		 * @return A number from -1.0 to 1.0.
		 */
		public static function sin(angleRadians:Number, fast:Boolean = false):Number {
			if (angleRadians < -3.14159265) {
				angleRadians += 6.28318531;
			} else if (angleRadians > 3.14159265) {
				angleRadians -= 6.28318531;
			}
			
			if (fast) {
				if (angleRadians < 0) {
					return 1.27323954 * angleRadians + 0.405284735 * angleRadians * angleRadians;
				} else {
					return 1.27323954 * angleRadians - 0.405284735 * angleRadians * angleRadians;
				}
			} else {
				var sin:Number;
				
				if (angleRadians < 0) {
					sin = 1.27323954 * angleRadians + .405284735 * angleRadians * angleRadians;
					
					if (sin < 0) {
						return 0.225 * (sin * -sin - sin) + sin;
					} else {
						return 0.225 * (sin * sin - sin) + sin;
					}
				} else {
					sin = 1.27323954 * angleRadians - 0.405284735 * angleRadians * angleRadians;
					
					if (sin < 0) {
						return 0.225 * (sin * -sin - sin) + sin;
					} else {
						return 0.225 * (sin * sin - sin) + sin;
					}
				}
			}
		}
		
		/*public static function sqrt(val:Number):Number {
			
		}
		
		public static function tan(angleRadians:Number):Number {
			
		}*/
		
		public static function toRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		public static function toDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		//private
		
	}
}
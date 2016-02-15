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

package egg82.math.collision.quadtree {
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class QuadtreeObject {
		//vars
		public var object:Object;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		//constructor
		public function QuadtreeObject(object:Object, x:Number = 0, y:Number = 0, width:Number = 1, height:Number = 1) {
			if (width <= 0) {
				throw new Error("width cannot be less than or equal to zero.");
			}
			if (height <= 0) {
				throw new Error("height cannot be less than or equal to zero.");
			}
			
			this.object = object;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		//public
		
		//private
		
	}
}
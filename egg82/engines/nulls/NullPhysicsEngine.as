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

package egg82.engines.nulls {
	import egg82.engines.interfaces.IPhysicsEngine;
	import nape.phys.Body;
	import nape.space.Space;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NullPhysicsEngine implements IPhysicsEngine {
		//vars
		
		//constructor
		public function NullPhysicsEngine() {
		
		}
		
		//public
		public function initialize():void {
		
		}
		
		public function addBody(body:Body):void {
		
		}
		public function removeBody(body:Body):void {
		
		}
		public function removeAllBodies():void {
		
		}
		
		public function refactor():void {
		
		}
		
		public function getBody(index:uint):Body {
			return null;
		}
		public function get numBodies():uint {
			return 0;
		}
		
		public function update(deltaTime:Number):void {
		
		}
		public function draw():void {
			
		}
		public function resize():void {
			
		}
		
		public function get space():Space {
			return null;
		}
		
		public function get speed():Number {
			return 0;
		}
		public function set speed(val:Number):void {
			
		}
		
		//private
		
	}
}
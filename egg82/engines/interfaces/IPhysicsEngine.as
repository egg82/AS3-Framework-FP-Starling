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

package egg82.engines.interfaces {
	import nape.phys.Body;
	import nape.space.Space;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public interface IPhysicsEngine {
		//vars
		
		//constructor
		
		//public
		function initialize():void;
		
		function addBody(body:Body):void;
		function removeBody(body:Body):void;
		function removeAllBodies():void;
		
		function refactor():void;
		
		function getBody(index:uint):Body;
		function get numBodies():uint;
		
		function update(deltaTime:Number):void;
		function draw():void;
		function resize():void;
		
		function get space():Space;
		
		function get speed():Number;
		function set speed(val:Number):void;
		
		//private
		
	}
}
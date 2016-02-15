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
	import egg82.base.BaseState;
	import egg82.engines.interfaces.IStateEngine;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NullStateEngine implements IStateEngine {
		//vars
		
		//constructor
		public function NullStateEngine() {
			
		}
		
		//public
		public function get updateFps():Number {
			return 0;
		}
		public function set updateFps(val:Number):void {
			
		}
		
		public function get drawFps():Number {
			return 0;
		}
		public function set drawFps(val:Number):void {
			
		}
		
		public function get useTimestep():Boolean {
			return false;
		}
		public function set useTimestep(val:Boolean):void {
			
		}
		
		public function get skipMultiplePhysicsUpdate():Boolean {
			return false;
		}
		public function set skipMultiplePhysicsUpdate(val:Boolean):void {
			
		}
		
		public function initialize(initState:Class, initStateArgs:Array = null):void {
			
		}
		
		public function addState(newState:Class, newStateArgs:Array = null, addAt:uint = 0):void {
			
		}
		public function swapStates(newState:Class, newStateArgs:Array = null, swapAt:uint = 0):void {
			
		}
		public function removeState(index:uint):void {
			
		}
		
		public function getState(index:uint):BaseState {
			return null;
		}
		public function get numStates():uint {
			return 0;
		}
		
		public function get deltaTime():Number {
			return 0;
		}
		public function get calculatedSteps():uint {
			return 0;
		}
		
		public function resize():void {
			
		}
		
		//private
		
	}
}
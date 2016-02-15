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
	import egg82.engines.interfaces.IInputEngine;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class NullInputEngine implements IInputEngine {
		//vars
		private var blankPoint:Point = new Point();
		
		//constructor
		public function NullInputEngine() {
			
		}
		
		//public
		public function initialize():void {
			
		}
		public function isKeysDown(keyCodes:Array):Boolean {
			return false;
		}
		public function isButtonsDown(controller:uint, buttonCodes:Array):Boolean {
			return false;
		}
		public function isSticksPressed(controller:uint, stickCodes:Array):Boolean {
			return false;
		}
		
		public function isMouseDown(mouseCodes:Array):Boolean {
			return false;
		}
		
		public function get isLeftMouseDown():Boolean {
			return false;
		}
		public function get isMiddleMouseDown():Boolean {
			return false;
		}
		public function get isRightMouseDown():Boolean {
			return false;
		}
		
		public function get mousePosition():Point {
			return blankPoint;
		}
		public function get mouseWheelPosition():int {
			return 0;
		}
		
		public function get numControllers():uint {
			return 0;
		}
		public function getTrigger(controller:uint, trigger:uint):Number {
			return 0;
		}
		public function getStickProperties(controller:uint, stick:uint):Point {
			return blankPoint;
		}
		public function getStick(controller:uint, stick:uint):Point {
			return blankPoint;
		}
		
		public function isUsingController():Boolean {
			return false;
		}
		
		public function update():void {
			
		}
		public function postUpdate():void {
			
		}
		
		//private
		
	}
}
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
	import egg82.patterns.Observer;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public interface IInputEngine {
		//vars
		
		//constructor
		
		//public
		function initialize():void;
		
		function isKeysDown(keyCodes:Array):Boolean;
		function isButtonsDown(controller:uint, buttonCodes:Array):Boolean;
		function isSticksPressed(controller:uint, stickCodes:Array):Boolean;
		
		function isMouseDown(mouseCodes:Array):Boolean;
		
		function get isLeftMouseDown():Boolean;
		function get isMiddleMouseDown():Boolean;
		function get isRightMouseDown():Boolean;
		
		function get mousePosition():Point;
		function get mouseWheelPosition():int;
		
		function get numControllers():uint;
		function getTrigger(controller:uint, trigger:uint):Number;
		function getStickProperties(controller:uint, stick:uint):Point;
		function getStick(controller:uint, stick:uint):Point;
		
		function isUsingController():Boolean;
		
		function update():void;
		function postUpdate():void;
		
		//private
		
	}
}
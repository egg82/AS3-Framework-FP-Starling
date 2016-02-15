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

package egg82.engines {
	import egg82.engines.interfaces.IInputEngine;
	import egg82.enums.MouseCodes;
	import egg82.enums.OptionsRegistryType;
	import egg82.enums.XboxButtonCodes;
	import egg82.enums.XboxStickCodes;
	import egg82.events.engines.InputEngineEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import io.arkeus.ouya.controller.GameController;
	import io.arkeus.ouya.controller.Xbox360Controller;
	import io.arkeus.ouya.ControllerInput;
	import starling.core.Starling;
	
	public class InputEngine implements IInputEngine {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var keys:Vector.<Boolean> = new Vector.<Boolean>();
		private var xboxControllers:Vector.<Xbox360Controller> = new Vector.<Xbox360Controller>();
		
		private var _mouseLocation:Point = new Point();
		private var _mouseLocation2:Point = new Point();
		private var _stickProperties:Point = new Point();
		private var _stickPosition:Point = new Point();
		private var _mouseWheel:int = 0;
		
		private var _leftDown:Boolean = false;
		private var _middleDown:Boolean = false;
		private var _rightDown:Boolean = false;
		
		private var _lastUsingController:Boolean = false;
		
		private static var _initialized:Boolean = false;
		
		private var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		
		//constructor
		public function InputEngine() {
			
		}
		
		//public
		public function initialize():void {
			if (_initialized) {
				throw new Error("InputEngine already initialized");
			}
			_initialized = true;
			
			for (var i:uint = 0; i <= 255; i++) {
				keys.push(false);
			}
			
			ControllerInput.initialize(Starling.all[0].nativeStage);
			
			Starling.all[0].nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.all[0].nativeStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			Starling.all[0].nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Starling.all[0].nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			Starling.all[0].nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			Starling.all[0].nativeStage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleMouseDown);
			Starling.all[0].nativeStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
			
			Starling.all[0].nativeStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Starling.all[0].nativeStage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleMouseUp);
			Starling.all[0].nativeStage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
			
			dispatch(InputEngineEvent.INITIALIZE);
		}
		
		public function isKeysDown(keyCodes:Array):Boolean {
			keyCodes = cleanArray(keyCodes);
			
			for (var i:uint = 0; i < keyCodes.length; i++) {
				if (keyCodes[i] < keys.length && keys[keyCodes[i]]) {
					return true;
				}
			}
			
			return false;
		}
		public function isButtonsDown(controller:uint, buttonCodes:Array):Boolean {
			buttonCodes = cleanArray(buttonCodes);
			
			if (controller >= xboxControllers.length) {
				return false;
			}
			
			for (var i:uint = 0; i < buttonCodes.length; i++) {
				if (buttonCodes[i] == XboxButtonCodes.A && xboxControllers[controller].a.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.B && xboxControllers[controller].b.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.Y && xboxControllers[controller].y.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.X && xboxControllers[controller].x.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.LEFT_BUMPER && xboxControllers[controller].lb.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.RIGHT_BUMPER && xboxControllers[controller].rb.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.LEFT_STICK && xboxControllers[controller].leftStick.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.RIGHT_STICK && xboxControllers[controller].rightStick.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.START && xboxControllers[controller].start.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.BACK && xboxControllers[controller].back.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.UP && xboxControllers[controller].dpad.up.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.LEFT && xboxControllers[controller].dpad.left.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.DOWN && xboxControllers[controller].dpad.down.held) {
					return true;
				} else if (buttonCodes[i] == XboxButtonCodes.RIGHT && xboxControllers[controller].dpad.right.held) {
					return true;
				}
			}
			
			return false;
		}
		//TODO finish isSticksPressed function
		public function isSticksPressed(controller:uint, stickCodes:Array):Boolean {
			stickCodes = cleanArray(stickCodes);
			
			if (controller >= xboxControllers.length) {
				return false;
			}
			
			var leftStickAngle:Number = xboxControllers[controller].leftStick.angle * -1;
			var rightStickAngle:Number = xboxControllers[controller].rightStick.angle * -1;
			
			/*for (var i:uint = 0; i < stickCodes.length; i++) {
				if (stickCodes[i] == XboxStickCodes.LEFT_N) {
					return true;
				}
			}*/
			
			return false;
		}
		
		public function isMouseDown(mouseCodes:Array):Boolean {
			mouseCodes = cleanArray(mouseCodes);
			
			for (var i:uint = 0; i < mouseCodes.length; i++) {
				if (mouseCodes[i] == MouseCodes.LEFT && _leftDown) {
					return true;
				} else if (mouseCodes[i] == MouseCodes.MIDDLE && _middleDown) {
					return true;
				} else if (mouseCodes[i] == MouseCodes.RIGHT && _rightDown) {
					return true;
				}
			}
			
			return false;
		}
		
		public function get isLeftMouseDown():Boolean {
			return _leftDown;
		}
		public function get isMiddleMouseDown():Boolean {
			return _middleDown;
		}
		public function get isRightMouseDown():Boolean {
			return _rightDown;
		}
		
		public function get mousePosition():Point {
			return _mouseLocation2;
		}
		public function get mouseWheelPosition():int {
			return _mouseWheel;
		}
		
		public function get numControllers():uint {
			return xboxControllers.length;
		}
		public function getTrigger(controller:uint, trigger:uint):Number {
			if (controller >= xboxControllers.length || trigger > 1) {
				return 0;
			}
			
			return (trigger == 0) ? xboxControllers[controller].lt.value : xboxControllers[controller].rt.value;
		}
		public function getStickProperties(controller:uint, stick:uint):Point {
			_stickProperties.x = 0;
			_stickProperties.y = 0;
			
			if (controller >= xboxControllers.length || stick > 1) {
				return _stickProperties.clone();
			}
			
			_stickProperties.x = (stick == 0) ? xboxControllers[controller].leftStick.angle * -1 : xboxControllers[controller].rightStick.angle * -1;
			_stickProperties.y = (stick == 0) ? xboxControllers[controller].leftStick.distance : xboxControllers[controller].rightStick.distance;
			
			return _stickProperties.clone();
		}
		public function getStick(controller:uint, stick:uint):Point {
			_stickPosition.x = 0;
			_stickPosition.y = 0;
			
			if (controller >= xboxControllers.length || stick > 1) {
				return _stickPosition.clone();
			}
			
			_stickPosition.x = (stick == 0) ? xboxControllers[controller].leftStick.x : xboxControllers[controller].rightStick.x;
			_stickPosition.y = (stick == 0) ? xboxControllers[controller].leftStick.y : xboxControllers[controller].rightStick.y;
			
			return _stickPosition.clone();
		}
		
		public function isUsingController():Boolean {
			var stickDeadZone:Number = optionsRegistry.getRegister(OptionsRegistryType.CONTROLLER).deadZone as Number;
			
			if (xboxControllers.length == 0) {
				return false;
			}
			
			if (stickDeadZone < 0) {
				stickDeadZone = 0;
			}
			while (stickDeadZone > 1) {
				stickDeadZone /= 10;
			}
			
			for (var i:uint = 0; i < xboxControllers.length; i++) {
				if (getStickProperties(i, 0).y > stickDeadZone) {
					_lastUsingController = true;
					return true;
				} else if (getStickProperties(i, 1).y > stickDeadZone) {
					_lastUsingController = true;
					return true;
				}
				if (getTrigger(i, 0)) {
					_lastUsingController = true;
					return true;
				} else if (getTrigger(i, 1)) {
					_lastUsingController = true;
					return true;
				}
			}
			
			return _lastUsingController;
		}
		
		public function update():void {
			controllers();
			
			dispatch(InputEngineEvent.UPDATE);
		}
		public function postUpdate():void {
			_mouseWheel = 0;
			
			dispatch(InputEngineEvent.POST_UPDATE);
		}
		
		//private
		private function controllers():void {
			var i:uint;
			
			while (ControllerInput.hasReadyController()) {
				var addedController:GameController = ControllerInput.getReadyController();
				if (addedController is Xbox360Controller) {
					xboxControllers.push(addedController as Xbox360Controller);
				}
			}
			
			while (ControllerInput.hasRemovedController()) {
				var removedController:GameController = ControllerInput.getRemovedController();
				if (addedController is Xbox360Controller) {
					for (i = 0; i < xboxControllers.length; i++) {
						if (removedController === xboxControllers[i]) {
							xboxControllers.splice(i, 1);
							break;
						}
					}
				}
			}
			
			for (i = 0; i < xboxControllers.length; i++) {
				if (xboxControllers[i].a.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.A
					});
				} else if (xboxControllers[i].a.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.A
					});
				}
				
				if (xboxControllers[i].b.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.B
					});
				} else if (xboxControllers[i].b.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.B
					});
				}
				
				if (xboxControllers[i].y.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.Y
					});
				} else if (xboxControllers[i].y.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.Y
					});
				}
				
				if (xboxControllers[i].x.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.X
					});
				} else if (xboxControllers[i].x.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.X
					});
				}
				
				if (xboxControllers[i].lb.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.LEFT_BUMPER
					});
				} else if (xboxControllers[i].lb.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.LEFT_BUMPER
					});
				}
				
				if (xboxControllers[i].rb.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.RIGHT_BUMPER
					});
				} else if (xboxControllers[i].rb.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.RIGHT_BUMPER
					});
				}
				
				if (xboxControllers[i].leftStick.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.LEFT_STICK
					});
				} else if (xboxControllers[i].leftStick.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.LEFT_STICK
					});
				}
				
				if (xboxControllers[i].rightStick.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.RIGHT_STICK
					});
				} else if (xboxControllers[i].rightStick.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.RIGHT_STICK
					});
				}
				
				if (xboxControllers[i].start.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.START
					});
				} else if (xboxControllers[i].start.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.START
					});
				}
				
				if (xboxControllers[i].back.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.BACK
					});
				} else if (xboxControllers[i].back.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.BACK
					});
				}
				
				if (xboxControllers[i].dpad.up.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.UP
					});
				} else if (xboxControllers[i].dpad.up.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.UP
					});
				}
				
				if (xboxControllers[i].dpad.left.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.LEFT
					});
				} else if (xboxControllers[i].dpad.left.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.LEFT
					});
				}
				
				if (xboxControllers[i].dpad.down.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.DOWN
					});
				} else if (xboxControllers[i].dpad.down.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.DOWN
					});
				}
				
				if (xboxControllers[i].dpad.right.pressed) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_DOWN, {
						"controller": i,
						"code": XboxButtonCodes.RIGHT
					});
				} else if (xboxControllers[i].dpad.right.released) {
					_lastUsingController = true;
					dispatch(InputEngineEvent.BUTTON_UP, {
						"controller": i,
						"code": XboxButtonCodes.RIGHT
					});
				}
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			_lastUsingController = false;
			
			if (keys[e.keyCode]) {
				return;
			}
			
			keys[e.keyCode] = true;
			dispatch(InputEngineEvent.KEY_DOWN, {
				"stage": Starling.all[0].nativeStage,
				"code": e.keyCode
			});
		}
		private function onKeyUp(e:KeyboardEvent):void {
			keys[e.keyCode] = false;
			_lastUsingController = false;
			
			dispatch(InputEngineEvent.KEY_UP, {
				"stage": Starling.all[0].nativeStage,
				"code": e.keyCode
			});
		}
		
		private function onMouseMove(e:MouseEvent):void {
			_lastUsingController = false;
			
			var oldPoint:Point = _mouseLocation.clone();
			
			_mouseLocation2.x = _mouseLocation.x = e.stageX;
			_mouseLocation2.y = _mouseLocation.y = e.stageY;
			
			dispatch(InputEngineEvent.MOUSE_MOVE, {
				"stage": Starling.all[0].nativeStage,
				"oldPoint": oldPoint,
				"newPoint": _mouseLocation2
			});
		}
		private function onMouseWheel(e:MouseEvent):void {
			_lastUsingController = false;
			_mouseWheel = e.delta;
			
			dispatch(InputEngineEvent.MOUSE_WHEEL, {
				"stage": Starling.all[0].nativeStage,
				"value": _mouseWheel
			});
		}
		
		private function onMouseDown(e:MouseEvent):void {
			_lastUsingController = false;
			_leftDown = true;
			
			dispatch(InputEngineEvent.MOUSE_DOWN, {
				"stage": Starling.all[0].nativeStage,
				"code": MouseCodes.LEFT
			});
		}
		private function onMiddleMouseDown(e:MouseEvent):void {
			_lastUsingController = false;
			_middleDown = true;
			
			dispatch(InputEngineEvent.MOUSE_DOWN, {
				"stage": Starling.all[0].nativeStage,
				"code": MouseCodes.MIDDLE
			});
		}
		private function onRightMouseDown(e:MouseEvent):void {
			_lastUsingController = false;
			_rightDown = true;
			
			dispatch(InputEngineEvent.MOUSE_DOWN, {
				"stage": Starling.all[0].nativeStage,
				"code": MouseCodes.RIGHT
			});
		}
		
		private function onMouseUp(e:MouseEvent):void {
			_lastUsingController = false;
			_leftDown = false;
			
			dispatch(InputEngineEvent.MOUSE_UP, {
				"stage": Starling.all[0].nativeStage,
				"code": MouseCodes.LEFT
			});
		}
		private function onMiddleMouseUp(e:MouseEvent):void {
			_lastUsingController = false;
			_middleDown = false;
			
			dispatch(InputEngineEvent.MOUSE_UP, {
				"stage": Starling.all[0].nativeStage,
				"code": MouseCodes.MIDDLE
			});
		}
		private function onRightMouseUp(e:MouseEvent):void {
			_lastUsingController = false;
			_rightDown = false;
			
			dispatch(InputEngineEvent.MOUSE_UP, {
				"stage": Starling.all[0].nativeStage,
				"code": MouseCodes.RIGHT
			});
		}
		
		private function cleanArray(arr:Array):Array {
			var newArr:Array = new Array();
			
			for (var key:* in arr) {
				if (arr[key] is uint) {
					newArr.push(arr[key] as uint);
				}
			}
			
			return newArr;
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
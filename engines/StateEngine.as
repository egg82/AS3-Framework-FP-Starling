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
	import egg82.base.BaseState;
	import egg82.engines.interfaces.IInputEngine;
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.engines.interfaces.IStateEngine;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.engines.StateEngineEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.registry.interfaces.IRegistryUtil;
	import egg82.registry.RegistryUtil;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class StateEngine implements IStateEngine {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var _updateFps:Number = 60.0;
		private var _drawFps:Number = 60.0;
		private var _useTimestep:Boolean = true;
		private var _skipMultiplePhysicsUpdate:Boolean = false;
		
		private var states:Vector.<BaseState> = new Vector.<BaseState>();
		private var updateTimer:Timer = new Timer((1.0 / _updateFps) * 1000.0);
		private var drawTimer:Timer = new Timer((1.0 / _drawFps) * 1000.0);
		
		private var _deltaTime:Number = 0;
		private var lastUpdateTime:Number = getTimer();
		private var timestep:Number = _updateFps;
		private var fixedTimestepAccumulator:Number;
		private var _calculatedSteps:uint = 0;
		
		private var init:Class = null;
		private var initArgs:Array = null;
		private static var _initialized:Boolean = false;
		
		private var inputEngine:IInputEngine;
		private var physicsEngine:IPhysicsEngine;
		
		private var initRegistry:IRegistry = ServiceLocator.getService("initRegistry") as IRegistry;
		private var registryUtil:IRegistryUtil;
		
		private var registryUtilObserver:Observer = new Observer();
		
		//constructor
		public function StateEngine() {
			
		}
		
		//public
		public function get updateFps():Number {
			return _updateFps;
		}
		public function set updateFps(val:Number):void {
			_updateFps = val;
		}
		public function get drawFps():Number {
			return _drawFps;
		}
		public function set drawFps(val:Number):void {
			_drawFps = val;
		}
		public function get useTimestep():Boolean {
			return _useTimestep;
		}
		public function set useTimestep(val:Boolean):void {
			_useTimestep = val;
		}
		public function get skipMultiplePhysicsUpdate():Boolean {
			return _skipMultiplePhysicsUpdate;
		}
		public function set skipMultiplePhysicsUpdate(val:Boolean):void {
			_skipMultiplePhysicsUpdate = val;
		}
		
		public function initialize(initState:Class, initStateArgs:Array = null):void {
			if (_initialized) {
				throw new Error("StateEngine already initialized");
			}
			_initialized = true;
			
			if (!initState) {
				throw new Error("initState cannot be null");
			}
			
			registryUtil = ServiceLocator.getService("registryUtil") as IRegistryUtil;
			inputEngine = ServiceLocator.getService("inputEngine") as IInputEngine;
			physicsEngine = ServiceLocator.getService("physicsEngine") as IPhysicsEngine;
			
			drawTimer.addEventListener(TimerEvent.TIMER, onDraw);
			
			Starling.all[0].stage.addEventListener(ResizeEvent.RESIZE, onResize);
			
			fixedTimestepAccumulator = 0;
			timestep = _updateFps;
			
			init = initState;
			initArgs = initStateArgs;
			
			registryUtilObserver.add(onRegistryUtilObserverNotify);
			Observer.add(RegistryUtil.OBSERVERS, registryUtilObserver);
			
			Starling.all[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			dispatch(StateEngineEvent.INITIALIZE);
		}
		
		public function addState(newState:Class, newStateArgs:Array = null, addAt:uint = 0):void {
			var tmp:Object;
			var ns:BaseState;
			
			if (!newState || addAt > states.length) {
				return;
			}
			
			tmp = new newState();
			if (!(tmp is BaseState)) {
				return;
			}
			
			ns = tmp as BaseState;
			
			if (Starling.all[0].context) {
				updateTimer.stop();
				drawTimer.stop();
			}
			
			for (var i:uint = 0; i < states.length; i++) {
				states[i].touchable = false;
			}
			
			states.splice(addAt, 0, ns);
			Starling.all[0].stage.addChild(ns);
			
			ns.create.apply(null, [newStateArgs]);
			ns.resize();
			
			Starling.all[0].showStats = false;
			Starling.all[0].showStats = initRegistry.getRegister("debug");
			
			if (Starling.all[0].context) {
				updateTimer.start();
				drawTimer.start();
			}
		}
		public function swapStates(newState:Class, newStateArgs:Array = null, swapAt:uint = 0):void {
			var oldState:BaseState;
			var tmp:Object;
			var ns:BaseState;
			
			if (!newState || swapAt >= states.length) {
				return;
			}
			
			tmp = new newState();
			if (!(tmp is BaseState)) {
				return;
			}
			
			ns = tmp as BaseState;
			
			if (Starling.all[0].context) {
				updateTimer.stop();
				drawTimer.stop();
			}
			
			oldState = states.splice(swapAt, 1)[0];
			oldState.destroy();
			Starling.all[0].stage.removeChild(oldState);
			
			System.pauseForGCIfCollectionImminent(0.5);
			
			states.splice(swapAt, 0, ns);
			Starling.all[0].stage.addChild(ns);
			
			ns.create.apply(null, [newStateArgs]);
			ns.resize();
			
			Starling.all[0].showStats = false;
			Starling.all[0].showStats = initRegistry.getRegister("debug");
			
			if (Starling.all[0].context) {
				updateTimer.start();
				drawTimer.start();
			}
		}
		public function removeState(index:uint):void {
			var state:BaseState;
			
			if (index >= states.length) {
				return;
			}
			
			state = states.splice(index, 1)[0];
			state.destroy();
			Starling.all[0].stage.removeChild(state);
			
			System.pauseForGCIfCollectionImminent(0.5);
			
			if (states.length > 0) {
				states[0].touchable = true;
			}
		}
		
		public function getState(index:uint):BaseState {
			if (index >= states.length) {
				return null;
			}
			
			return states[index];
		}
		public function get numStates():uint {
			return states.length as uint;
		}
		
		public function get deltaTime():Number {
			return _deltaTime;
		}
		public function get calculatedSteps():uint {
			return _calculatedSteps;
		}
		
		public function resize():void {
			Starling.all[0].stage.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE, Starling.all[0].nativeStage.stageWidth, Starling.all[0].nativeStage.stageHeight));
		}
		
		//private
		private function onUpdate(e:TimerEvent):void {
			var time:Number;
			var timer:Number;
			var steps:uint;
			
			if (!_updateFps) {
				return;
			}
			
			dispatch(StateEngineEvent.UPDATE);
			
			if (_updateFps < 0) {
				updateTimer.delay = (1.0 / 60) * 1000.0;
			} else {
				updateTimer.delay = (1.0 / _updateFps) * 1000.0;
			}
			
			time = getTimer();
			_deltaTime = time - lastUpdateTime;
			lastUpdateTime = time;
			
			if (_useTimestep) {
				_calculatedSteps = steps = calculateSteps();
			} else {
				steps = 1;
			}
			
			inputEngine.update();
			var onceUpdated:Boolean = false;
			
			for (var i:uint = 0; i < steps; i++) {
				if (!onceUpdated && i > 0) {
					inputEngine.postUpdate();
					onceUpdated = true;
				}
				if (i == 0 || !_skipMultiplePhysicsUpdate) {
					physicsEngine.update((i == 0) ? _deltaTime / 1000 : getTimer() - timer);
				}
				
				for (var j:int = states.length - 1; j >= 0; j--) {
					if (!states[j]) {
						continue;
					}
					
					if (j == 0 || states[j].forceUpdate) {
						if (states[j].active) {
							states[j].update((i == 0) ? _deltaTime / 1000 : getTimer() - timer);
						}
					}
				}
				
				timer = getTimer();
			}
			
			if (!onceUpdated) {
				inputEngine.postUpdate();
			}
			
			for (j = states.length - 1; j >= 0; j--) {
				if (!states[j]) {
					continue;
				}
				
				if (j == 0 || states[j].forceUpdate) {
					if (states[j].active) {
						states[j].postUpdate();
					}
				}
			}
		}
		private function onDraw(e:*):void {
			if (!_drawFps) {
				return;
			}
			
			dispatch(StateEngineEvent.DRAW);
			
			if (_drawFps < 0) {
				drawTimer.delay = (1.0 / 60) * 1000.0;
			} else {
				drawTimer.delay = (1.0 / _drawFps) * 1000.0;
			}
			
			physicsEngine.draw();
			
			for (var j:int = 0; j < states.length; j++) {
				if (!states[j]) {
					continue;
				}
				
				if (j == 0 || states[j].forceUpdate) {
					if (states[j].active) {
						states[j].draw();
					}
				}
			}
		}
		
		private function calculateSteps():uint {
			var steps:uint;
			
			fixedTimestepAccumulator += _deltaTime / 1000;
			steps = Math.floor(fixedTimestepAccumulator / (1 / timestep));
			
			if (steps > 0) {
				fixedTimestepAccumulator -= steps * (1 / timestep);
			}
			
			return steps;
		}
		
		private function onResize(e:ResizeEvent):void {
			Starling.all[0].viewPort.width = e.width;
			Starling.all[0].viewPort.height = e.height;
			
			Starling.all[0].stage.stageWidth = e.width;
			Starling.all[0].stage.stageHeight = e.height;
			
			dispatch(StateEngineEvent.RESIZE);
			
			physicsEngine.resize();
			for (var i:uint = 0; i < states.length; i++) {
				states[i].resize();
			}
		}
		
		private function onRegistryUtilObserverNotify(sender:Object, event:String, data:Object):void {
			if (data.registry == "optionsRegistry") {
				checkOptions(data.type as String, data.name as String, data.value as Object);
			}
		}
		private function checkOptions(type:String, name:String, value:Object):void {
			if (type == OptionsRegistryType.VIDEO && name == "vsync") {
				if (value as Boolean) {
					drawTimer.stop();
					Starling.all[0].stage.addEventListener(Event.ENTER_FRAME, onDraw);
				} else {
					Starling.all[0].stage.removeEventListener(Event.ENTER_FRAME, onDraw);
					drawTimer.start();
				}
			}
		}
		
		private function onContextCreated(e:Event):void {
			Starling.all[0].removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			dispatch(StateEngineEvent.CONTEXT_CREATED);
			
			addState(init, initArgs);
			init = null;
			initArgs = null;
			
			resize();
			
			updateTimer.addEventListener(TimerEvent.TIMER, onUpdate);
			updateTimer.start();
			
			if (registryUtil.getOption(OptionsRegistryType.VIDEO, "vsync") as Boolean) {
				Starling.all[0].stage.addEventListener(Event.ENTER_FRAME, onDraw);
			} else {
				drawTimer.start();
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}

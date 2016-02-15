package egg82.engines {
	import egg82.engines.interfaces.IPhysicsEngine;
	import egg82.enums.OptionsRegistryType;
	import egg82.events.engines.PhysicsEngineEvent;
	import egg82.patterns.Observer;
	import egg82.patterns.ServiceLocator;
	import egg82.registry.interfaces.IRegistry;
	import egg82.utils.AtkinSieve;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class PhysicsEngine implements IPhysicsEngine {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var _velocityAccuracy:Number = 1;
		private var _positionAccuracy:Number = 1;
		private var _speed:Number = 1;
		
		private var _space:Space = null;
		private var factor:uint = 0;
		private var primes:Vector.<uint> = null;
		private var debug:ShapeDebug = new ShapeDebug(1, 1, 0x00000000);
		
		private static var _initialized:Boolean = false;
		
		private var initRegistry:IRegistry = ServiceLocator.getService("initRegistry") as IRegistry;
		private var optionsRegistry:IRegistry = ServiceLocator.getService("optionsRegistry") as IRegistry;
		
		private var collisionListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, onCollision);
		
		//constructor
		public function PhysicsEngine() {
		
		}
		
		//public
		public function initialize():void {
			if (_initialized) {
				throw new Error("PhysicsEngine already initialized");
			}
			_initialized = true;
			
			primes = AtkinSieve.normalize(AtkinSieve.generate(32), 0, 32);
			refactor();
			
			_space = new Space(Vec2.get());
			_space.worldLinearDrag = 0;
			_space.worldAngularDrag = 0;
			_space.listeners.add(collisionListener);
			
			if (initRegistry.getRegister("debug") as Boolean) {
				Starling.all[0].nativeOverlay.addChild(debug.display);
			}
		}
		
		public function addBody(body:Body):void {
			if (_space.bodies.has(body)) {
				return;
			}
			
			if (factor != 0) {
				body.shapes.foreach(checkVertices);
			}
			
			_space.bodies.add(body);
		}
		public function removeBody(body:Body):void {
			if (!_space.bodies.has(body)) {
				return;
			}
			
			_space.bodies.remove(body);
		}
		public function removeAllBodies():void {
			_space.bodies.clear();
		}
		
		public function refactor():void {
			var factor:Number;
			var tempFactor:Number;
			var i:uint;
			
			_velocityAccuracy = optionsRegistry.getRegister(OptionsRegistryType.PHYSICS).velocityAccuracy;
			_positionAccuracy = optionsRegistry.getRegister(OptionsRegistryType.PHYSICS).positionAccuracy;
			
			if (optionsRegistry.getRegister(OptionsRegistryType.PHYSICS).shapeAccuracy as Number == 1) {
				this.factor = 0;
				return;
			}
			
			factor = 1 / (1 - (optionsRegistry.getRegister(OptionsRegistryType.PHYSICS).shapeAccuracy as Number));
			
			if (factor == int(factor)) {
				this.factor = factor;
				return;
			}
			
			for (i = 0; i < primes.length; i++) {
				tempFactor = factor * primes[i];
				if (tempFactor == int(tempFactor)) {
					this.factor = primes[i];
					return;
				}
			}
			
			this.factor = 0;
		}
		
		public function getBody(index:uint):Body {
			if (index >= _space.bodies.length) {
				return null;
			}
			
			return _space.bodies.at(index);
		}
		public function get numBodies():uint {
			return _space.bodies.length;
		}
		
		public function update(deltaTime:Number):void {
			if (!_initialized) {
				return;
			}
			
			if (deltaTime <= 0) {
				deltaTime = 0.001;
			}
			
			_space.step(deltaTime * _speed, 20 * _velocityAccuracy, 20 * _positionAccuracy);
		}
		public function draw():void {
			if (_initialized && initRegistry.getRegister("debug") as Boolean) {
				debug.clear();
				debug.draw(_space);
				debug.flush();
			}
		}
		public function resize():void {
			if (_initialized && initRegistry.getRegister("debug") as Boolean) {
				Starling.all[0].nativeOverlay.removeChild(debug.display);
				debug = new ShapeDebug(Starling.all[0].stage.stageWidth, Starling.all[0].stage.stageHeight, 0x00000000);
				Starling.all[0].nativeOverlay.addChild(debug.display);
			}
		}
		
		public function get space():Space {
			return _space;
		}
		
		public function get speed():Number {
			return _speed;
		}
		public function set speed(val:Number):void {
			if (isNaN(val)) {
				return;
			}
			
			_speed = val;
		}
		
		//private
		private function checkVertices(shape:Shape):void {
			var poly:Polygon;
			
			if (!shape.isPolygon()) {
				return;
			}
			
			poly = shape as Polygon;
			
			if (poly.localVerts.length < 10) {
				return;
			}
			
			for (var i:uint = poly.localVerts.length; i >= 0; i--) {
				if (i % factor == 0) {
					poly.localVerts.remove(poly.localVerts.at(i));
				}
			}
		}
		
		private function onCollision(callback:InteractionCallback):void {
			var body1:Body = callback.int1.castBody;
			var body2:Body = callback.int2.castBody;
			
			dispatch(PhysicsEngineEvent.COLLIDE, {
				"body1": body1,
				"body2": body2
			});
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
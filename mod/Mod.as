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

package egg82.mod {
	import egg82.events.mod.ModEvent;
	import egg82.events.net.SimpleURLLoaderEvent;
	import egg82.mod.interfaces.IMod;
	import egg82.net.SimpleURLLoader;
	import egg82.patterns.Observer;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Mod implements IMod {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var loader:SimpleURLLoader;
		private var _loaded:Boolean = false;
		
		private var worker:Worker;
		private var incoming:Array;
		private var outgoing:Array;
		
		private var urlLoaderObserver:Observer = new Observer();
		
		//constructor
		public function Mod() {
			
		}
		
		//public
		public function load(path:String):void {
			if (_loaded) {
				return;
			}
			_loaded = true;
			
			urlLoaderObserver.add(onURLLoaderObserverNotify);
			Observer.add(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
			
			loader = new SimpleURLLoader();
			loader.load(path);
		}
		public function loadBytes(bytes:ByteArray):void {
			if (_loaded || !bytes || bytes.length == 0) {
				return;
			}
			_loaded = true;
			
			incoming = new Array();
			outgoing = new Array();
			
			worker = WorkerDomain.current.createWorker(bytes, true);
			worker.addEventListener(Event.WORKER_STATE, onWorkerState);
			worker.start();
		}
		public function unload():void {
			if (!_loaded) {
				return;
			}
			
			if (worker) {
				worker.terminate();
				worker = null;
				incoming = null;
				outgoing = null;
			}
			
			_loaded = false;
		}
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
		public function createChannel(name:String):void {
			if (!worker || !name || name == "" || this.incoming[name] || this.outgoing[name]) {
				return;
			}
			
			var incoming:MessageChannel = worker.createMessageChannel(Worker.current);
			var outgoing:MessageChannel = Worker.current.createMessageChannel(worker);
			
			this.incoming[name] = incoming;
			this.outgoing[name] = outgoing;
			
			incoming.addEventListener(Event.CHANNEL_MESSAGE, onMessage);
			
			worker.setSharedProperty(name + "_incoming", outgoing);
			worker.setSharedProperty(name + "_outgoing", incoming);
		}
		public function removeChannel(name:String):void {
			if (!worker || !name || name == "" || !this.incoming[name] || !this.outgoing[name]) {
				return;
			}
			
			var incoming:MessageChannel = this.incoming[name] as MessageChannel;
			var outgoing:MessageChannel = this.outgoing[name] as MessageChannel;
			
			worker.setSharedProperty(name + "_outgoing", null);
			incoming.removeEventListener(Event.CHANNEL_MESSAGE, onMessage);
			this.incoming[name] = null;
			
			worker.setSharedProperty(name + "_incoming", null);
			this.outgoing[name] = null;
		}
		public function sendMessage(channel:String, data:Object):void {
			if (!worker || !channel || channel == "" || !this.outgoing[channel]) {
				return;
			}
			
			var outgoing:MessageChannel = this.outgoing[channel] as MessageChannel;
			
			outgoing.send(data);
		}
		
		//private
		private function onURLLoaderObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== loader) {
				return;
			}
			
			if (event == SimpleURLLoaderEvent.PROGRESS) {
				dispatch(ModEvent.PROGRESS, {
					"loaded": data.loaded,
					"total": data.total
				});
			} else if (event == SimpleURLLoaderEvent.COMPLETE) {
				Observer.remove(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
				onComplete(data.data as ByteArray);
			} else if (event == SimpleURLLoaderEvent.ERROR) {
				Observer.remove(SimpleURLLoader.OBSERVERS, urlLoaderObserver);
				_loaded = false;
				dispatch(ModEvent.ERROR, {
					"error": data.error
				});
			}
		}
		
		private function onComplete(data:ByteArray):void {
			incoming = new Array();
			outgoing = new Array();
			
			dispatch(ModEvent.DATA_LOADED);
			
			worker = WorkerDomain.current.createWorker(data, true);
			worker.addEventListener(Event.WORKER_STATE, onWorkerState);
			worker.start();
		}
		
		private function onWorkerState(e:Event):void {
			if (worker.state == WorkerState.RUNNING) {
				dispatch(ModEvent.LOADED);
			} else if (worker.state == WorkerState.TERMINATED) {
				worker.removeEventListener(Event.WORKER_STATE, onWorkerState);
				
				worker = null;
				incoming = null;
				outgoing = null;
				_loaded = false;
				
				dispatch(ModEvent.TERMINATED);
			}
		}
		
		private function onMessage(e:Event):void {
			var channel:MessageChannel = e.target as MessageChannel;
			
			for (var key:String in incoming) {
				if (incoming[key] === channel) {
					dispatch(ModEvent.MESSAGE, {
						"channel": key,
						"data": channel.receive()
					});
					return;
				}
			}
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
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
	import egg82.events.mod.BaseModEvent;
	import egg82.patterns.Observer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class BaseMod extends Sprite {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var incoming:Array = new Array();
		private var outgoing:Array = new Array();
		
		//constructor
		public function BaseMod() {
			
		}
		
		//public
		
		//private
		protected function getChannel(name:String):void {
			if (!name || name == "") {
				return;
			}
			
			var incoming:MessageChannel = Worker.current.getSharedProperty(name + "_incoming");
			var outgoing:MessageChannel = Worker.current.getSharedProperty(name + "_outgoing");
			
			if (incoming && outgoing) {
				incoming.addEventListener(Event.CHANNEL_MESSAGE, onMessage);
				
				this.incoming[name] = incoming;
				this.outgoing[name] = outgoing;
			}
		}
		protected function sendMessage(channel:String, data:Object):void {
			if (!channel || channel == "" || !this.outgoing[channel]) {
				return;
			}
			
			var outgoing:MessageChannel = outgoing[channel] as MessageChannel;
			
			outgoing.send(data);
		}
		
		private function onMessage(e:Event):void {
			var channel:MessageChannel = e.target as MessageChannel;
			
			for (var key:String in incoming) {
				if (incoming[key] === channel) {
					dispatch(BaseModEvent.MESSAGE, {
						"channel": key,
						"data": channel.receive()
					});
					return;
				}
			}
		}
		
		protected function dispatch(event:String, data:Object):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
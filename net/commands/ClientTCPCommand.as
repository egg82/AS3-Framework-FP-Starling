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

package egg82.net.commands {
	import egg82.events.net.TCPClientEvent;
	import egg82.events.patterns.command.CommandEvent;
	import egg82.net.interfaces.ITCPClient;
	import egg82.net.TCPClient;
	import egg82.patterns.command.Command;
	import egg82.patterns.Observer;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class ClientTCPCommand extends Command {
		//vars
		private var client:ITCPClient;
		private var sendData:ByteArray;
		private var type:uint;
		private var expectResponse:Boolean;
		
		private var tcpClientObserver:Observer = new Observer();
		
		//constructor
		public function ClientTCPCommand(client:ITCPClient, data:ByteArray, type:uint, expectResponse:Boolean) {
			super(0);
			
			if (!client) {
				throw new Error("client cannot be null");
			}
			if (!data) {
				throw new Error("data cannot be null");
			}
			
			this.client = client;
			this.type = type;
			this.expectResponse = expectResponse;
			
			var newData:ByteArray = new ByteArray();
			
			newData.writeUnsignedInt(type);
			data.position = 0;
			data.readBytes(newData);
			
			sendData = newData;
			
			tcpClientObserver.add(onTcpClientObserverNotify);
		}
		
		//public
		
		//private
		override protected function execute():void {
			if (!client.connected) {
				throw new Error("client must be connected");
			}
			
			if (expectResponse) {
				Observer.add(TCPClient.OBSERVERS, tcpClientObserver);
				client.send(sendData);
			} else {
				client.send(sendData);
				dispatch(CommandEvent.COMPLETE);
			}
		}
		
		private function onTcpClientObserverNotify(sender:Object, event:String, data:Object):void {
			if (event == TCPClientEvent.ERROR) {
				Observer.remove(TCPClient.OBSERVERS, tcpClientObserver);
				dispatch(CommandEvent.ERROR, data);
			} else if (event == TCPClientEvent.DATA) {
				handleData(data as ByteArray);
			}
		}
		
		private function handleData(data:ByteArray):void {
			if (data.length < 4) {
				return;
			}
			
			data.position = 0;
			var type:uint = data.readUnsignedInt();
			
			if (type == this.type) {
				var newData:ByteArray = new ByteArray();
				data.readBytes(newData);
				
				Observer.remove(TCPClient.OBSERVERS, tcpClientObserver);
				dispatch(CommandEvent.COMPLETE, newData);
			}
		}
	}
}
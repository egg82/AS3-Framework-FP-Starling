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

package egg82.net {
	import egg82.events.net.TCPClientEvent;
	import egg82.net.interfaces.ITCPClient;
	import egg82.patterns.Observer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class TCPClient implements ITCPClient {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var socket:Socket = new Socket();
		private var backlog:Vector.<ByteArray>;
		private var sending:Boolean;
		
		//constructor
		public function TCPClient() {
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onOutputProgress);
			socket.addEventListener(Event.CLOSE, onClose);
		}
		
		//public
		public function connect(host:String, port:uint):void {
			if (port > 65535 || socket.connected) {
				return;
			}
			
			sending = true;
			try {
				socket.connect(host, port);
			} catch (ex:Error) {
				dispatch(TCPClientEvent.ERROR, ex.message);
				return;
			}
			
			backlog = new Vector.<ByteArray>();
		}
		public function disconnect():void {
			if (!socket.connected) {
				return;
			}
			
			try {
				socket.close();
			} catch (ex:Error) {
				dispatch(TCPClientEvent.ERROR, ex.message);
				return;
			}
			
			backlog = null;
			
			dispatch(TCPClientEvent.DISCONNECTED);
		}
		
		public function send(data:ByteArray):void {
			if (!socket.connected || !data || data.length == 0) {
				return;
			}
			
			if (sending || backlog.length > 0) {
				backlog.push(data);
			} else {
				sending = true;
				sendInternal(data);
			}
		}
		
		public function get connected():Boolean {
			return socket.connected;
		}
		
		//private
		private function sendInternal(data:ByteArray):void {
			try {
				socket.writeBytes(data);
				socket.flush();
			} catch (ex:Error) {
				dispatch(TCPClientEvent.ERROR, ex.message);
				return;
			}
			
			dispatch(TCPClientEvent.DEBUG, "Sent " + data.length + " bytes");
		}
		
		private function onIOError(e:IOErrorEvent):void {
			dispatch(TCPClientEvent.ERROR, e.text);
			disconnect();
		}
		private function onSecurityError(e:SecurityErrorEvent):void {
			dispatch(TCPClientEvent.ERROR, e.text);
			disconnect();
		}
		
		private function onConnect(e:Event):void {
			sending = false;
			
			dispatch(TCPClientEvent.CONNECTED);
			sendNext();
		}
		private function onSocketData(e:ProgressEvent):void {
			dispatch(TCPClientEvent.DOWNLOAD_PROGRESS, {
				"loaded": e.bytesLoaded,
				"total": socket.bytesAvailable + socket.bytesPending
			});
			
			if (e.bytesLoaded < socket.bytesAvailable + socket.bytesPending) {
				return;
			}
			
			var temp:ByteArray = new ByteArray();
			socket.readBytes(temp);
			temp.position = 0;
			
			dispatch(TCPClientEvent.DEBUG, "Received " + temp.length + " bytes");
			dispatch(TCPClientEvent.DATA, temp);
		}
		private function onOutputProgress(e:OutputProgressEvent):void {
			dispatch(TCPClientEvent.UPLOAD_PROGRESS, {
				"loaded": e.bytesTotal - e.bytesPending,
				"total": e.bytesTotal
			});
			
			if (e.bytesPending == 0) {
				dispatch(TCPClientEvent.UPLOAD_COMPLETE);
				sendNext();
			}
		}
		private function onClose(e:Event):void {
			backlog = null;
			dispatch(TCPClientEvent.DISCONNECTED);
		}
		
		private function sendNext():void {
			if (backlog.length == 0) {
				sending = false;
				return;
			}
			
			dispatch(TCPClientEvent.SEND_NEXT);
			
			sendInternal(backlog.splice(0, 1)[0]);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
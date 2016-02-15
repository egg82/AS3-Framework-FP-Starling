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
	import egg82.enums.net.commands.ClientDHKeyCommandType;
	import egg82.enums.ProtocolType;
	import egg82.events.patterns.command.CommandEvent;
	import egg82.net.interfaces.ITCPClient;
	import egg82.patterns.command.Command;
	import egg82.patterns.Observer;
	import egg82.utils.CryptoUtil;
	import egg82.utils.MathUtil;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class ClientDHKeyCommand extends Command {
		//vars
		private var client:ITCPClient;
		private var tcpCommand:ClientTCPCommand;
		private var commandObserver:Observer = new Observer();
		
		private var p:uint = 0;
		private var g:uint = 0;
		private var aa:uint = 0;
		private var bb:uint = 0;
		
		private var a:uint = 0;
		private var _s:uint = 0;
		
		private var _key:String = "";
		
		//constructor
		public function ClientDHKeyCommand(client:ITCPClient) {
			super(0);
			
			if (!client) {
				throw new Error("client cannot be null");
			}
			
			this.client = client;
			commandObserver.add(onCommandObserverNotify);
		}
		
		//public
		
		//private
		override protected function execute():void {
			var data:ByteArray = new ByteArray();
			data.writeUnsignedInt(ClientDHKeyCommandType.REQUEST);
			
			Observer.add(Command.OBSERVERS, commandObserver);
			
			tcpCommand = new ClientTCPCommand(client, data, ProtocolType.DH_HANDSHAKE, true);
			tcpCommand.start();
		}
		
		private function onCommandObserverNotify(sender:Object, event:String, data:Object):void {
			if (sender !== tcpCommand) {
				return;
			}
			
			if (event == CommandEvent.ERROR) {
				Observer.remove(Command.OBSERVERS, commandObserver);
				dispatch(CommandEvent.ERROR, data);
			} else if (event == CommandEvent.COMPLETE) {
				handleData(data as ByteArray);
			}
		}
		
		private function handleData(data:ByteArray):void {
			if (data.bytesAvailable < 4) {
				return;
			}
			
			var type:uint = data.readUnsignedShort();
			var ret:ByteArray = new ByteArray();
			
			if (type == ClientDHKeyCommandType.FCG) {
				if (data.bytesAvailable < 8) {
					return;
				}
				
				p = data.readUnsignedInt();
				g = data.readUnsignedInt();
				a = generateA(g);
				aa = generateAA(g, a, p);
				
				ret.writeUnsignedInt(ClientDHKeyCommandType.HANDSHAKE);
				ret.writeUnsignedInt(aa);
			} else if (type == ClientDHKeyCommandType.HANDSHAKE) {
				if (data.bytesAvailable < 4) {
					return;
				}
				
				bb = data.readUnsignedInt();
				_s = generateS(bb, a, p);
				
				var key:ByteArray = new ByteArray();
				while (data.bytesAvailable >= 4) {
					key.writeByte(data.readInt() / _s);
				}
				_key = CryptoUtil.hashMd5(CryptoUtil.toString(key));
				
				ret.writeUnsignedInt(ClientDHKeyCommandType.TEST);
			} else if (type == ClientDHKeyCommandType.TEST) {
				if (CryptoUtil.toString(CryptoUtil.decryptAes(data, _key)) == "testTESTtextTEXT") {
					Observer.remove(Command.OBSERVERS, commandObserver);
					dispatch(CommandEvent.COMPLETE);
				} else {
					execute();
				}
				
				return;
			} else {
				return;
			}
			
			tcpCommand = new ClientTCPCommand(client, ret, ProtocolType.DH_HANDSHAKE, true);
			tcpCommand.start();
		}
		
		private function generateA(g:uint):uint {
			return MathUtil.betterRoundedRandom(0, g);
		}
		private function generateAA(g:uint, a:uint, p:uint):uint {
			return (g ^ a) % p;
		}
		private function generateS(bb:uint, a:uint, p:uint):uint {
			return (bb ^ a) % p;
		}
	}
}
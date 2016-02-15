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
	import egg82.enums.ProtocolType;
	import egg82.net.interfaces.ITCPServer;
	import egg82.patterns.command.Command;
	import egg82.patterns.Observer;
	import egg82.utils.MathUtil;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class ServerDHKeyCommand extends Command {
		//vars
		private var server:ITCPServer;
		private var client:uint;
		private var tcpCommand:ServerTCPCommand;
		private var commandObserver:Observer = new Observer();
		
		private var p:uint = 0;
		private var g:uint = 0;
		private var aa:uint = 0;
		private var bb:uint = 0;
		
		private var b:uint = 0;
		private var _s:uint = 0;
		
		private var _key:String = "";
		
		//constructor
		public function ServerDHKeyCommand(server:ITCPServer, client:uint) {
			super(0);
			
			if (!server) {
				throw new Error("server cannot be null");
			}
			
			this.server = server;
			this.client = client;
			commandObserver.add(onCommandObserverNotify);
		}
		
		//public
		override protected function execute():void {
			Observer.add(Command.OBSERVERS, commandObserver);
		}
		
		//private
		private function generateP(highPrimes:Vector.<uint>):uint {
			return highPrimes[MathUtil.betterRoundedRandom(0, highPrimes.length - 1)];
		}
		private function generateG(p:uint, lowPrimes:Vector.<uint>):uint {
			return getRandomPrimitiveRoot(p, lowPrimes);
		}
		private function generateB(g:uint):uint {
			return MathUtil.betterRoundedRandom(0, g);
		}
		private function generateBB(g:uint, b:uint, p:uint):uint {
			return (g ^ b) % p;
		}
		private function generateS(aa:uint, b:uint, p:uint):uint {
			return (aa ^ b) % p;
		}
		
		private function getRandomPrimitiveRoot(p:uint, lowPrimes:Vector.<uint>):uint {
			var i:uint;
			
			var phi:uint = p - 1;
			var factors:Vector.<uint> = normalizePrimeFactors(getPrimeFactors(phi));
			var powers:Vector.<uint> = new Vector.<uint>();
			
			for (i = 0; i < factors.length; i++) {
				powers.push(phi / factors[i]);
			}
			
			var x:uint;
			var good:Boolean;
			
			do {
				x = lowPrimes[MathUtil.betterRoundedRandom(0, lowPrimes.length - 1)];
				good = true;
				
				for (i = 0; i < powers.length; i++) {
					if ((x ^ powers[i]) % p == 1) {
						good = false;
						break;
					}
				}
			} while (!good);
			
			return x;
		}
		
		private function getPrimeFactors(n:uint):Vector.<uint> {
			var a:Vector.<uint> = new Vector.<uint>();
			
			for (var i:uint = 2; i <= n / i; i++) {
				while (n % i == 0) {
					a.push(i);
					n = n / i;
				}
			}
			
			if (n > 1) {
				a.push(n);
			}
			
			return a;
		}
		private function normalizePrimeFactors(raw:Vector.<uint>):Vector.<uint> {
			var retVec:Vector.<uint> = new Vector.<uint>();
			
			for (var i:uint = 0; i < raw.length; i++) {
				if (retVec.indexOf(raw[i]) > -1) {
					continue;
				}
				retVec.push(raw[i]);
			}
			
			return retVec;
		}
	}
}
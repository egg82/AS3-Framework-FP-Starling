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

package egg82.utils {
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class DHHandshakeUtil {
		//vars
		private var highPrimes:Vector.<uint> = null;
		private var lowPrimes:Vector.<uint> = null;
		
		private var handshakeP:uint;
		private var handshakeG:uint;
		private var handshakeAA:uint;
		private var handshakeBB:uint;
		
		private var clientA:uint;
		private var clientS:uint;
		private var clientKey:String;
		
		//private var serverQ:uint;
		private var serverB:uint;
		private var serverS:uint;
		private var serverKey:String;
		
		//constructor
		public function DHHandshakeUtil() {
		
		}
		
		//public
		public function initialize():void {
			var primes:Vector.<Boolean> = AtkinSieve.generate(4194304);
			lowPrimes = AtkinSieve.normalize(primes, 0, (primes.length - primes.length / 4) - 1);
			highPrimes = AtkinSieve.normalize(primes, primes.length - primes.length / 4, primes.length);
		}
		
		public function step1Server():void {
			handshakeP = serverGenerateP();
			handshakeG = serverGenerateG(handshakeP);
		}
		public function step2Client():void {
			clientA = clientGenerateA(handshakeG);
			handshakeAA = clientGenerateAA(handshakeG, clientA, handshakeP);
		}
		public function step3Server():void {
			serverB = serverGenerateB(handshakeG);
			serverS = serverGenerateS(handshakeAA, serverB, handshakeP);
			
			handshakeBB = serverGenerateBB(handshakeG, serverB, handshakeP);
			serverKey = CryptoUtil.hashMd5(handshakeP + "." + handshakeG + "." + serverS);
		}
		public function step4Client():void {
			clientS = clientGenerateS(handshakeBB, clientA, handshakeP);
			clientKey = CryptoUtil.hashMd5(handshakeP + "." + handshakeG + "." + clientS);
		}
		
		public function getKeys():void {
			trace("Shared: P=" + handshakeP + ", G=" + handshakeG + ", AA=" + handshakeAA + ", BB=" + handshakeBB);
			trace("Client: A=" + clientA + ", S=" + clientS + ", key=" + clientKey);
			trace("Server: B=" + serverB + ", S=" + serverS + ", key=" + serverKey);
			trace((clientKey == serverKey) ? "match" : "mismatch");
			
			var strArr:ByteArray = new ByteArray();
			strArr.writeUTFBytes("testing");
			var decrypted:ByteArray = decrypt(encrypt(strArr, clientS), serverS);
			trace(decrypted.readUTFBytes(decrypted.length));
		}
		
		public function encrypt(bytes:ByteArray, s:uint):ByteArray {
			var retArr:ByteArray = new ByteArray();
			
			try {
				bytes.position = 0;
			} catch (ex:Error) {
				
			}
			
			while (bytes.position < bytes.length) {
				retArr.writeInt(bytes.readByte() * s);
			}
			retArr.position = 0;
			
			return retArr;
		}
		public function decrypt(bytes:ByteArray, s:uint):ByteArray {
			var retArr:ByteArray = new ByteArray();
			
			try {
				bytes.position = 0;
			} catch (ex:Error) {
				
			}
			
			while (bytes.position < bytes.length) {
				retArr.writeByte(bytes.readInt() / s);
			}
			retArr.position = 0;
			
			return retArr;
		}
		
		public function clientGenerateA(g:uint):uint {
			return MathUtil.betterRoundedRandom(0, g);
		}
		public function clientGenerateAA(g:uint, a:uint, p:uint):uint {
			return (g ^ a) % p;
		}
		public function clientGenerateS(bb:uint, a:uint, p:uint):uint {
			return (bb ^ a) % p;
		}
		
		public function serverGenerateP():uint {
			return highPrimes[MathUtil.betterRoundedRandom(0, highPrimes.length - 1)];
		}
		public function serverGenerateG(p:uint):uint {
			return getRandomPrimitiveRoot(p);
		}
		public function serverGenerateB(g:uint):uint {
			return MathUtil.betterRoundedRandom(0, g);
		}
		public function serverGenerateBB(g:uint, b:uint, p:uint):uint {
			return (g ^ b) % p;
		}
		public function serverGenerateS(aa:uint, b:uint, p:uint):uint {
			return (aa ^ b) % p;
		}
		
		//private
		private function getRandomPrimitiveRoot(p:uint):uint {
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
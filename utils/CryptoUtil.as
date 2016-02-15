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
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.NullPad;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class CryptoUtil {
		//vars
		private static var md5:MD5 = new MD5();
		private static var sha1:SHA1 = new SHA1();
		
		//constructor
		public function CryptoUtil() {
			
		}
		
		//public
		public static function toArray(input:String):ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(input);
			bytes.position = 0;
			
			return bytes;
		}
		public static function toString(input:ByteArray):String {
			return input.readUTFBytes(input.length);
		}
		
		public static function hashMd5(input:String):String {
			return Hex.fromArray(md5.hash(Hex.toArray(Hex.fromString(input))));
		}
		public static function hashSha1(input:String):String {
			return Hex.fromArray(sha1.hash(Hex.toArray(Hex.fromString(input))));
		}
		
		public static function encode(input:ByteArray):ByteArray {
			return toArray(Base64.encodeByteArray(input));
		}
		public static function decode(input:ByteArray):ByteArray {
			var bytes:ByteArray = Base64.decodeToByteArray(toString(input));
			bytes.position = 0;
			return bytes;
		}
		
		public static function encryptAes(input:ByteArray, key:String):ByteArray {
			var kData:ByteArray = Base64.decodeToByteArray(key);
			var data:ByteArray = new ByteArray();
			var pad:IPad = new NullPad();
			var mode:ICipher = Crypto.getCipher("simple-aes-cbc", kData, pad);
			
			input.position = 0;
			input.readBytes(data);
			data.position = 0;
			
			pad.setBlockSize(128);
			mode.encrypt(data);
			
			data.position = 0;
			
			return data;
		}
		public static function decryptAes(input:ByteArray, key:String):ByteArray {
			var kData:ByteArray = Base64.decodeToByteArray(key);
			var data:ByteArray = new ByteArray();
			var pad:IPad = new NullPad();
			var mode:ICipher = Crypto.getCipher("simple-aes-cbc", kData, pad);
			
			input.position = 0;
			input.readBytes(data);
			data.position = 0;
			
			pad.setBlockSize(128);
			mode.decrypt(data);
			
			data.position = 0;
			
			return data;
		}
		
		//private
		
	}
}
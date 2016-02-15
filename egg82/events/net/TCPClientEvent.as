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

package egg82.events.net {
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class TCPClientEvent {
		//vars
		public static const CONNECTED:String = "connected";
		public static const ERROR:String = "error";
		public static const DATA:String = "data";
		public static const DEBUG:String = "debug";
		public static const DOWNLOAD_PROGRESS:String = "downloadProgress";
		public static const UPLOAD_PROGRESS:String = "uploadProgress";
		public static const UPLOAD_COMPLETE:String = "uploadComplete";
		public static const DISCONNECTED:String = "disconnected";
		
		public static const SEND_NEXT:String = "sendNext";
		
		//constructor
		public function TCPClientEvent() {
			
		}
		
		//public
		
		//private
		
	}
}
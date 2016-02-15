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
	import flash.system.Security;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class NetUtil {
		//vars
		
		//constructor
		public function NetUtil() {
			
		}
		
		//public
		public static function loadPolicyFile(host:String, port:uint):void {
			if (port > 65535) {
				return;
			}
			
			try {
				Security.allowDomain(host);
				Security.allowInsecureDomain(host);
			} catch (ex:Error) {
				
			}
			
			if (host.search("://") > -1) {
				Security.loadPolicyFile(host + ":" + port);
				Security.loadPolicyFile(host + ":" + port + "/crossdomain.xml");
			} else {
				Security.loadPolicyFile("xmlsocket://" + host + ":" + port);
				Security.loadPolicyFile("https://" + host + ":" + port);
				Security.loadPolicyFile("http://" + host + ":" + port);
				
				Security.loadPolicyFile("xmlsocket://" + host + ":" + port + "/crossdomain.xml");
				Security.loadPolicyFile("https://" + host + ":" + port + "/crossdomain.xml");
				Security.loadPolicyFile("http://" + host + ":" + port + "/crossdomain.xml");
			}
		}
		
		public static function loadExactPolicyFile(url:String):void {
			try {
				Security.allowDomain(url);
				Security.allowInsecureDomain(url);
			} catch (ex:Error) {
				
			}
			
			Security.loadPolicyFile(url);
		}
		
		//private
		
	}
}
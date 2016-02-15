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

package egg82.sql {
	import com.maclema.mysql.Connection;
	import com.maclema.mysql.events.MySqlErrorEvent;
	import com.maclema.mysql.events.MySqlEvent;
	import com.maclema.mysql.MySqlToken;
	import com.maclema.mysql.Statement;
	import egg82.events.mysql.MySQLEvent;
	import egg82.patterns.Observer;
	import egg82.utils.NetUtil;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class MySQL {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var connection:Connection;
		private var backlog:Vector.<String>;
		private var backlogData:Vector.<Object>;
		
		private var host:String;
		
		//constructor
		public function MySQL() {
			
		}
		
		//public
		public function connect(host:String, user:String, pass:String, db:String, port:uint = 3306, policyPort:uint = 80):void {
			if (!host || host == "" || !user || user == "" || !pass || !db || db == "" || port > 65535 || !connection || !connection.connected) {
				return;
			}
			
			this.host = host + ":" + port;
			
			NetUtil.loadPolicyFile(host, policyPort);
			connection = new Connection(host, port, user, pass, db);
			backlog = new Vector.<String>();
			backlogData = new Vector.<Object>();
			
			connection.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			connection.addEventListener(MySqlErrorEvent.SQL_ERROR, onSQLError);
			connection.addEventListener(Event.CONNECT, onConnect);
			connection.addEventListener(Event.CLOSE, onClose);
			connection.connect();
		}
		public function disconnect():void {
			if (!connection || !connection.connected) {
				return;
			}
			
			connection.disconnect();
			connection = null;
			backlog = null;
			backlogData = null;
		}
		public function query(q:String, data:Object = null):void {
			if (!connection || !connection.connected || !q || q == "") {
				return;
			}
			
			if (connection.busy || backlog.length > 0) {
				backlog.push(query);
				backlogData.push(data);
			} else {
				queryInternal(q, data);
			}
		}
		
		public function get connected():Boolean {
			return (connection) ? connection.connected : false;
		}
		
		//private
		private function queryInternal(q:String, data:Object):void {
			backlogData.unshift(data);
			
			var statement:Statement = connection.createStatement();
			var token:MySqlToken = statement.executeQuery(q);
			
			token.addEventListener(MySqlErrorEvent.SQL_ERROR, onSQLError);
			token.addEventListener(MySqlEvent.RESULT, onResponse);
			token.addEventListener(MySqlEvent.RESPONSE, onResponse);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			if (!connection) {
				return;
			}
			
			dispatch(MySQLEvent.ERROR, {
				"error": e.text,
				"data": (backlogData.length > 0) ? backlogData.splice(0, 1)[0] : null
			});
		}
		private function onSQLError(e:MySqlErrorEvent):void {
			if (!connection) {
				return;
			}
			
			dispatch(MySQLEvent.ERROR, {
				"error": e.msg,
				"data": (backlogData.length > 0) ? backlogData.splice(0, 1)[0] : null
			});
		}
		private function onConnect(e:Event):void {
			dispatch(MySQLEvent.CONNECTED, host);
			sendNext();
		}
		private function onClose(e:Event):void {
			connection = null;
			backlog = null;
			backlogData = null;
			
			dispatch(MySQLEvent.DISCONNECTED, host);
		}
		
		private function onResponse(e:MySqlEvent):void {
			if (!connection) {
				return;
			}
			
			var resultSet:Array = e.resultSet.getRows() as Array;
			
			dispatch(MySQLEvent.RESULT, {
				"result": new MySQLResult((resultSet.length > 0) ? resultSet : null, e.insertID, e.affectedRows),
				"data": (backlogData.length > 0) ? backlogData.splice(0, 1)[0] : null
			});
			
			sendNext();
		}
		
		private function sendNext():void {
			if (!connection || !connection.connected || backlog.length == 0) {
				return;
			}
			
			dispatch(MySQLEvent.SEND_NEXT);
			
			queryInternal(backlog.splice(0, 1)[0], backlogData.splice(0, 1)[0]);
		}
		
		protected function dispatch(event:String, data:Object = null):void {
			Observer.dispatch(OBSERVERS, this, event, data);
		}
	}
}
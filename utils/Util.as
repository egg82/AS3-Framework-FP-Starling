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
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public class Util {
		//vars
		private static var timers:Vector.<Timer> = new Vector.<Timer>();
		private static var functions:Vector.<Function> = new Vector.<Function>();
		private static var parameters:Vector.<Array> = new Vector.<Array>();
		
		private static var cursorNames:Vector.<String> = new Vector.<String>();
		
		//constructor
		public function Util() {
			
		}
		
		//public
		public static function getObjectClass(obj:*):Class {
			return getDefinitionByName(getQualifiedClassName(obj)) as Class;
		}
		public static function getObjectClassName(obj:*):String {
			return getQualifiedClassName(obj);
		}
		
		public static function deepCopy(source:Object):* {
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeObject(source);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		public static function timedFunction(delay:Number, func:Function, params:Array):void {
			if (func == null) {
				return;
			}
			if (delay <= 0) {
				func.apply(null, params);
				return;
			}
			
			timers.push(new Timer(delay, 1));
			timers[timers.length - 1].addEventListener(TimerEvent.TIMER, onTimer);
			functions.push(func);
			parameters.push(params);
			timers[timers.length - 1].start();
		}
		
		public static function toByteArray(objs:Array):ByteArray {
			if (!objs) {
				return null;
			}
			
			var temp:ByteArray = new ByteArray();
			
			for each (var obj:* in objs) {
				//TODO: Figure out how to handle ByteArrays
				if (getQualifiedClassName(obj) == "String") {
					temp.writeUTF(obj as String);
				} else if (getQualifiedClassName(obj) == "Array") {
					toByteArray(obj as Array).readBytes(temp);
				}/* else if (obj is ByteArray) {
					(obj as ByteArray).readBytes(temp);
				}*/ else if (getQualifiedClassName(obj) == "Boolean") {
					temp.writeBoolean(obj as Boolean);
				} else if (getQualifiedClassName(obj) == "Number") {
					temp.writeDouble(obj as Number);
				} else if (getQualifiedClassName(obj) == "int") {
					temp.writeInt(obj as int);
				} else if (getQualifiedClassName(obj) == "uint") {
					temp.writeUnsignedInt(obj as uint);
				} else {
					temp.writeObject(temp as Object);
				}
			}
			
			temp.position = 0;
			return temp;
		}
		public static function fromByteArray(bytes:ByteArray, classes:Array):Array {
			if (!bytes || !classes || bytes.length == 0 || classes.length == 0) {
				return null;
			}
			
			var retArr:Array = new Array();
			
			bytes.position = 0;
			
			for each (var cl:* in classes) {
				if (!(cl is Class)) {
					return null;
				}
				
				try {
					//TODO: Figure out how to handle ByteArrays
					if (getQualifiedClassName(cl) == "String") {
						retArr.push(bytes.readUTF());
					} else if (getQualifiedClassName(cl) == "Array") {
						retArr.push(fromByteArray(bytes, classes));
					}/* else if (cl is ByteArray) {
						retArr.push(bytes
					}*/ else if (getQualifiedClassName(cl) == "Boolean") {
						retArr.push(bytes.readBoolean());
					} else if (getQualifiedClassName(cl) == "Number") {
						retArr.push(bytes.readDouble());
					} else if (getQualifiedClassName(cl) == "int") {
						retArr.push(bytes.readInt());
					} else if (getQualifiedClassName(cl) == "uint") {
						retArr.push(bytes.readUnsignedInt());
					} else {
						retArr.push(bytes.readObject() as cl);
					}
				} catch (e:Error) {
					return null;
				}
			}
			
			return retArr;
		}
		
		public static function setMouseCursor(name:String, bitmaps:Vector.<BitmapData>, framerate:uint, hotSpot:Point = null, replaceExisting:Boolean = false):void {
			if (framerate == 0) {
				return;
			}
			if ((!name || name == "") && (bitmaps && bitmaps.length > 0)) {
				return;
			}
			
			if (!bitmaps || bitmaps.length == 0) {
				Mouse.cursor = MouseCursor.AUTO;
				return;
			}
			if (!hotSpot) {
				hotSpot = new Point();
			}
			
			
			if (cursorNames.indexOf(name) == -1) {
				replaceExisting = true;
				cursorNames.push(name);
			} else {
				if (replaceExisting) {
					Mouse.unregisterCursor(name);
				}
			}
			
			if (replaceExisting) {
				var data:MouseCursorData = new MouseCursorData();
				data.data = bitmaps;
				data.hotSpot = hotSpot;
				data.frameRate = framerate;
				
				Mouse.registerCursor(name, data);
			}
			
			Mouse.cursor = name;
		}
		
		public static function getFunctionName(callee:Function, parent:Object):String {
			for each ( var m:XML in describeType(parent)..method) {
				if (parent[m.@name] == callee) return m.@name;
			}
			return "{Function name not found}";
		}
		
		public static function getEnums(c:Class):Array {
			var retArr:Array = new Array();
			
			var xml:XML = describeType(c);
			var xmlList:XMLList = xml.child("constant");
			
			for each (var child:XML in xmlList) {
				var name:String = child.attribute("name").toString();
				retArr[name] = c[name];
			}
			
			return retArr;
		}
		
		public static function toArray(iterable:*):Array {
			var retArr:Array = new Array();
			
			for each (var elem:* in iterable) {
				retArr.push(elem);
			}
			
			return retArr;
		}
		
		public static function vectorPos(item:*, vector:*):int {
			if (!(vector is Vector.<*>)) {
				return -1;
			}
			
			var vec:Vector.<*> = vector as Vector.<*>;
			
			for (var i:uint = 0; i < vec.length; i++) {
				if (item === vec[i]) {
					return i;
				}
			}
			
			return -1;
		}
		public static function arrayPos(item:*, array:Array):int {
			for (var i:uint = 0; i < array.length; i++) {
				if (item === array[i]) {
					return i;
				}
			}
			
			return -1;
		}
		
		//private
		private static function onTimer(e:TimerEvent):void {
			for (var i:uint = 0; i < timers.length; i++) {
				if (timers[i] === e.target) {
					timers[i].removeEventListener(TimerEvent.TIMER, onTimer);
					functions[i].apply(null, parameters[i]);
					
					timers.splice(i, 1);
					functions.splice(i, 1);
					parameters.splice(i, 1);
					
					return;
				}
			}
		}
	}
}
package egg82.custom {
	import egg82.events.custom.CustomButtonEvent;
	import egg82.patterns.Observer;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Alex
	 */
	
	public class CustomButton extends Image {
		//vars
		public static const OBSERVERS:Vector.<Observer> = new Vector.<Observer>();
		
		private var sentOnce:Boolean = false;
		
		private var upState:Texture = null;
		private var downState:Texture = null;
		private var overState:Texture = null;
		
		//constructor
		public function CustomButton(upState:String, downState:String = null, overState:String = null) {
			super(upState);
			touchable = true;
		}
		
		//public
		override public function create():void {
			addEventListener(TouchEvent.TOUCH, onTouch);
			super.create();
		}
		override public function destroy():void {
			removeEventListeners();
			super.destroy();
		}
		
		//private
		private function onTouch():void {
			if (!e.target) {
				return;
			}
			
			if (e.getTouch(e.target as DisplayObject, TouchPhase.HOVER) || e.getTouch(e.target as DisplayObject, TouchPhase.MOVED)) {
				if (!sentOnce) {
					sentOnce = true;
					dispatch(CustomButtonEvent.MOUSE_OVER);
				}
			} else {
				sentOnce = false;
				dispatch(CustomButtonEvent.MOUSE_OUT);
			}
			
			if (e.getTouch(e.target as DisplayObject, TouchPhase.BEGAN)) {
				dispatch(CustomButtonEvent.MOUSE_DOWN);
			}
			if (e.getTouch(e.target as DisplayObject, TouchPhase.ENDED)) {
				dispatch(CustomButtonEvent.MOUSE_UP);
			}
		}
	}
}
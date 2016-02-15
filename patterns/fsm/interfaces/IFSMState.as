package egg82.patterns.fsm.interfaces {
	
	/**
	 * ...
	 * @author egg82
	 */
	
	public interface IFSMState {
		//vars
		
		//constructor
		
		//public
		function enter():void;
		function update():void;
		function draw():void;
		function exit():void;
		
		function get exitStates():Vector.<String>;
		function addExitState(name:String):void;
		function removeExitState(name:String):void;
		
		//private
		
	}
}
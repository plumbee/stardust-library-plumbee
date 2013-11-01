package idv.cjcat.stardust.common.actions {
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This class is used internally by classes that implements the <code>ActionCollector</code> interface.
	 */
	public class ActionCollection implements ActionCollector {
		
		/** @private */
		sd var actions:Array;
		
		public function ActionCollection() {
			actions = [];
		}
		
		public final function addAction(action:Action):void {
			if (actions.indexOf(action) >= 0) return;
			actions.push(action);
			action.onPriorityChange.add(sortActions);
			sortActions();
		}
		
		public final function removeAction(action:Action):void {
			var index:int;
			if ((index = actions.indexOf(action)) >= 0) {
				var action:Action = Action(actions.splice(index, 1)[0]);
				action.onPriorityChange.remove(sortActions);
			}
		}
		
		public final function clearActions():void {
			for each (var action:Action in actions) removeAction(action);
		}
		
		public final function sortActions(action:Action = null):void {
			actions.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
		}
	}
}
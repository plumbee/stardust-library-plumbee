package idv.cjcat.stardust.common.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This actions is a group of actions. Multiple actions can be grouped together into one single composite action.
	 * 
	 * <p>
	 * Note that if the bitwise AND of a composite action's mask and a particle's mask is non-zero, 
	 * all underlying component actions' <code>update()</code> methods will be called for the particle, 
	 * without further checking the masks of these actions if the <code>checkComponentMasks</code> property is false, 
	 * which is false by default.
	 * </p>
	 */
	public class CompositeAction extends Action implements ActionCollector {
		
		public var checkComponentMasks:Boolean;
		
		/** @private */
		sd var actionCollection:ActionCollection;
		public function CompositeAction() {
			checkComponentMasks = false;
			actionCollection = new ActionCollection();
		}
		
		private var activeActions:Array;
		override public final function preUpdate(emitter:Emitter, time:Number):void {
			activeActions = [];
			for each (var action:Action in actionCollection.actions) {
				if (action.active) {
					if (action.mask) {
						activeActions.push(action);
						action.preUpdate(emitter, time);
					}
				}
			}
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var action:Action;
			if (checkComponentMasks) {
				for each (action in activeActions) {
					if (action.mask & particle.mask) action.update(emitter, particle, time);
				}
			} else {
				for each (action in activeActions) {
					action.update(emitter, particle, time);
				}
			}
		}
		
		override public final function postUpdate(emitter:Emitter, time:Number):void {
			activeActions = null;
		}
		
		/**
		 * Adds an action to the composite action.
		 * @param	action
		 */
		public function addAction(action:Action):void {
			actionCollection.actions.push(action);
			action.onPriorityChange.add(sortActions);
			sortActions();
		}
		
		/**
		 * Removes an action to the composite action.
		 * @param	action
		 */
		public function removeAction(action:Action):void {
			var index:int;
			while ((index = actionCollection.actions.indexOf(action)) >= 0) {
				var act:Action = actionCollection.actions.splice(index, 1)[0];
				act.onPriorityChange.remove(sortActions);
			}
		}
		
		/**
		 * Removes all actions from the composite action.
		 */
		public function clearActions():void {
			for each (var action:Action in actionCollection.actions) removeAction(action);
		}
		
		public final function sortActions(action:Action = null):void {
			actionCollection.actions.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
		}
		
		override public final function get needsSortedParticles():Boolean {
			for each (var action:Action in actionCollection.actions) {
				if (action.needsSortedParticles) return true;
			}
			return false;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return actionCollection.actions.concat();
		}
		
		override public function getXMLTagName():String {
			return "CompositeAction";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (xml.@checkComponentMasks.length()) xml.@checkComponentMasks = checkComponentMasks;
			
			if (actionCollection.actions.length > 0) {
				xml.appendChild(<actions/>);
				var action:Action;
				for each (action in actionCollection.actions) {
					xml.actions.appendChild(action.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			checkComponentMasks = (xml.@checkComponentMasks == "true");
			
			clearActions();
			for each (var node:XML in xml.actions.*) {
				addAction(Action(builder.getElementByName(node.@name)));
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
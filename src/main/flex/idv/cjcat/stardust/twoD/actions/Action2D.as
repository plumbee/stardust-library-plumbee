package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.actions.Action;
	
	/**
	 * Base class for 2D actions.
	 */
	public class Action2D extends Action {
		
		public function Action2D() {
			_supports3D = false;
			
			//priority = Action2DPriority.getInstance().getPriority(Object(this).constructor as Class);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Action2D";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
package idv.cjcat.stardust.twoD.actions {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.display.AddChildMode;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Reorders display objects' display list indices.
	 * 
	 * <p>
	 * Works only on particles initialized by the <code>DisplayObjectClass</code> class.
	 * </p>
	 */
	public class ReorderDisplayObject extends Action2D {
		
		/**
		 * For more information on add-child mode, refer to the <code>AddChildMode</code> class.
		 */
		public var addChildMode:int;
		public function ReorderDisplayObject(addChildMode:int = 0) {
			this.addChildMode = addChildMode;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p2D:Particle2D = Particle2D(particle);
			var displayObj:DisplayObject = p2D.target as DisplayObject;
			var container:DisplayObjectContainer = displayObj.parent as DisplayObjectContainer;
			switch (addChildMode) {
				case AddChildMode.TOP:
					container.addChild(displayObj);
					break;
				case AddChildMode.BOTTOM:
					container.addChildAt(displayObj, 0);
					break;
				default:
					container.addChildAt(displayObj, Math.floor(Math.random() * container.numChildren));
					break;
			}
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ReorderDisplayObject";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@addChildMode = addChildMode;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@addChildMode.length()) addChildMode = parseInt(xml.@addChildMode);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
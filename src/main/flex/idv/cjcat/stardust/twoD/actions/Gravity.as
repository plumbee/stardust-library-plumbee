package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	import idv.cjcat.stardust.twoD.fields.Field;
	import idv.cjcat.stardust.twoD.geom.MotionData2D;
	import idv.cjcat.stardust.twoD.geom.MotionData2DPool;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	use namespace sd;
	
	/**
	 * Applies accelerations to particles according to the associated gravity fields, in pixels.
	 * 
	 * <p>
	 * Default priority = -3;
	 * </p>
	 * 
	 * @see idv.cjcat.stardust.twoD.fields.Field
	 */
	public class Gravity extends Action2D {
		
		/** @private */
		sd var fields:Array;
		
		public function Gravity() {
			priority = -3;
			
			fields = [];
		}
		
		/**
		 * Adds a gravity field to the simulation.
		 * @param	field
		 */
		public function addField(field:Field):void {
			if (fields.indexOf(field) < 0) fields.push(field);
		}
		
		/**
		 * Removes a gravity field from the simulation.
		 * @param	field
		 */
		public function removeField(field:Field):void {
			var index:int = fields.indexOf(field);
			if (index >= 0) fields.splice(index, 1);
		}
		
		/**
		 * Removes all gravity fields from the simulation.
		 */
		public function clearFields():void {
			fields = [];
		}
		
		private var p2D:Particle2D;
		private var md2D:MotionData2D;
		private var field:Field;
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			p2D = Particle2D(particle);
			for each (field in fields) {
				md2D = field.getMotionData2D(p2D);
				if (md2D) {
					p2D.vx += md2D.x * time;
					p2D.vy += md2D.y * time;
					MotionData2DPool.recycle(md2D);
				}
			}
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return fields;
		}
		
		override public function getXMLTagName():String {
			return "Gravity";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (fields.length > 0) {
				xml.appendChild(<fields/>);
				var field:Field;
				for each (field in fields) {
					xml.fields.appendChild(field.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			clearFields();
			for each (var node:XML in xml.fields.*) {
				addField(builder.getElementByName(node.@name) as Field);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
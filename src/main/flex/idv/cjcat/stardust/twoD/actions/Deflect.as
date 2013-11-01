package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	import idv.cjcat.stardust.twoD.deflectors.Deflector;
	import idv.cjcat.stardust.twoD.geom.MotionData4D;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	use namespace sd;
	
	/**
	 * This action is useful to manipulate a particle's position and velocity as you like.
	 * 
	 * <p>
	 * Each deflector returns a <code>MotionData4D</code> object, which contains four numeric properties: x, y, vx, and vy, 
	 * according to the particle's positoin and velocity. 
	 * The particle's position and velocity are then reassigned to the new values (x, y) and (vx, vy), respectively.
	 * </p>
	 * 
	 * <p>
	 * Deflectors can be used to create obstacles, bounding boxes, etc. 
	 * </p>
	 * 
	 * <p>
	 * Default priority = -5;
	 * </p>
	 * 
	 * @see idv.cjcat.stardust.twoD.deflectors.Deflector
	 */
	public class Deflect extends Action2D {
		
		/** @private */
		sd var deflectors:Array;
		
		public function Deflect() {
			priority = -5;
			
			deflectors = [];
		}
		
		/**
		 * Adds a deflector to the simulation.
		 * @param	deflector
		 */
		public function addDeflector(deflector:Deflector):void {
			if (deflectors.indexOf(deflector) < 0) deflectors.push(deflector);
		}
		
		/**
		 * Removes a deflector from the simulation.
		 * @param	deflector
		 */
		public function removeDeflector(deflector:Deflector):void {
			var index:int = deflectors.indexOf(deflector);
			if (index >= 0) deflectors.splice(index, 1);
		}
		
		/**
		 * Removes all deflectors from the simulation.
		 */
		public function clearDeflectors():void {
			deflectors = [];
		}
		
		private var p2D:Particle2D;
		private var md4D:MotionData4D;
		private var deflector:Deflector;
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			p2D = Particle2D(particle);
			for each (deflector in deflectors) {
				md4D = deflector.getMotionData4D(p2D);
				if (md4D) {
					p2D.dictionary[deflector] = true;
					p2D.x = md4D.x;
					p2D.y = md4D.y;
					p2D.vx = md4D.vx;
					p2D.vy = md4D.vy;
					md4D = null;
				} else {
					p2D.dictionary[deflector] = false;
				}
			}
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return deflectors;
		}
		
		override public function getXMLTagName():String {
			return "Deflect";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (deflectors.length > 0) {
				xml.appendChild(<deflectors/>);
				var deflector:Deflector;
				for each (deflector in deflectors) {
					xml.deflectors.appendChild(deflector.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			clearDeflectors();
			for each (var node:XML in xml.deflectors.*) {
				addDeflector(builder.getElementByName(node.@name) as Deflector);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
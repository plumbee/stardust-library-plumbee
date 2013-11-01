package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	import idv.cjcat.stardust.twoD.zones.Zone;
	
	/**
	 * Causes particles to be marked dead when they are not contained inside a specified zone.
	 * 
	 * <p>
	 * Default priority = -6;
	 * </p>
	 */
	public class DeathZone extends Action2D {
		
		/**
		 * If a particle leave this zone (<code>Zone.contains()</code> returns false), it will be marked dead.
		 */
		public var zone:Zone;
		/**
		 * Inverts the zone region.
		 */
		public var inverted:Boolean;
		
		public function DeathZone(zone:Zone = null, inverted:Boolean = false) {
			priority = -6;
			
			this.zone = zone;
			this.inverted = inverted;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p2D:Particle2D = Particle2D(particle);
			var dead:Boolean = zone.contains(p2D.x, p2D.y);
			if (inverted) dead = !dead;
			if (dead) particle.isDead = true;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			if (!zone) return [];
			else return [zone];
		}
		
		override public function getXMLTagName():String {
			return "DeathZone";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (!zone) xml.@zone = "null";
			else xml.@zone = zone.name;
			xml.@inverted = inverted;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@zone == "null") zone = null;
			else if (xml.@zone.length()) zone = builder.getElementByName(xml.@zone) as Zone;
			if (xml.@inverted.length()) inverted = (xml.@inverted == "true");
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
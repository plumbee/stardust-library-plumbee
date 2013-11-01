package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.twoD.display.IStardustSprite;
	
	public class StardustSpriteUpdate extends Action2D {
		
		public function StardustSpriteUpdate() {
			
		}
		
		/**
		 * Calls the <code>IStardustSprite.update()</code> method of a particle's target if the target implements the <code>IStardustSprite</code> interface.
		 * @see idv.cjcat.stardust.twoD.display.IStardustSprite
		 */
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var target:IStardustSprite = particle.target as IStardustSprite;
			if (target) target.update(emitter, particle, time);
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "StardustSpriteUpdate";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
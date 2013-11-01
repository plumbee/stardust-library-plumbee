package idv.cjcat.stardust.threeD.zedbox.actions  {
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.threeD.actions.Action3D;
	import idv.cjcat.stardust.threeD.zedbox.initializers.ZBDisplayObjectClass;
	import idv.cjcat.stardust.twoD.display.IStardustSprite;
	
	public class ZBStardustSpriteUpdate extends Action3D {
		
		public function ZBStardustSpriteUpdate() {
			
		}
		
		override public final function update(emitter:Emitter, particle:Particle, time:Number):void {
			var target:IStardustSprite = particle.dictionary[ZBDisplayObjectClass] as IStardustSprite;
			if (target) target.update(emitter, particle, time);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ZBStardustSpriteUpdate";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
package idv.cjcat.stardustextended.threeD.zedbox.actions  {
	import idv.cjcat.stardustextended.common.emitters.Emitter;
	import idv.cjcat.stardustextended.common.particles.Particle;
	import idv.cjcat.stardustextended.threeD.actions.Action3D;
	import idv.cjcat.stardustextended.threeD.zedbox.initializers.ZBDisplayObjectClass;
	import idv.cjcat.stardustextended.twoD.display.IStardustSprite;
	
	public class ZBStardustSpriteUpdate extends Action3D {
		
		public function ZBStardustSpriteUpdate() {
			
		}
		
		override public final function update(emitter:Emitter, particle:Particle, timeDelta:Number, currentTime:Number):void {
			var target:IStardustSprite = particle.dictionary[ZBDisplayObjectClass] as IStardustSprite;
			if (target) target.update(emitter, particle, timeDelta);
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
package idv.cjcat.stardustextended.threeD.zedbox.initializers  {
	import idv.cjcat.stardustextended.common.particles.Particle;
	import idv.cjcat.stardustextended.threeD.initializers.Initializer3D;
	import idv.cjcat.stardustextended.twoD.display.IStardustSprite;
	
	public class ZBStardustSpriteInit extends Initializer3D {
		
		public function ZBStardustSpriteInit() {
			
		}
		
		override public final function initialize(particle:Particle):void {
			var target:IStardustSprite = particle.dictionary[ZBDisplayObjectClass] as IStardustSprite;
			if (target) target.init(particle);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ZBStardustSpriteInit";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
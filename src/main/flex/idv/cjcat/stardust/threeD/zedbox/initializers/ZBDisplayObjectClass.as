package idv.cjcat.stardust.threeD.zedbox.initializers {
	import flash.display.DisplayObject;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.utils.construct;
	import idv.cjcat.stardust.threeD.initializers.Initializer3D;
	import idv.cjcat.zedbox.display.ZedSprite;
	
	/**
	 * Assigns a <code>ZedSprite</code> object to the <code>target</code> properties of a particle, 
	 * and adds a display object (an instance of the <code>displayObjectClass</code> property) to the <code>ZedSprite</code> object's display list.
	 * This information can be visualized by <code>ZBDisplayObjectRenderer</code>
	 * 
	 * @see idv.cjcat.zedbox.ZedSprite
	 * @see idv.cjcat.stardust.threeD.zedbox.renderers.ZBDisplayObjectRenderer
	 */
	public class ZBDisplayObjectClass extends Initializer3D {
		
		public var displayObjectClass:Class;
		public var constructorParams:Array;
		public function ZBDisplayObjectClass(displayObjectClass:Class = null, constructorParams:Array = null) {
			priority = -100;
			
			this.displayObjectClass = displayObjectClass;
			this.constructorParams = constructorParams;
		}
		
		override public final function initialize(p:Particle):void {
			if (!displayObjectClass) return;
			var displayObj:DisplayObject;
			displayObj = DisplayObject(construct(displayObjectClass, constructorParams));
			
			var zs:ZedSprite = ZedSpritePool.get();
			zs.addChild(displayObj);
			
			p.target = zs;
			p.dictionary[ZBDisplayObjectClass] = displayObj;
		}
		
		override public final function get needsRecycle():Boolean {
			return true;
		}
		
		override public final function recycleInfo(particle:Particle):void {
			var zs:ZedSprite = particle.target as ZedSprite;
			zs.removeChild(DisplayObject(particle.dictionary[ZBDisplayObjectClass]));
			ZedSpritePool.recycle(zs);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ZBDisplayObjectClass";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
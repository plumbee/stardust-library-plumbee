package idv.cjcat.stardust.threeD.zedbox.initializers {
	import flash.display.DisplayObject;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.threeD.initializers.Initializer3D;
	import idv.cjcat.stardust.twoD.utils.DisplayObjectPool;
	import idv.cjcat.zedbox.display.ZedSprite;
	
	public class ZBPooledDisplayObjectClass extends Initializer3D {
		
		private var _constructorParams:Array;
		
		private var _pool:DisplayObjectPool;
		private var _displayObjectClass:Class;
		public function ZBPooledDisplayObjectClass(displayObjectClass:Class = null, constructorParams:Array = null) {
			priority = -100;
			_pool = new DisplayObjectPool();
			
			this.displayObjectClass = displayObjectClass;
			this.constructorParams = constructorParams;
		}
		
		override public final function initialize(p:Particle):void {
			if (!displayObjectClass) return;
			
			var zs:ZedSprite = ZedSpritePool.get();
			p.target = zs;
			p.dictionary[ZBDisplayObjectClass] = zs.addChild(_pool.get());
		}
		
		public function get displayObjectClass():Class { return _displayObjectClass; }
		public function set displayObjectClass(value:Class):void {
			_displayObjectClass = value;
			_pool.reset(_displayObjectClass, _constructorParams);
		}
		
		public function get constructorParams():Array { return _constructorParams; }
		public function set constructorParams(value:Array):void {
			_constructorParams = value;
			_pool.reset(_displayObjectClass, _constructorParams);
		}
		
		override public final function recycleInfo(particle:Particle):void {
			var obj:DisplayObject = DisplayObject(particle.dictionary[ZBDisplayObjectClass]);
			//if (obj) {
				//if (obj is IStardustSprite) IStardustSprite(obj).disable();
				if (obj is _displayObjectClass) _pool.recycle(obj);
			//}
			
			var zs:ZedSprite = particle.target as ZedSprite;
			zs.removeChild(DisplayObject(particle.dictionary[ZBDisplayObjectClass]));
			ZedSpritePool.recycle(zs);
		}
		
		override public final function get needsRecycle():Boolean {
			return true;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ZBPooledDisplayObjectClass";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
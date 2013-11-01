package idv.cjcat.stardust.twoD.initializers {
	import flash.display.DisplayObject;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.twoD.display.IStardustSprite;
	import idv.cjcat.stardust.twoD.utils.DisplayObjectPool;
	
	/**
	 * This is a pooled version of the <code>DisplayObjectClass</code> initializer, 
	 * which makes use of an object pool to reuse display objects, 
	 * saving time spent for instantiating new display objects.
	 * 
	 * <p>
	 * Default priority = 1;
	 * </p>
	 * 
	 * @see idv.cjcat.stardust.twoD.initializers.DisplayObjectClass
	 */
	public class PooledDisplayObjectClass extends Initializer2D {
		
		private var _constructorParams:Array;
		
		private var _pool:DisplayObjectPool;
		private var _displayObjectClass:Class;
		public function PooledDisplayObjectClass(displayObjectClass:Class = null, constructorParams:Array = null) {
			priority = 1;
			_pool = new DisplayObjectPool();
			
			this.displayObjectClass = displayObjectClass;
			this.constructorParams = constructorParams;
		}
		
		override public function initialize(p:Particle):void {
			if (_displayObjectClass) p.target = _pool.get();
			
		}
		
		public function get displayObjectClass():Class { return _displayObjectClass; }
		public function set displayObjectClass(value:Class):void {
			_displayObjectClass = value;
			if (_displayObjectClass) _pool.reset(_displayObjectClass, _constructorParams);
		}
		
		public function get constructorParams():Array { return _constructorParams; }
		public function set constructorParams(value:Array):void {
			_constructorParams = value;
			if (_displayObjectClass) _pool.reset(_displayObjectClass, _constructorParams);
		}
		
		override public function recycleInfo(particle:Particle):void {
			var obj:DisplayObject = DisplayObject(particle.target);
			if (obj) {
				if (obj is IStardustSprite) IStardustSprite(obj).disable();
				if (obj is _displayObjectClass) _pool.recycle(obj);
			}
		}
		
		override public function get needsRecycle():Boolean {
			return true;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "PooledDisplayObjectClass";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
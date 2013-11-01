package idv.cjcat.stardust.common.particles {
	import flash.utils.Dictionary;
	
	/**
	 * This class represents a particle and its properties.
	 */
	public class Particle {
		
		/**
		 * The initial life upon birth.
		 */
		public var initLife:Number;
		/**
		 * The normal scale upon birth.
		 */
		public var initScale:Number;
		/**
		 * The normal alpha value upon birth.
		 */
		public var initAlpha:Number;
		
		/**
		 * The remaining life of the particle.
		 */
		public var life:Number;
		/**
		 * The scale of the particle.
		 */
		public var scale:Number;
		/**
		 * The alpha value of the particle.
		 */
		public var alpha:Number;
		/**
		 * The mass of the particle.
		 */
		public var mass:Number;
		/**
		 * The mask value of the particle.
		 * 
		 * <p>
		 * The particle can only affected by an action or initializer only if the bitwise AND of their masks is non-zero.
		 * </p>
		 */
		public var mask:int;
		/**
		 * Whether the particle is marked as dead.
		 * 
		 * <p>
		 * Dead particles would be removed from simulation by an emitter.
		 * </p>
		 */
		public var isDead:Boolean;
		/**
		 * The collision radius of the particle.
		 */
		public var collisionRadius:Number;
		/**
		 * Custom user data of the particle.
		 * 
		 * <p>
		 * Normally, this property contains information for renderers. 
		 * For instance this property should refer to a display object for a <code>DisplayObjectRenderer</code>.
		 * </p>
		 */
		public var target:*;
		/**
		 * Particle color.
		 * 
		 * <p>
		 * This information can be used by the <code>PixelRenderer</code> class for determining pixel colors.
		 * </p>
		 */
		public var color:uint;
		/**
		 * The sorted index iterator.
		 */
		public var sortedIndexIterator:ParticleIterator;
		/**
		 * Dictionary for storing additional information.
		 */
		public var dictionary:Dictionary;
		
		public var recyclers:Dictionary;
		
		/*
		private var _handler:ParticleHandler;
		public final function handler():ParticleHandler { return _handler; }
		public final function setHandler(value:ParticleHandler):void {
			if (!value) value = ParticleHandler.getSingleton();
			_handler = value;
		}
		*/
		
		public function Particle() {
			dictionary = new Dictionary();
			recyclers = new Dictionary();
		}
		
		/**
		 * Initializes properties to default values.
		 * 
		 * <p>
		 * life = 0. scale = 1. alpha = 1. mass = 1. mask = 1. collisoinRadius = 0. target = null. sortedIndex = NaN.
		 * </p>
		 */
		public function init():void {
			initLife = life = 0;
			initScale = scale = 1;
			initAlpha = alpha = 1;
			mass = 1;
			mask = 1;
			isDead = false;
			collisionRadius = 0;
			color = 0;
			sortedIndexIterator = null;
			//_handler = ParticleHandler.getSingleton();
		}
		
		public function destroy():void {
			target = null;
			var key:*;
			for (key in dictionary) delete dictionary[key];
			for (key in recyclers) delete recyclers[key];
			//_handler = null;
		}
	}
}
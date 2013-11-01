package idv.cjcat.stardust.twoD.bursters {
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Bursts out particles from a single point, spreading out at uniformly distributed angles.
	 * 
	 * <p>
	 * Adding any iniitalizers that alters the particles' velocities essentially does nothing, 
	 * since this burster internally sets particles' velocites.
	 * </p>
	 */
	public class PointUniburster extends Burster2D {
		
		/**
		 * The number of particles (i.e. directions) in a single burst.
		 */
		public var count:int;
		/**
		 * The X coordinate of the bursting origin.
		 */
		public var x:Number;
		/**
		 * The Y coordinate of the bursting origin.
		 */
		public var y:Number;
		/**
		 * The initiail speed of particles bursted out.
		 */
		public var speed:Number;
		/**
		 * Sets the angle offset of direction for a particle. 
		 * The others' velocity directions will change along. 
		 * Zero angle offset points upward.
		 */
		public var angleOffset:Number;
		/**
		 * Whether particles are oriented to their initial velocity directions when created, true by default.
		 */
		public var oriented:Boolean;
		/**
		 * Orientation offset. 
		 */
		public var orientationOffset:Number;
		
		public function PointUniburster(count:int = 1, x:Number = 0, y:Number = 0, speed:Number = 1, angleOffset:Number = 0, oriented:Boolean = true, orientationOffset:Number = 0) {
			this.count = count;
			this.x = x;
			this.y = y;
			this.speed = speed;
			this.angleOffset = angleOffset;
			this.oriented = oriented;
			this.orientationOffset = orientationOffset;
		}
		
		override public function createParticles():ParticleCollection {
			var particles:ParticleCollection = factory.createParticles(count);
			var len:int = particles.size;
			var len_inv:Number = 1 / len;
			var angleOffset_rad:Number = angleOffset * StardustMath.DEGREE_TO_RADIAN;
			var p:Particle2D;
			var iter:ParticleIterator = particles.getIterator();
			for (var i:int = 0; i < len; i++) {
				p = Particle2D(iter.particle());
				p.x = x;
				p.y = y;
				p.vx = speed * Math.sin(StardustMath.TWO_PI * len_inv * i + angleOffset_rad);
				p.vy = -speed * Math.cos(StardustMath.TWO_PI * len_inv * i + angleOffset_rad);
				if (oriented) {
					p.rotation = 360 * len_inv * i + orientationOffset;
				}
				
				iter.next();
			}
			
			return particles;
		}
	}
}
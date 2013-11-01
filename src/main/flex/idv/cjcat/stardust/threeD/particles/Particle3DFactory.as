package idv.cjcat.stardust.threeD.particles {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleFactory;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	public class Particle3DFactory extends ParticleFactory {
		
		public function Particle3DFactory() {
			
		}
		
		override protected final function createNewParticle():Particle {
			return new Particle3D();
		}
		
		override public final function addInitializer(initializer:Initializer):void {
			if (!initializer.supports3D) {
				throw new IllegalOperationError("This initializer does not support 3D: " + getQualifiedClassName(Object(initializer).constructor as Class));
			}
			super.addInitializer(initializer);
		}
	}
}
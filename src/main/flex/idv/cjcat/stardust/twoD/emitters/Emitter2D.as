package idv.cjcat.stardust.twoD.emitters {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.handlers.ParticleHandler;
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.twoD.particles.PooledParticle2DFactory;
	
	/**
	 * 2D Emitter.
	 */
	public class Emitter2D extends Emitter {
		
		public function Emitter2D(clock:Clock = null, particleHandler:ParticleHandler = null,  particlesCollectionType:int = 0) {
			super(clock, particleHandler, particleCollectionType);
			factory = new PooledParticle2DFactory();
		}
		
		override public final function addAction(action:Action):void {
			if (!action.supports2D) {
				throw new IllegalOperationError("This action does not support 2D: " + getQualifiedClassName(Object(action).constructor as Class));
			}
			super.addAction(action);
		}
		
		override public final function addInitializer(initializer:Initializer):void {
			if (!initializer.supports2D) {
				throw new IllegalOperationError("This initializer does not support 2D: " + getQualifiedClassName(Object(initializer).constructor as Class));
			}
			super.addInitializer(initializer);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Emitter2D";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
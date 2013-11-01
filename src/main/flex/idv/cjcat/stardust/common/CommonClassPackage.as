package idv.cjcat.stardust.common {
	import idv.cjcat.stardust.common.actions.Age;
	import idv.cjcat.stardust.common.actions.AlphaCurve;
	import idv.cjcat.stardust.common.actions.CompositeAction;
	import idv.cjcat.stardust.common.actions.DeathLife;
	import idv.cjcat.stardust.common.actions.Die;
	import idv.cjcat.stardust.common.actions.ScaleCurve;
	import idv.cjcat.stardust.common.actions.triggers.DeathTrigger;
	import idv.cjcat.stardust.common.actions.triggers.LifeTrigger;
	import idv.cjcat.stardust.common.clocks.CompositeClock;
	import idv.cjcat.stardust.common.clocks.ImpulseClock;
	import idv.cjcat.stardust.common.clocks.RandomClock;
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.common.errors.DuplicateElementNameError;
	import idv.cjcat.stardust.common.handlers.PollingStation;
	import idv.cjcat.stardust.common.initializers.Alpha;
	import idv.cjcat.stardust.common.initializers.CollisionRadius;
	import idv.cjcat.stardust.common.initializers.Color;
	import idv.cjcat.stardust.common.initializers.CompositeInitializer;
	import idv.cjcat.stardust.common.initializers.Life;
	import idv.cjcat.stardust.common.initializers.Mask;
	import idv.cjcat.stardust.common.initializers.Mass;
	import idv.cjcat.stardust.common.initializers.Scale;
	import idv.cjcat.stardust.common.initializers.SwitchInitializer;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.math.AveragedRandom;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.xml.ClassPackage;
	
	/**
	 * Packs together common classes for both 2D and 3D.
	 */
	public class CommonClassPackage extends ClassPackage {
		
		private static var _instance:CommonClassPackage;
		
		public static function getInstance():CommonClassPackage {
			if (!_instance) _instance = new CommonClassPackage();
			return _instance;
		}
		
		public function CommonClassPackage() {
			
		}
		
		
		override protected final function populateClasses():void {
			//common actions
			classes.push(AlphaCurve);
			classes.push(CompositeAction);
			classes.push(DeathLife);
			classes.push(Die);
			classes.push(ScaleCurve);
			
			//common action triggers
			classes.push(DeathTrigger);
			classes.push(LifeTrigger);
			
			//common clocks
			classes.push(CompositeClock);
			classes.push(ImpulseClock);
			classes.push(RandomClock);
			classes.push(SteadyClock);
			
			//common emitters
			classes.push(Emitter);
			
			//common initializers
			classes.push(Age);
			classes.push(Alpha);
			classes.push(CollisionRadius);
			classes.push(Color);
			classes.push(CompositeInitializer);
			classes.push(Life);
			classes.push(Mask);
			classes.push(Mass);
			classes.push(Scale);
			classes.push(SwitchInitializer);
			
			//common particle handlers
			classes.push(PollingStation);
			
			//common randoms
			classes.push(AveragedRandom);
			classes.push(UniformRandom);
		}
	}
}
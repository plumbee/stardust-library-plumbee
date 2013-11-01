package idv.cjcat.stardust.twoD {
	import idv.cjcat.stardust.common.xml.ClassPackage;
	import idv.cjcat.stardust.twoD.actions.Accelerate;
	import idv.cjcat.stardust.twoD.actions.Collide;
	import idv.cjcat.stardust.twoD.actions.Damping;
	import idv.cjcat.stardust.twoD.actions.DeathZone;
	import idv.cjcat.stardust.twoD.actions.Deflect;
	import idv.cjcat.stardust.twoD.actions.Explode;
	import idv.cjcat.stardust.twoD.actions.Gravity;
	import idv.cjcat.stardust.twoD.actions.Impulse;
	import idv.cjcat.stardust.twoD.actions.LazyAction;
	import idv.cjcat.stardust.twoD.actions.Move;
	import idv.cjcat.stardust.twoD.actions.MutualGravity;
	import idv.cjcat.stardust.twoD.actions.NormalDrift;
	import idv.cjcat.stardust.twoD.actions.Oriented;
	import idv.cjcat.stardust.twoD.actions.RandomDrift;
	import idv.cjcat.stardust.twoD.actions.ReorderDisplayObject;
	import idv.cjcat.stardust.twoD.actions.Snapshot;
	import idv.cjcat.stardust.twoD.actions.SnapshotRestore;
	import idv.cjcat.stardust.twoD.actions.Spawn;
	import idv.cjcat.stardust.twoD.actions.SpeedLimit;
	import idv.cjcat.stardust.twoD.actions.Spin;
	import idv.cjcat.stardust.twoD.actions.StardustSpriteUpdate;
	import idv.cjcat.stardust.twoD.actions.triggers.DeflectorTrigger;
	import idv.cjcat.stardust.twoD.actions.triggers.ZoneTrigger;
	import idv.cjcat.stardust.twoD.actions.VelocityField;
	import idv.cjcat.stardust.twoD.deflectors.BoundingBox;
	import idv.cjcat.stardust.twoD.deflectors.BoundingCircle;
	import idv.cjcat.stardust.twoD.deflectors.CircleDeflector;
	import idv.cjcat.stardust.twoD.deflectors.LineDeflector;
	import idv.cjcat.stardust.twoD.deflectors.WrappingBox;
	import idv.cjcat.stardust.twoD.emitters.Emitter2D;
	import idv.cjcat.stardust.twoD.fields.BitmapField;
	import idv.cjcat.stardust.twoD.fields.RadialField;
	import idv.cjcat.stardust.twoD.fields.UniformField;
	import idv.cjcat.stardust.twoD.handlers.BitmapHandler;
	import idv.cjcat.stardust.twoD.handlers.DisplayObjectHandler;
	import idv.cjcat.stardust.twoD.handlers.PixelHandler;
	import idv.cjcat.stardust.twoD.handlers.SingularBitmapHandler;
	import idv.cjcat.stardust.twoD.initializers.DisplayObjectClass;
	import idv.cjcat.stardust.twoD.initializers.DisplayObjectParent;
	import idv.cjcat.stardust.twoD.initializers.LazyInitializer;
	import idv.cjcat.stardust.twoD.initializers.Omega;
	import idv.cjcat.stardust.twoD.initializers.PooledDisplayObjectClass;
	import idv.cjcat.stardust.twoD.initializers.Position;
	import idv.cjcat.stardust.twoD.initializers.Rotation;
	import idv.cjcat.stardust.twoD.initializers.StardustSpriteInit;
	import idv.cjcat.stardust.twoD.initializers.Velocity;
	import idv.cjcat.stardust.twoD.zones.BitmapZone;
	import idv.cjcat.stardust.twoD.zones.CircleContour;
	import idv.cjcat.stardust.twoD.zones.CircleZone;
	import idv.cjcat.stardust.twoD.zones.CompositeZone;
	import idv.cjcat.stardust.twoD.zones.LazySectorZone;
	import idv.cjcat.stardust.twoD.zones.Line;
	import idv.cjcat.stardust.twoD.zones.RectContour;
	import idv.cjcat.stardust.twoD.zones.RectZone;
	import idv.cjcat.stardust.twoD.zones.SectorZone;
	import idv.cjcat.stardust.twoD.zones.SinglePoint;
	
	/**
	 * Packs together classes for 2D.
	 */
	public class TwoDClassPackage extends ClassPackage {
		
		private static var _instance:TwoDClassPackage;
		
		public static function getInstance():TwoDClassPackage {
			if (!_instance) _instance = new TwoDClassPackage();
			return _instance;
		}
		
		public function TwoDClassPackage() {
			
		}
		
		
		override protected final function populateClasses():void {
			//2D actions
			classes.push(RandomDrift);
			classes.push(Accelerate);
			classes.push(Collide);
			classes.push(Damping);
			classes.push(DeathZone);
			classes.push(Deflect);
			classes.push(Explode);
			classes.push(Gravity);
			classes.push(Impulse);
			classes.push(LazyAction);
			classes.push(Move);
			classes.push(MutualGravity);
			classes.push(NormalDrift);
			classes.push(Oriented);
			classes.push(ReorderDisplayObject);
			classes.push(Snapshot);
			classes.push(SnapshotRestore);
			classes.push(Spawn);
			classes.push(SpeedLimit);
			classes.push(Spin);
			classes.push(StardustSpriteUpdate);
			classes.push(VelocityField);
			
			//2D action triggers
			classes.push(DeflectorTrigger);
			classes.push(ZoneTrigger);
			
			//2D deflectors
			classes.push(BoundingBox);
			classes.push(BoundingCircle);
			classes.push(CircleDeflector);
			classes.push(LineDeflector);
			classes.push(WrappingBox);
			
			//2D emitters
			classes.push(Emitter2D);
			
			//2D fields
			classes.push(BitmapField);
			classes.push(RadialField);
			classes.push(UniformField);
			
			//2D initializers
			classes.push(DisplayObjectClass);
			classes.push(DisplayObjectParent);
			classes.push(LazyInitializer);
			classes.push(Omega);
			classes.push(PooledDisplayObjectClass);
			classes.push(Position);
			classes.push(Rotation);
			classes.push(StardustSpriteInit);
			classes.push(Velocity);
			
			//2D particle handlers
			classes.push(BitmapHandler);
			classes.push(DisplayObjectHandler);
			classes.push(SingularBitmapHandler);
			classes.push(PixelHandler);
			
			//2D zones
			classes.push(BitmapZone);
			classes.push(CircleContour);
			classes.push(CircleZone);
			classes.push(CompositeZone);
			classes.push(LazySectorZone);
			classes.push(Line);
			classes.push(RectContour);
			classes.push(RectZone);
			classes.push(SectorZone);
			classes.push(SinglePoint);
		}
	}
}
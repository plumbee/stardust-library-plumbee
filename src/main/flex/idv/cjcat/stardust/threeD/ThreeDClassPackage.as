package idv.cjcat.stardust.threeD {
	import idv.cjcat.stardust.common.xml.ClassPackage;
	import idv.cjcat.stardust.threeD.actions.Accelerate3D;
	import idv.cjcat.stardust.threeD.actions.BillboardOriented;
	import idv.cjcat.stardust.threeD.actions.Collide3D;
	import idv.cjcat.stardust.threeD.actions.Damping3D;
	import idv.cjcat.stardust.threeD.actions.DeathZone3D;
	import idv.cjcat.stardust.threeD.actions.Deflect3D;
	import idv.cjcat.stardust.threeD.actions.Explode3D;
	import idv.cjcat.stardust.threeD.actions.Gravity3D;
	import idv.cjcat.stardust.threeD.actions.Move3D;
	import idv.cjcat.stardust.threeD.actions.MutualGravity3D;
	import idv.cjcat.stardust.threeD.actions.NormalDrift3D;
	import idv.cjcat.stardust.threeD.actions.Oriented3D;
	import idv.cjcat.stardust.threeD.actions.RandomDrift3D;
	import idv.cjcat.stardust.threeD.actions.Snapshot3D;
	import idv.cjcat.stardust.threeD.actions.SnapshotRestore3D;
	import idv.cjcat.stardust.threeD.actions.Spawn3D;
	import idv.cjcat.stardust.threeD.actions.SpeedLimit3D;
	import idv.cjcat.stardust.threeD.actions.Spin3D;
	import idv.cjcat.stardust.threeD.actions.StardustSpriteUpdate3D;
	import idv.cjcat.stardust.threeD.actions.triggers.DeflectorTrigger3D;
	import idv.cjcat.stardust.threeD.actions.triggers.ZoneTrigger3D;
	import idv.cjcat.stardust.threeD.actions.VelocityField3D;
	import idv.cjcat.stardust.threeD.deflectors.BoundingCube;
	import idv.cjcat.stardust.threeD.deflectors.BoundingSphere;
	import idv.cjcat.stardust.threeD.deflectors.PlaneDeflector;
	import idv.cjcat.stardust.threeD.deflectors.SphereDeflector;
	import idv.cjcat.stardust.threeD.deflectors.WrappingCube;
	import idv.cjcat.stardust.threeD.emitters.Emitter3D;
	import idv.cjcat.stardust.threeD.fields.RadialField3D;
	import idv.cjcat.stardust.threeD.fields.UniformField3D;
	import idv.cjcat.stardust.threeD.handlers.DisplayObjectHandler3D;
	import idv.cjcat.stardust.threeD.initializers.DisplayObjectClass3D;
	import idv.cjcat.stardust.threeD.initializers.Omega3D;
	import idv.cjcat.stardust.threeD.initializers.PooledDisplayObjectClass3D;
	import idv.cjcat.stardust.threeD.initializers.Position3D;
	import idv.cjcat.stardust.threeD.initializers.Rotation3D;
	import idv.cjcat.stardust.threeD.initializers.StardustSpriteInit3D;
	import idv.cjcat.stardust.threeD.initializers.Velocity3D;
	import idv.cjcat.stardust.threeD.zones.CubeZone;
	import idv.cjcat.stardust.threeD.zones.DiskZone;
	import idv.cjcat.stardust.threeD.zones.SinglePoint3D;
	import idv.cjcat.stardust.threeD.zones.SphereCap;
	import idv.cjcat.stardust.threeD.zones.SphereShell;
	import idv.cjcat.stardust.threeD.zones.SphereSurface;
	import idv.cjcat.stardust.threeD.zones.SphereZone;
	
	/**
	 * Packs together classes for 3D.
	 */
	public class ThreeDClassPackage extends ClassPackage {
		
		private static var _instance:ThreeDClassPackage;
		
		public static function getInstance():ThreeDClassPackage {
			if (!_instance) _instance = new ThreeDClassPackage();
			return _instance;
		}
		
		public function ThreeDClassPackage() {
			
		}
		
		
		override protected final function populateClasses():void {
			//3D actions
			classes.push(RandomDrift3D);
			classes.push(Accelerate3D);
			classes.push(BillboardOriented);
			classes.push(Collide3D);
			classes.push(DeathZone3D);
			classes.push(Damping3D);
			classes.push(Deflect3D);
			classes.push(Explode3D);
			classes.push(Gravity3D);
			classes.push(Move3D);
			classes.push(MutualGravity3D);
			classes.push(NormalDrift3D);
			classes.push(Oriented3D);
			classes.push(Snapshot3D);
			classes.push(SnapshotRestore3D);
			classes.push(Spawn3D);
			classes.push(SpeedLimit3D);
			classes.push(Spin3D);
			classes.push(StardustSpriteUpdate3D);
			classes.push(VelocityField3D);
			
			//3D action triggers
			classes.push(DeflectorTrigger3D);
			classes.push(ZoneTrigger3D);
			
			//3D deflectors
			classes.push(BoundingCube);
			classes.push(BoundingSphere);
			classes.push(PlaneDeflector);
			classes.push(SphereDeflector);
			classes.push(WrappingCube);
			
			//3D emitters
			classes.push(Emitter3D);
			
			//3D fields
			classes.push(RadialField3D);
			classes.push(UniformField3D);
			
			//3D initializers
			classes.push(DisplayObjectClass3D);
			classes.push(Omega3D);
			classes.push(PooledDisplayObjectClass3D);
			classes.push(Position3D);
			classes.push(Rotation3D);
			classes.push(StardustSpriteInit3D);
			classes.push(Velocity3D);
			
			//3D particle handlers
			classes.push(DisplayObjectHandler3D);
			
			//3D zones
			classes.push(CubeZone);
			classes.push(DiskZone);
			classes.push(SinglePoint3D);
			classes.push(SphereCap);
			classes.push(SphereShell);
			classes.push(SphereSurface);
			classes.push(SphereZone);
		}
	}
}
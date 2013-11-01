package idv.cjcat.stardust.threeD.geom {
	import flash.display.DisplayObject;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	public class ZData {
		
		public var displayObject:DisplayObject;
		public var particle:Particle3D;
		public var cameraDiff:Vec3D = new Vec3D();
		public var cameraVelocity:Vec3D = new Vec3D();
	}
}
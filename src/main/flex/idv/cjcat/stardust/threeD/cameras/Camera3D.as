package idv.cjcat.stardust.threeD.cameras {
	import idv.cjcat.stardust.threeD.geom.Vec3D;
	
	/**
	 * The camera used by the <code>DisplayObjectRenderer3D</code>.
	 * 
	 * @see idv.cjcat.stardust.threeD.renderers.DisplayObjectRenderer3D
	 */
	public class Camera3D {
		
		public var focalLength:Number = 500;
		public var zoom:Number = 1;
		public var rotation:Number = 0;
		public var usePerspective:Boolean = true;
		
		private var _position:Vec3D = new Vec3D(0, 0, 0);
		private var _direction:Vec3D = new Vec3D(0, 0, 1);
		
		public function Camera3D() {
			
		}
		
		public function get position():Vec3D { return _position; }
		public function get direction():Vec3D { return _direction; }
	}
}
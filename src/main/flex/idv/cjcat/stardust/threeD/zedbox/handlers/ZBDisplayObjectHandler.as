package idv.cjcat.stardust.threeD.zedbox.handlers {
	import flash.display.DisplayObject;
	import idv.cjcat.stardust.common.handlers.ParticleHandler;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	import idv.cjcat.stardust.threeD.zedbox.initializers.ZBDisplayObjectClass;
	import idv.cjcat.zedbox.display.IZedBoxSprite;
	import idv.cjcat.zedbox.display.ZedScene;
	import idv.cjcat.zedbox.display.ZedSprite;
	import idv.cjcat.zedbox.geom.Vec3D;
	import idv.cjcat.zedbox.geom.Vec3DPool;
	import idv.cjcat.zedbox.zb;
	
	/**
	 * This handler adds <code>ZedSprite</code> particles to a  <code>IZedBoxSprite</code> container (either a <code>ZedSprite</code> or a <code>ZedScene</code>), 
	 * removes dead particles from the container, 
	 * and updates the <code>ZedSprite</code> objects' x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY, scaleZ, and alpha properties.
	 * 
	 * @see idv.cjcat.zedbox.IZedBoxSprit
	 * @see idv.cjcat.zedbox.ZedScene
	 * @see idv.cjcat.zedbox.ZedSprite
	 */
	public class ZBDisplayObjectHandler extends ParticleHandler {
		
		public var container:IZedBoxSprite;
		
		public function ZBDisplayObjectHandler(container:IZedBoxSprite = null) {
			this.container = container;
		}
		
		private var zedSprite:ZedSprite;
		private var displayObj:DisplayObject;
		
		override public function particleAdded(particle:Particle):void {
			zedSprite = ZedSprite(particle.target)
			container.addChild(zedSprite);
		}
		
		override public function particleRemoved(particle:Particle):void {
			zedSprite = ZedSprite(particle.target)
			displayObj = DisplayObject(particle.dictionary[ZBDisplayObjectClass]);
			IZedBoxSprite(zedSprite.parent).removeChild(zedSprite);
			if (displayObj.parent) IZedBoxSprite(displayObj.parent).removeChild(displayObj);
		}
		
		private var p3D:Particle3D;
		private var scene:ZedScene;
		private var vel:Vec3D;
		
		override public function readParticle(particle:Particle):void {
			p3D = Particle3D(particle);
			
			zedSprite = ZedSprite(particle.target)
			//if (!zedSprite) return;
			
			displayObj = DisplayObject(particle.dictionary[ZBDisplayObjectClass]);
			
			zedSprite.x = p3D.x;
			zedSprite.y = p3D.y;
			zedSprite.z = p3D.z;
			displayObj.scaleX = displayObj.scaleY = particle.scale;
			displayObj.rotation = p3D.rotationZ;
			displayObj.alpha = particle.alpha;
			
			//scene velocity
			scene = ZedScene(zedSprite.zb::superParent as ZedScene);
			if (scene) {
				vel = Vec3DPool.get(p3D.vx, p3D.vy, p3D.vz);
				zedSprite.zb::_flatMatrix.transformThisVecWithoutTranslation(vel);
				scene.zb::cameraMatrix.transformThisVec(vel);
				p3D.screenVX = vel.x;
				p3D.screenVY = vel.y;
				Vec3DPool.recycle(vel);
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ZBDisplayObjectHandler";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
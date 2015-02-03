package idv.cjcat.stardustextended.twoD.starling
{
import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.twoD.display.IStardustSprite;
import idv.cjcat.stardustextended.twoD.utils.GenericObjectPool;

public class PooledStarlingDisplayObjectClass extends StarlingDisplayObjectClass
{
	public function PooledStarlingDisplayObjectClass(displayObjectClass : Class = null, constructorParams : Array = null)
	{
		super(displayObjectClass, constructorParams);
		setupPool(displayObjectClass, constructorParams);
	}

	protected var pool : GenericObjectPool;

	override public function get needsRecycle() : Boolean
	{
		return true;
	}

	override public function initialize(particle : Particle) : void
	{
		super.initialize(particle);
		if (particle.target is IStardustSprite)
		{
			IStardustSprite(particle.target).init(particle);
		}
	}

	override protected function createParticleDisplayObject(displayObjectClass : Class, constructorParams : Array) : *
	{
		return pool.get();
	}

	override public function recycleInfo(particle : Particle) : void
	{
		super.recycleInfo(particle);
		var obj : * = particle.target;
		if (obj)
		{
			if (obj is IStardustSprite)
			{
				IStardustSprite(obj).disable();
			}
			if (obj is super.displayObjectClass)
			{
				pool.recycle(obj);
			}
		}
	}

	protected function createPool() : GenericObjectPool
	{
		return new GenericObjectPool();
	}

	private function setupPool(displayObjectClass : Class, constructorParams : Array) : void
	{
		pool = createPool();
		pool.reset(displayObjectClass, constructorParams);
	}
}
}

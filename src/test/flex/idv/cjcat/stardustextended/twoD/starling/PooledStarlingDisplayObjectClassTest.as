package idv.cjcat.stardustextended.twoD.starling
{
import idv.cjcat.stardustextended.twoD.utils.GenericObjectPool;

import org.flexunit.rules.IMethodRule;
import org.mockito.integrations.flexunit4.MockitoRule;
import org.mockito.integrations.verify;

public class PooledStarlingDisplayObjectClassTest extends PooledStarlingDisplayObjectClass
{
	[Rule]
	public var rule:IMethodRule = new MockitoRule();

	[Mock]
	public var mockPool:GenericObjectPool;


	public function PooledStarlingDisplayObjectClassTest()
	{
		super(PooledFakeClass,[]);
	}

	[Test]
	public function whenCreatingParticle_picksOneFromPool() : void
	{
		createParticleDisplayObject(displayObjectClass,constructorParams);
		verify().that(pool.get());
	}


	override protected function createPool() : GenericObjectPool
	{
		return mockPool;
	}
}

}

class PooledFakeClass{

}
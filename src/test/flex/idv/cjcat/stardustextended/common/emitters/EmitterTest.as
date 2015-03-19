package idv.cjcat.stardustextended.common.emitters
{
import idv.cjcat.stardustextended.common.actions.Action;
import idv.cjcat.stardustextended.common.initializers.Initializer;
import idv.cjcat.stardustextended.common.particles.PooledParticleFactory;
import idv.cjcat.stardustextended.sd;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertStrictlyEquals;
import org.hamcrest.assertThat;
import org.hamcrest.number.greaterThanOrEqualTo;
import org.hamcrest.object.equalTo;

use namespace sd;

public class EmitterTest extends Emitter
{


	[Before]
	public function setUp() : void
	{
		factory = new PooledParticleFactory();
	}

	[Test(description="getInitializersByClass returns empty vector when no initializer is found")]
	public function noInitializers_returnsEmptyVector() : void
	{
		var result : Vector.<Initializer> = getInitializersByClass(DummyInitializer1);
		assertNotNull(result);
		assertEquals(0, result.length);
	}

	[Test(description="getInitializersByClass returns vector of initializer instances of the given class")]
	public function oneInitializer_returnsNonEmptyVector() : void
	{
		var initializer : Initializer = new DummyInitializer1();
		addInitializer(initializer);
		var result : Vector.<Initializer> = getInitializersByClass(DummyInitializer1);
		assertEquals(1, result.length);
		assertStrictlyEquals(initializer, result[0]);
	}


	[Test(description="getInitializersByClass returns vector of initializer instances of the given class")]
	public function severalInitializers_returnsOnlyGivenClass() : void
	{
		addInitializer(new DummyInitializer2());
		var initializer : Initializer = new DummyInitializer1();
		addInitializer(initializer);
		var result : Vector.<Initializer> = getInitializersByClass(DummyInitializer1);
		assertEquals(1, result.length);
		assertStrictlyEquals(initializer, result[0]);
	}

	[Test(description=" getActionsByClass returns only desired type of actions")]
	public function getActionsByClass_returnsNewVectorContainingTheExistingActions_OnlyOfDesiredType(): void
	{
		const DESIRED_ACTION_1: DummyAction1 = new DummyAction1();
		const DESIRED_ACTION_2: DummyAction1 = new DummyAction1();
		const UNDESIRED_ACTION: DummyAction2 = new DummyAction2();

		addAction(DESIRED_ACTION_1);
		addAction(DESIRED_ACTION_2);
		addAction(UNDESIRED_ACTION);

		const result: Vector.<Action> = getActionsByClass(DummyAction1);
		assertThat(result.indexOf(DESIRED_ACTION_1), greaterThanOrEqualTo(0));
		assertThat(result.indexOf(DESIRED_ACTION_2), greaterThanOrEqualTo(0));
		assertThat(result.length, equalTo(2));
		assertThat(result.indexOf(UNDESIRED_ACTION), equalTo(-1));
	}

	[Test]
	public function removingInitializersFromVector_doesntAffectInitializers() : void
	{
		var initializer : Initializer = new DummyInitializer1();
		addInitializer(initializer);
		var result : Vector.<Initializer> = getInitializersByClass(DummyInitializer1);
		result.pop();
		assertEquals(1, initializers.length);
	}

	[Test(description="removes all initializers of given class")]
	public function removeInitByClass() : void
	{
		addInitializer(new DummyInitializer1());
		removeInitializersByClass(DummyInitializer1);
		assertThat(getInitializersByClass(DummyInitializer1).length,equalTo(0));
	}


	[Test(description="when removing, initializers not of the given class are not removed")]
	public function doesntRemoveInitializersOfOtherClasses() : void
	{
		addInitializer(new DummyInitializer1());
		addInitializer(new DummyInitializer2());
		addInitializer(new DummyInitializer1());
		removeInitializersByClass(DummyInitializer1);
		assertThat(getInitializersByClass(DummyInitializer2).length,equalTo(1));
	}
}
}

import idv.cjcat.stardustextended.common.actions.Action;
import idv.cjcat.stardustextended.common.initializers.Initializer;

class DummyInitializer1 extends Initializer
{

}

class DummyInitializer2 extends Initializer
{

}

class DummyAction1 extends Action
{

}

class DummyAction2 extends Action
{

}

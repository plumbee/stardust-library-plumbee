/**
 * Created by guymclean on 24/03/2015.
 */
package idv.cjcat.stardustextended.twoD.starling
{
import org.flexunit.asserts.assertTrue;

public class StarlingDisplayObjectPoolShuntTest extends StarlingDisplayObjectPool
{
	public var testDisposableA: TestDisposableClass = new TestDisposableClass();
	public var testDisposableB: TestDisposableClass = new TestDisposableClass();
	public var testDisposableC: TestDisposableClass = new TestDisposableClass();

	public function StarlingDisplayObjectPoolShuntTest()
	{
		super();
		_vec = [testDisposableA, testDisposableB, testDisposableC];
	}

	[Test]
	public function dispose_callsDisposeOnAllObjectsInPool(): void
	{
		dispose();
		assertTrue(testDisposableA.wasCalled);
		assertTrue(testDisposableB.wasCalled);
		assertTrue(testDisposableC.wasCalled);
	}


}
}

internal class TestDisposableClass
{
	private var _wasCalled: Boolean = false;

	public function dispose(): void
	{
		_wasCalled = true;
	}

	public function get wasCalled(): Boolean
	{
		return _wasCalled;
	}
}

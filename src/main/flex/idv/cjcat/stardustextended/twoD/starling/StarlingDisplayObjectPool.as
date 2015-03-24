/**
 * Created by guymclean on 24/03/2015.
 */
package idv.cjcat.stardustextended.twoD.starling
{
import idv.cjcat.stardustextended.twoD.utils.GenericObjectPool;

public class StarlingDisplayObjectPool extends GenericObjectPool
{
	public function StarlingDisplayObjectPool()
	{
		super();
	}

	public function dispose(): void
	{
		for(var i: int = 0; i < _vec.length;i++)
		{
			_vec[i]["dispose"]();
		}
	}
}
}

/**
 * @Author: Karl Harmer, Plumbee Ltd
 */
package idv.cjcat.stardustextended.twoD.starling
{
public class ParticleConfig
{
	private var _animationSpeed : uint;
	private var _startFromRandomFrame : Boolean;

	public function ParticleConfig(animationSpeed : uint = 1, startFromRandomFrame : Boolean = false)
	{
		_animationSpeed = animationSpeed;
		_startFromRandomFrame = startFromRandomFrame;
	}

	public function get animationSpeed() : uint
	{
		return _animationSpeed;
	}

	public function get startFromRandomFrame() : Boolean
	{
		return _startFromRandomFrame;
	}
}
}

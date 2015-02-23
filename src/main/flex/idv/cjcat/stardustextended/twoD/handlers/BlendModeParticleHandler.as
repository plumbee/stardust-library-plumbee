/**
 * @Author: Karl Harmer, Plumbee Ltd
 */
package idv.cjcat.stardustextended.twoD.handlers
{
import idv.cjcat.stardustextended.common.handlers.ParticleHandler;

public class BlendModeParticleHandler extends ParticleHandler
{
	private var _supportedBlendModes : Vector.<String>;
	private var _blendMode : String;

	public function BlendModeParticleHandler(supportedBlendModes : Vector.<String>)
	{
		_supportedBlendModes = supportedBlendModes;
	}

	public function get blendMode() : String
	{
		return _blendMode;
	}

	public function set blendMode(value : String) : void
	{
		if(_supportedBlendModes.indexOf(value) > -1)
		{
			_blendMode = value;
		}
	}
}
}

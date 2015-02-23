/**
 * @Author: Karl Harmer, Plumbee Ltd
 */
package idv.cjcat.stardustextended.twoD.handlers
{
import flash.display.BlendMode;

import idv.cjcat.stardustextended.common.handlers.ParticleHandler;

public class BlendModeParticleHandler extends ParticleHandler
{
	private static const STARLING_BLEND_MODES : Vector.<String> = new <String>[
		BlendMode.NORMAL,
		BlendMode.MULTIPLY,
		BlendMode.SCREEN,
		BlendMode.ADD,
		BlendMode.ERASE
	];

	private static const DISPLAY_LIST_BLEND_MODES : Vector.<String> = new <String>[
		BlendMode.NORMAL,
		BlendMode.LAYER,
		BlendMode.MULTIPLY,
		BlendMode.SCREEN,
		BlendMode.LIGHTEN,
		BlendMode.DARKEN,
		BlendMode.ADD,
		BlendMode.SUBTRACT,
		BlendMode.DIFFERENCE,
		BlendMode.INVERT,
		BlendMode.OVERLAY,
		BlendMode.HARDLIGHT,
		BlendMode.ALPHA,
		BlendMode.ERASE
	];

	private var _starlingBlendMode : String = BlendMode.NORMAL;
	private var _displayListBlendMode : String = BlendMode.NORMAL;
	private var _isDisplayListBlendMode : Boolean = true;

	public function get blendMode() : String
	{
		return _isDisplayListBlendMode ? _displayListBlendMode : _starlingBlendMode;
	}

	public function set starlingBlendMode(value : String) : void
	{
		_starlingBlendMode = assignBlendMode(value, STARLING_BLEND_MODES);
		_isDisplayListBlendMode = false;
	}

	public function set displayListBlendMode(value : String) : void
	{
		_displayListBlendMode = assignBlendMode(value, DISPLAY_LIST_BLEND_MODES);
		_isDisplayListBlendMode = true;
	}

	private function assignBlendMode(targetBlendMode : String, acceptableBlendModes : Vector.<String>) : String
	{
		return acceptableBlendModes.indexOf(targetBlendMode) > -1 ? targetBlendMode : BlendMode.NORMAL;
	}
}
}

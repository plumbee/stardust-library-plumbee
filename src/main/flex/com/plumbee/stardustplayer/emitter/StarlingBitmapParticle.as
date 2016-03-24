//NOTE: This class has been copy-pasted from stardust-starling-sim-loader to solve the issue of dynamically loaded particles across app-domains.
//Any changes made here should be mirrored in the class with the same package and name in stardust-starling-sim-loader. Not doing so will most likely
//result in a week-long migraine
package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.twoD.starling.*;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IAnimatedParticle;

import starling.display.Image;
import starling.textures.Texture;

public class StarlingBitmapParticle extends Image implements IAnimatedParticle, IStardustStarlingParticle
{
	private var _animationSpeed : uint = 1;
	private var _playingFrameIndex : uint = 0;
	private var _animationLength : uint = 1;
	private var _isAnimated: Boolean = true;

	public function StarlingBitmapParticle(textures : Vector.<Texture>)
	{
		super(textures[0]);
		_textures = textures;
		_animationLength = _textures.length;
		updatePivot();
	}

	private function updatePivot() : void
	{
		pivotX = texture.width / 2;
		pivotY = texture.height / 2;
	}

	protected var _textures : Vector.<Texture>;

	public function updateFromModel(x : Number, y : Number, rotation : Number, scale : Number, alpha : Number) : void
	{
		this.x = x;
		this.y = y;
		//Receives rotation in degrees. Starling uses radians.
		this.rotation = degreeToRadians(rotation);
		this.scaleX = this.scaleY = scale;
		if (this.alpha != alpha)
		{
			this.alpha = alpha;
		}
	}

	public function stepSpriteSheet(stepTime : uint) : void
	{
		if(_isAnimated)
		{
			_playingFrameIndex = (_playingFrameIndex + stepTime) % _animationLength;
			updateCurrentTexture();
		}
	}

	private function updateCurrentTexture(): void
	{
		texture = _textures[uint(_playingFrameIndex / _animationSpeed)];
	}

	override public function set texture(value : Texture) : void
	{
		super.texture = value;
		width = texture.width;
		height = texture.height;
		updatePivot();
	}

	public function isAnimatedSpriteSheet() : Boolean
	{
		return _textures.length > 1;
	}

	private function degreeToRadians(rotation : Number) : Number
	{
		return rotation * Math.PI / 180;
	}

	public function set animationSpeed(value : uint) : void
	{
		if(value == 0)
		{
			_isAnimated = false;
		}
		_animationSpeed = (value > 0) ? value : 1;
		_animationLength = _textures.length * _animationSpeed;
	}

	public function set startFromRandomFrame(value : Boolean) : void
	{
		if(value)
		{
			_playingFrameIndex = Math.random() * _animationLength;
			updateCurrentTexture();
		}
		else
		{
			_playingFrameIndex = 0;
			updateCurrentTexture();
		}
	}

	public function get playHeadPosition() : uint
	{
		return _playingFrameIndex;
	}

	public function get animationLength() : uint
	{
		return _animationLength;
	}

	public function get animationSpeed() : uint
	{
		return _animationSpeed;
	}
}
}

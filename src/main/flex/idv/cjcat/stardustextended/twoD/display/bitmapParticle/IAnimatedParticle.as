package idv.cjcat.stardustextended.twoD.display.bitmapParticle
{
public interface IAnimatedParticle
{
	function stepSpriteSheet(stepTime : uint) : void;
	function set animationSpeed(value : uint) : void;
	function set startFromRandomFrame(value : Boolean) : void;
}
}

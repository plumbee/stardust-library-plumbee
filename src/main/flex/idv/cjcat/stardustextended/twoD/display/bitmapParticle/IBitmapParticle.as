package idv.cjcat.stardustextended.twoD.display.bitmapParticle
{

import flash.display.BitmapData;

public interface IBitmapParticle extends IAnimatedParticle
{
    function initWithSingleBitmap( bitmapData : BitmapData, _smoothing : Boolean ) : void;
    function initWithSpriteSheet( imgWidth : int, imgHeight : int, _animSpeed : uint, startAtRandomFrame : Boolean, bitmapData : BitmapData, _smoothing : Boolean ) : void;
}
}

package idv.cjcat.stardust.twoD.display.bitmapParticle
{

import flash.display.BitmapData;

public interface IBitmapParticle
{

    function initWithSingleBitmap(bitmapData : BitmapData) : void;

    function initWithSpriteSheet( imgWidth : int, imgHeight : int, _animSpeed : uint,
                                  startAtRandomFrame : Boolean, bitmapData : BitmapData ) : void;
}
}

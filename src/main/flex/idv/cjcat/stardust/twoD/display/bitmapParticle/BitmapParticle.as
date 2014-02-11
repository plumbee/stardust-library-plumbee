package idv.cjcat.stardust.twoD.display.bitmapParticle
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.utils.Dictionary;

public class BitmapParticle extends Sprite implements IBitmapParticle
{
    private const bmp : Bitmap = new Bitmap();

    private static const slicedSpriteCache : Dictionary = new Dictionary();
    private var currFrame : uint = 0;
    private var spriteCache : SpriteSheetBitmapSlicedCache;
    private var animSpeed : uint;
    private var isSpriteSheet : Boolean;
    private var totalFrames : uint;

    public function BitmapParticle()
    {
        addChild( bmp );
    }

    public function initWithSingleBitmap(bitmapData : BitmapData) : void
    {
        bmp.bitmapData = bitmapData;
        bmp.smoothing = true;
        bmp.x = - bmp.width * 0.5;
        bmp.y = - bmp.height * 0.5;
        isSpriteSheet = false;
        spriteCache = null;
    }

    public function initWithSpriteSheet( imgWidth : int, imgHeight : int, _animSpeed : uint,
                                         startAtRandomFrame : Boolean, bitmapData : BitmapData ) : void
    {
        if ( imgWidth > bitmapData.width || imgHeight > bitmapData.height )
        {
            return;
        }
        isSpriteSheet = true;
        if ( _animSpeed == 0 )
        {
            _animSpeed = 1;
        }
        if ( ! slicedSpriteCache[bitmapData] )
        {
            slicedSpriteCache[bitmapData] = new Dictionary();
        }
        const sizeKey : Number = imgWidth * 10000000 + imgHeight;
        if ( ! slicedSpriteCache[bitmapData][sizeKey])
        {
            slicedSpriteCache[bitmapData][sizeKey] = new SpriteSheetBitmapSlicedCache( bitmapData, imgWidth, imgHeight );
        }
        spriteCache = slicedSpriteCache[bitmapData][sizeKey];
        animSpeed = _animSpeed;
        bmp.x = - imgWidth / 2;
        bmp.y = - imgHeight / 2;
        totalFrames = animSpeed * spriteCache.bds.length;
        currFrame = 0;
        if ( startAtRandomFrame )

        {
            currFrame = Math.random() * totalFrames;
        }
        bmp.bitmapData = spriteCache.bds[Math.floor(currFrame / animSpeed)];
        bmp.smoothing = true;
    }

    public function stepSpriteSheet( stepTime : uint ) : void
    {
        if (isSpriteSheet)
        {
            const nextFrame : uint = (currFrame + stepTime) % totalFrames;
            const nextImageIndex : uint = Math.floor(nextFrame / animSpeed);
            const currImageIndex : uint = Math.floor(currFrame / animSpeed);
            if ( nextImageIndex != currImageIndex )
            {
                bmp.bitmapData = spriteCache.bds[nextImageIndex];
                bmp.smoothing = true;
            }
            currFrame = nextFrame;
        }
    }

    public static function clearBitmapCache() : void
    {
        for ( var key : * in slicedSpriteCache)
        {
            delete slicedSpriteCache[key];
        }
    }

}
}

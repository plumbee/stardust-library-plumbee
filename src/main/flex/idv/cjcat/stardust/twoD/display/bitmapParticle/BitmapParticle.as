package idv.cjcat.stardust.twoD.display.bitmapParticle
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

public class BitmapParticle extends Sprite implements IBitmapParticle
{
    private const bmp : Bitmap = new Bitmap();

    private static const slicedSpriteCache : Dictionary = new Dictionary();
    private var currImage : uint = 0;
    private var currFrame : uint = 0;
    private var spriteCache : SpriteSheetBitmapSlicedCache;
    private var animSpeed : uint;

    public function BitmapParticle()
    {
        addChild( bmp );
    }

    public function initWithSingleBitmap(bitmapData : BitmapData) : void
    {
        bmp.bitmapData = bitmapData;
        bmp.x = - bmp.width * 0.5;
        bmp.y = - bmp.height * 0.5;
    }

    public function initWithSpriteSheet( imgWidth : int, imgHeight : int, _animSpeed : uint,
                                         startAtRandomFrame : Boolean, bitmapData : BitmapData ) : void
    {
        if ( imgWidth > bitmapData.width || imgHeight > bitmapData.height )
        {
            return;
        }
        if ( _animSpeed == 0 )
        {
            _animSpeed = 1;
        }

        if ( ! slicedSpriteCache[bitmapData] )
        {
            slicedSpriteCache[bitmapData] = new Dictionary();
        }
        const sizeKey : String = imgWidth.toString() + imgHeight.toString();
        if ( ! slicedSpriteCache[bitmapData][sizeKey])
        {
            slicedSpriteCache[bitmapData][sizeKey] = new SpriteSheetBitmapSlicedCache();
            SpriteSheetBitmapSlicedCache(slicedSpriteCache[bitmapData][sizeKey]).init( bitmapData, imgWidth, imgHeight );
        }
        spriteCache = slicedSpriteCache[bitmapData][sizeKey];
        animSpeed = _animSpeed;
        currFrame = _animSpeed;
        bmp.x = - imgWidth / 2;
        bmp.y = - imgHeight / 2;
        if ( startAtRandomFrame )
        {
            currImage = Math.random() * spriteCache.bds.length;
        }
        addEventListener( Event.ADDED_TO_STAGE, addEnterFrameListener );
    }

    private function addEnterFrameListener( e : Event ) : void
    {
        removeEventListener( Event.ADDED_TO_STAGE, addEnterFrameListener );
        addEventListener( Event.ENTER_FRAME, onEnterFrame );
        addEventListener( Event.REMOVED_FROM_STAGE, onRemoved );
    }

    private function onEnterFrame( e : Event ) : void
    {
        if ( currFrame == animSpeed )
        {
            bmp.bitmapData = spriteCache.bds[currImage];
            currImage ++;
            if ( currImage == spriteCache.bds.length )
            {
                currImage = 0;
            }
            currFrame = 0;
        }
        currFrame ++;
    }

    private function onRemoved( e : Event ) : void
    {
        currImage = 0;
        currFrame = animSpeed;
        removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved );
        removeEventListener( Event.ENTER_FRAME, onEnterFrame );
        addEventListener( Event.ADDED_TO_STAGE, addEnterFrameListener );
    }

}
}

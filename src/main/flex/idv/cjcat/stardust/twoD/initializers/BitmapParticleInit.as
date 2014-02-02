package idv.cjcat.stardust.twoD.initializers
{

import flash.display.BitmapData;

import idv.cjcat.stardust.common.particles.Particle;
import idv.cjcat.stardust.common.xml.XMLBuilder;
import idv.cjcat.stardust.twoD.display.bitmapParticle.IBitmapParticle;

/**
 * Initializer that allows easy specification of a bitmap for particles.
 * You can either specify a single image or a sprite sheet (e.g. for animated particles.)
 */
public class BitmapParticleInit extends Initializer2D
{
    private var _bitmapData : BitmapData;
    public static const SINGLE_IMAGE : String = "singleImage";
    public static const SPRITE_SHEET : String = "spriteSheet";
    private var _bitmapType : String = SINGLE_IMAGE;
    private var _spriteSheetSliceWidth : int;
    private var _spriteSheetSliceHeight : int;
    private var _spriteSheetAnimationSpeed : uint;
    private var _spriteSheetStartAtRandomFrame : Boolean;

    override public function initialize(particle:Particle):void
    {
        const target : IBitmapParticle = particle.target as IBitmapParticle;
        if (target)
        {
            if (_bitmapType == SINGLE_IMAGE)
            {
                target.initWithSingleBitmap(_bitmapData);
            }
            else if (_bitmapType == SPRITE_SHEET)
            {
                target.initWithSpriteSheet(_spriteSheetSliceWidth, _spriteSheetSliceHeight,
                                           _spriteSheetAnimationSpeed, _spriteSheetStartAtRandomFrame, _bitmapData);
            }
        }
    }

    public function set bitmapData(bitmapData : BitmapData) : void
    {
        _bitmapData = bitmapData;
    }

    public function get bitmapType() : String
    {
        return _bitmapType;
    }

    public function get bitmapData() : BitmapData
    {
        return _bitmapData;
    }

    public function get spriteSheetSliceWidth() : int
    {
        return _spriteSheetSliceWidth;
    }

    public function get spriteSheetSliceHeight() : int
    {
        return _spriteSheetSliceHeight;
    }

    public function get spriteSheetAnimationSpeed() : uint
    {
        return _spriteSheetAnimationSpeed;
    }

    public function get spriteSheetStartAtRandomFrame() : Boolean
    {
        return _spriteSheetStartAtRandomFrame;
    }

    public function set spriteSheetSliceWidth(value : int) : void
    {
        _spriteSheetSliceWidth = value;
    }

    public function set spriteSheetSliceHeight(value : int) : void
    {
        _spriteSheetSliceHeight = value;
    }

    public function set spriteSheetAnimationSpeed(value : uint) : void
    {
        _spriteSheetAnimationSpeed = value;
    }

    public function set spriteSheetStartAtRandomFrame(value : Boolean) : void
    {
        _spriteSheetStartAtRandomFrame = value;
    }

    public function set bitmapType(value : String) : void
    {
        _bitmapType = value;
    }

    //XML
    //------------------------------------------------------------------------------------------------

    override public function getXMLTagName():String {
        return "BitmapParticleInit";
    }

    override public function toXML():XML {
        var xml:XML = super.toXML();

        xml.@bitmapType = bitmapType;
        xml.@spriteSheetSliceWidth = _spriteSheetSliceWidth;
        xml.@spriteSheetSliceHeight = _spriteSheetSliceHeight;
        xml.@spriteSheetAnimationSpeed = _spriteSheetAnimationSpeed;
        xml.@spriteSheetStartAtRandomFrame = _spriteSheetStartAtRandomFrame.toString();

        return xml;
    }

    override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
        super.parseXML(xml, builder);

        if (xml.@bitmapType.length()) _bitmapType = xml.@bitmapType;
        if (xml.@spriteSheetSliceWidth.length()) _spriteSheetSliceWidth = parseFloat(xml.@spriteSheetSliceWidth);
        if (xml.@spriteSheetSliceHeight.length()) _spriteSheetSliceHeight = parseFloat(xml.@spriteSheetSliceHeight);
        if (xml.@spriteSheetAnimationSpeed.length()) _spriteSheetAnimationSpeed = parseInt(xml.@spriteSheetAnimationSpeed);
        if (xml.@spriteSheetStartAtRandomFrame.length()) _spriteSheetStartAtRandomFrame = (xml.@spriteSheetStartAtRandomFrame == "true");
    }

    //------------------------------------------------------------------------------------------------
    //end of XML
}
}

package idv.cjcat.stardustextended.twoD.initializers
{

import flash.geom.Point;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;

import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.twoD.geom.MotionData2D;
import idv.cjcat.stardustextended.twoD.geom.MotionData2DPool;
import idv.cjcat.stardustextended.twoD.particles.Particle2D;
import idv.cjcat.stardustextended.twoD.utils.Base64;
import idv.cjcat.stardustextended.twoD.zones.SinglePoint;
import idv.cjcat.stardustextended.twoD.zones.Zone;

/**
 * Sets a particle's initial position based on the zone plus on a value in the positions array.
 * The current position is: positions[currentFrame] + random point in the zone.
 */
public class PositionAnimated extends Initializer2D
{

    private var _zone : Zone;
    private var _positons : Vector.<Point>;
    private var currentPos : uint;
    public var inheritVelocity : Boolean = false;

    public function PositionAnimated( zone : Zone = null )
    {
        this.zone = zone;
    }

    override public function doInitialize( particles : Vector.<Particle>, currentTime : Number ) : void
    {
        if ( _positons )
        {
            currentPos = currentTime % _positons.length;
        }
        super.doInitialize( particles, currentTime );
    }

    override public function initialize( particle : Particle ) : void
    {
        var p2D : Particle2D = Particle2D( particle );
        var md2D : MotionData2D = zone.getPoint();
        if ( _positons )
        {
            p2D.x = md2D.x + _positons[currentPos].x;
            p2D.y = md2D.y + _positons[currentPos].y;

            if ( inheritVelocity )
            {
                var prevPos : int = (currentPos > 0) ? currentPos - 1 : _positons.length - 1;
                p2D.vx += _positons[currentPos].x - _positons[prevPos].x;
                p2D.vy += _positons[currentPos].y - _positons[prevPos].y;
            }
        }
        else
        {
            p2D.x = md2D.x;
            p2D.y = md2D.y;
        }
        MotionData2DPool.recycle( md2D );
    }

    public function get zone() : Zone
    {
        return _zone;
    }

    public function set zone( value : Zone ) : void
    {
        if ( ! value )
        {
            value = new SinglePoint( 0, 0 );
        }
        _zone = value;
    }

    public function set positions( value : Vector.<Point> ) : void
    {
        _positons = value;
    }

    public function get positions() : Vector.<Point>
    {
        return _positons;
    }

    public function get currentPosition() : Point
    {
        if ( _positons )
        {
            return _positons[currentPos];
        }
        return null;
    }


    //XML
    //------------------------------------------------------------------------------------------------
    override public function getRelatedObjects() : Array
    {
        return [_zone];
    }

    override public function getXMLTagName() : String
    {
        return "PositionAnimated";
    }

    override public function toXML() : XML
    {
        var xml : XML = super.toXML();
        xml.@zone = zone.name;
        xml.@inheritVelocity = inheritVelocity;
        if ( _positons && _positons.length > 0 )
        {
            registerClassAlias( "String", String );
            registerClassAlias( "Point", Point );
            registerClassAlias( "VecPoint", Vector.<Point> as Class );
            var ba : ByteArray = new ByteArray();
            ba.writeObject( _positons );
            xml.@positions = Base64.encode( ba );
        }
        return xml;
    }

    override public function parseXML( xml : XML, builder : XMLBuilder = null ) : void
    {
        super.parseXML( xml, builder );
        if ( xml.@zone.length() )
        {
            zone = builder.getElementByName( xml.@zone ) as Zone;
        }
        if ( xml.@positions.length() )
        {
            registerClassAlias( "String", String );
            registerClassAlias( "Point", Point );
            registerClassAlias( "VecPoint", Vector.<Point> as Class );
            const ba : ByteArray = Base64.decode(xml.@positions);
            ba.position = 0;
            _positons = ba.readObject();
        }
        if ( xml.@inheritVelocity.length() )
        {
            inheritVelocity = (xml.@inheritVelocity == "true");
        }
    }
}
}
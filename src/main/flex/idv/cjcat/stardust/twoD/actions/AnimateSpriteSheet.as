package idv.cjcat.stardust.twoD.actions {

import idv.cjcat.stardust.common.emitters.Emitter;
import idv.cjcat.stardust.common.particles.Particle;
import idv.cjcat.stardust.common.xml.XMLBuilder;
import idv.cjcat.stardust.twoD.display.bitmapParticle.IBitmapParticle;

public class AnimateSpriteSheet extends Action2D{

    override public function update(emitter:Emitter, particle:Particle, timeDelta:Number, currentTime:Number):void {
        const target : IBitmapParticle = particle.target as IBitmapParticle;
        if (target)
        {
            target.stepSpriteSheet( timeDelta );
        }
    }

    //XML
    //------------------------------------------------------------------------------------------------

    override public function getXMLTagName():String {
        return "AnimateSpriteSheet";
    }

    override public function toXML():XML {
        var xml:XML = super.toXML();

        return xml;
    }

    override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
        super.parseXML(xml, builder);
    }

    //------------------------------------------------------------------------------------------------
    //end of XML

}
}

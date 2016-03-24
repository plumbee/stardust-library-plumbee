package idv.cjcat.stardustextended.twoD.starling
{

import com.plumbee.stardustplayer.emitter.StarlingBitmapParticle;

import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.common.utils.construct;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IAnimatedParticle;
import idv.cjcat.stardustextended.twoD.initializers.Initializer2D;

public class StarlingDisplayObjectClass extends Initializer2D
{
	private var _particleConfig : ParticleConfig;

    protected var displayObjectClass:Class;
	protected var constructorParams:Array;

	//HACK: This is a hack to fix the cross-domain dynamic instantiation of stardust objects when run in web-slots-wrapper. The starling bitmap particle here is a copy-paste of the one present in starling-stardust-sim-loader.
	//In web-slots-wrapper this code appears to be being run in the parent application domain, where its definition doesn't exist and therefore cannot be instantiated.
	// To get around this, the definition of StarlingBitmapParticle (including package structure)has been copy-pasted into starling-library
	// so that a definition of it can be accessible in this domain.
	StarlingBitmapParticle;

    public function StarlingDisplayObjectClass(displayObjectClass:Class = null, constructorParams:Array = null, particleConfig : ParticleConfig = null)
    {
        this.displayObjectClass = displayObjectClass;
        this.constructorParams = constructorParams;
	    _particleConfig = particleConfig;
    }

    override public function initialize(particle:Particle):void
    {
        // starling.display.DisplayObject
        var displayObject : * = createParticleDisplayObject(displayObjectClass,constructorParams);
        displayObject.pivotX = 0.5 * displayObject.width;
        displayObject.pivotY = 0.5 * displayObject.height;
        particle.target = displayObject;

	    var animatedParticle : IAnimatedParticle = particle.target as IAnimatedParticle;
	    if(animatedParticle != null && _particleConfig != null)
	    {
		    animatedParticle.animationSpeed = _particleConfig.animationSpeed;
		    animatedParticle.startFromRandomFrame = _particleConfig.startFromRandomFrame;
	    }
    }

	protected function createParticleDisplayObject(displayObjectClass:Class, constructorParams:Array) : *
	{
		return construct(displayObjectClass,constructorParams);
	}

    //XML
    //------------------------------------------------------------------------------------------------

    override public function getXMLTagName():String {
        return "StarlingDisplayObjectClass";
    }

    override public function toXML():XML {
        var xml:XML = super.toXML();
        if (displayObjectClass) {
            xml.@displayObjectClass = getQualifiedClassName( displayObjectClass );
        }
        if (constructorParams && constructorParams.length > 0)
        {
            var paramStr : String = "";
            for (var i:int=0; i< constructorParams.length; i++) {
                paramStr += constructorParams[i] + ",";
            }
            paramStr = paramStr.substr(0, paramStr.length-1);
            xml.@constructorParameters = paramStr;
        }
        return xml;
    }

    override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
        super.parseXML(xml, builder);
        if (xml.@constructorParameters.length()) {
            constructorParams = String(xml.@constructorParameters ).split(",");
        }
        if (xml.@displayObjectClass.length()) {
	        displayObjectClass = getDefinitionByName( xml.@displayObjectClass ) as Class;
        }
    }

    //------------------------------------------------------------------------------------------------
    //end of XML
}
}
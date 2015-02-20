package idv.cjcat.stardustextended.twoD.starling
{

import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.common.utils.construct;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IAnimatedParticle;
import idv.cjcat.stardustextended.twoD.initializers.Initializer2D;

public class StarlingDisplayObjectClass extends Initializer2D
{
	private var _animationSpeed : uint = 1;

    protected var displayObjectClass:Class;
	protected var constructorParams:Array;

    public function StarlingDisplayObjectClass(displayObjectClass:Class = null, constructorParams:Array = null)
    {
        this.displayObjectClass = displayObjectClass;

	    if(constructorParams != null && constructorParams.length == 3)
	    {
		    _animationSpeed = constructorParams.pop();
	    }

        this.constructorParams = constructorParams;
    }

    override public function initialize(particle:Particle):void
    {
        // starling.display.DisplayObject
        var displayObject : * = createParticleDisplayObject(displayObjectClass,constructorParams);
        displayObject.pivotX = 0.5 * displayObject.width;
        displayObject.pivotY = 0.5 * displayObject.height;
        particle.target = displayObject;

	    if(particle.target is IAnimatedParticle)
	    {
		    IAnimatedParticle(particle.target).animationSpeed = _animationSpeed;
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
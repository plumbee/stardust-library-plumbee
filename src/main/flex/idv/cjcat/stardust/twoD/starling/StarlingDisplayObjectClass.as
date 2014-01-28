package idv.cjcat.stardust.twoD.starling
{
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import idv.cjcat.stardust.common.particles.Particle;
import idv.cjcat.stardust.common.utils.construct;
import idv.cjcat.stardust.common.xml.XMLBuilder;
import idv.cjcat.stardust.twoD.initializers.Initializer2D;

import starling.display.DisplayObject;

public class StarlingDisplayObjectClass extends Initializer2D
{
    public var displayObjectClass:Class;
    public var constructorParams:Array;

    public function StarlingDisplayObjectClass(displayObjectClass:Class = null, constructorParams:Array = null)
    {
        this.displayObjectClass = displayObjectClass;
        this.constructorParams = constructorParams;
    }

    override public function initialize(particle:Particle):void
    {
        var target:DisplayObject = construct(displayObjectClass, constructorParams);
        target.pivotX = 0.5 * target.width;
        target.pivotY = 0.5 * target.height;
        particle.target = target;
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
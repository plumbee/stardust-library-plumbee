package idv.cjcat.stardustextended.twoD.starling
{

import idv.cjcat.stardustextended.common.handlers.ParticleHandler;
import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.twoD.display.AddChildMode;
import idv.cjcat.stardustextended.twoD.particles.Particle2D;

public class StarlingHandler extends ParticleHandler
{
	public function StarlingHandler(container : * = null, blendMode : String = "normal", addChildMode : int = 0)
	{
		this.container = container;
		this.blendMode = blendMode;
		this.addChildMode = addChildMode;
	}

	public var addChildMode : int; // starling.display.DisplayObjectContainer
	public var container : Object;
	public var blendMode : String;

	override public function particleAdded(particle : Particle) : void
	{
		var displayObj : * = particle.target;
		displayObj.blendMode = blendMode;

		if (!container)
		{
			return;
		}

		switch (addChildMode)
		{
			default:
			case AddChildMode.RANDOM:
				container.addChildAt(displayObj, Math.floor(Math.random() * container.numChildren));
				break;
			case AddChildMode.TOP:
				container.addChild(displayObj);
				break;
			case AddChildMode.BOTTOM:
				container.addChildAt(displayObj, 0);
				break;
		}
	}

	override public function particleRemoved(particle : Particle) : void
	{
		particle.target.removeFromParent();
	}

	override public function readParticle(particle : Particle) : void
	{
		var p2D : Particle2D = Particle2D(particle);
		IStardustStarlingParticle(particle.target).updateFromModel(
				p2D.x, p2D.y, p2D.rotation, p2D.scale, p2D.alpha
		);
	}

	//XML
	//------------------------------------------------------------------------------------------------

	override public function getXMLTagName() : String
	{
		return "StarlingHandler";
	}

	override public function toXML() : XML
	{
		var xml : XML = super.toXML();

		xml.@addChildMode = addChildMode;
		xml.@blendMode = blendMode;

		return xml;
	}

	override public function parseXML(xml : XML, builder : XMLBuilder = null) : void
	{
		super.parseXML(xml, builder);

		if (xml.@addChildMode.length())
		{
			addChildMode = parseInt(xml.@addChildMode);
		}
		if (xml.@blendMode.length())
		{
			blendMode = (xml.@blendMode);
		}
	}

	//------------------------------------------------------------------------------------------------
	//end of XML
}
}
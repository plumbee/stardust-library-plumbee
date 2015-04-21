package idv.cjcat.stardustextended.twoD.starling
{

import flash.display.BlendMode;

import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.twoD.display.AddChildMode;
import idv.cjcat.stardustextended.twoD.handlers.BlendModeParticleHandler;
import idv.cjcat.stardustextended.twoD.particles.Particle2D;
import idv.cjcat.stardustextended.twoD.utils.BlendModeSets;

public class StarlingHandler extends BlendModeParticleHandler
{
	public var addChildMode : int; // starling.display.DisplayObjectContainer
	public var container : Object;
	private var atfMode: Boolean;

	public function StarlingHandler(container : * = null, blendMode : String = "normal", addChildMode : int = 0, enableATFMode: Boolean = false)
	{
		super(getBlendModeSet(enableATFMode));
		atfMode = enableATFMode;
		this.container = container;
		this.addChildMode = addChildMode;
		this.blendMode = blendMode;
	}

	override public function set blendMode(value: String): void
	{
		super.blendMode = getLegalBlendMode(value);
	}

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

	private function getLegalBlendMode(blendMode: String): String
	{
		return atfMode && (blendMode == BlendMode.ADD) ? BlendModeSets.ATF_ADD_ID : blendMode;
	}

	private function getBlendModeSet(atfMode: Boolean): Vector.<String>
	{
		return atfMode ? BlendModeSets.STARLING_ATF_BLEND_MODES : BlendModeSets.STARLING_REGULAR_BLEND_MODES;
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
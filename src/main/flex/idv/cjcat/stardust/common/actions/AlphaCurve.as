package idv.cjcat.stardust.common.actions {
	import idv.cjcat.stardust.common.easing.EasingFunctionType;
	import idv.cjcat.stardust.common.easing.Linear;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	/**
	 * Alters a particle's alpha value according to its <code>life</code> property.
	 * 
	 * <p>
	 * The alpha transition is applied using the easing functions designed by Robert Penner. 
	 * These functions can be found in the <code>idv.cjcat.stardust.common.easing</code> package.
	 * </p>
	 */
	public class AlphaCurve extends Action {
		
		/**
		 * The initial alpha value of a particle, 0 by default.
		 */
		public var inAlpha:Number;
		/**
		 * The final alpha value of a particle, 0 by default.
		 */
		public var outAlpha:Number;
		
		/**
		 * The transition lifespan of alpha value from the initial alpha to the normal alpha.
		 */
		public var inLifespan:Number;
		/**
		 * The transition lifespan of alpha value from the normal alpha to the final alpha.
		 */
		public var outLifespan:Number;
		
		private var _inFunction:Function;
		private var _outFunction:Function;
		private var _inFunctionExtraParams:Array;
		private var _outFunctionExtraParams:Array;
		
		public function AlphaCurve(inLifespan:Number = 0, outLifespan:Number = 0, inFunction:Function = null, outFunction:Function = null) {
			this.inAlpha = 0;
			this.outAlpha = 0;
			this.inLifespan = inLifespan;
			this.outLifespan = outLifespan;
			this.inFunction = inFunction;
			this.outFunction = outFunction;
			this.inFunctionExtraParams = [];
			this.outFunctionExtraParams = [];
		}
		
		override public final function update(emitter:Emitter, particle:Particle, time:Number):void {
			if ((particle.initLife - particle.life) < inLifespan) {
				particle.alpha = _inFunction.apply(null, [particle.initLife - particle.life, inAlpha, particle.initAlpha - inAlpha, inLifespan].concat(_inFunctionExtraParams));
			} else if (particle.life < outLifespan) {
				particle.alpha = _outFunction.apply(null, [outLifespan - particle.life, particle.initAlpha, outAlpha - particle.initAlpha, outLifespan].concat(_outFunctionExtraParams));
			} else {
				particle.alpha = particle.initAlpha;
			}
		}
		
		/**
		 * Some easing functions take more than four parameters. This property specifies those extra parameters passed to the <code>inFunction</code>.
		 */
		public function get inFunctionExtraParams():Array { return _inFunctionExtraParams; }
		public function set inFunctionExtraParams(value:Array):void {
			if (!value) value = [];
			_inFunctionExtraParams = value;
		}
		
		/**
		 * Some easing functions take more than four parameters. This property specifies those extra parameters passed to the <code>outFunction</code>.
		 */
		public function get outFunctionExtraParams():Array { return _outFunctionExtraParams; }
		public function set outFunctionExtraParams(value:Array):void {
			if (!value) value = [];
			_outFunctionExtraParams = value;
		}
		
		/**
		 * The easing function from the initial alpha to the normal alpha, <code>Linear.easeIn</code> by default.
		 */
		public function get inFunction():Function { return _inFunction; }
		public function set inFunction(value:Function):void {
			if (value == null) value = Linear.easeIn;
			_inFunction = value;
		}
		
		/**
		 * The easing function from the normal alpha to the final alpha, <code>Linear.easeOut</code> by default.
		 */
		public function get outFunction():Function { return _outFunction; }
		public function set outFunction(value:Function):void {
			if (value == null) value = Linear.easeOut;
			_outFunction = value;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "AlphaCurve";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@inAlpha = inAlpha;
			xml.@outAlpha = outAlpha;
			xml.@inLifespan = inLifespan;
			xml.@outLifespan = outLifespan;
			xml.@inFunction = EasingFunctionType.functions[inFunction];
			xml.@outFunction = EasingFunctionType.functions[outFunction];
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@inAlpha.length()) inAlpha = parseFloat(xml.@inAlpha);
			if (xml.@outAlpha.length()) outAlpha = parseFloat(xml.@outAlpha);
			if (xml.@inLifespan.length()) inLifespan = parseFloat(xml.@inLifespan);
			if (xml.@outLifespan.length()) outLifespan = parseFloat(xml.@outLifespan);
			if (xml.@inFunction.length()) inFunction = EasingFunctionType.functions[xml.@inFunction.toString()];
			if (xml.@outFunction.length()) outFunction = EasingFunctionType.functions[xml.@outFunction.toString()];
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
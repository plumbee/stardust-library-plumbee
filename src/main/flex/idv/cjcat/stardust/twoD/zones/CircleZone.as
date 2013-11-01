package idv.cjcat.stardust.twoD.zones {
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData2D;
	import idv.cjcat.stardust.twoD.geom.MotionData2DPool;
	
	/**
	 * Circular zone.
	 */
	public class CircleZone extends Zone {
		
		/**
		 * The X coordinate of the center.
		 */
		public var x:Number;
		/**
		 * The Y coordinate of the center.
		 */
		public var y:Number;
		
		private var _radius:Number;
		//private var _randomR:Random;
		private var _radiusSQ:Number;
		
		public function CircleZone(x:Number = 0, y:Number = 0, radius:Number = 100) {
			this.x = x;
			this.y = y;
			this.radius = radius;
			//this.randomR = randomR;
		}
		
		/**
		 * The radius of the zone.
		 */
		public function get radius():Number { return _radius;  }
		public function set radius(value:Number):void {
			_radius = value;
			_radiusSQ = value * value;
			updateArea();
		}
		
		//public function get randomR():Random { return _randomR; }
		//public function set randomR(value:Random):void {
			//if (!value) value = new UniformRandom();
			//_randomR = value;
		//}
		
		override public function calculateMotionData2D():MotionData2D {
			//randomR.setRange(0, 1);
			var theta:Number = StardustMath.TWO_PI * Math.random();
			//var r:Number = _radius * Math.sqrt(randomR.random());
			var r:Number = _radius * Math.sqrt(Math.random());
			return MotionData2DPool.get(r * Math.cos(theta) + x, r * Math.sin(theta) + y);
		}
		
		override public function contains(x:Number, y:Number):Boolean {
			var dx:Number = this.x - x;
			var dy:Number = this.y - y;
			return ((dx * dx + dy * dy) <= _radiusSQ)?(true):(false);
		}
		
		override protected function updateArea():void {
			area = _radiusSQ * Math.PI;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [];
			//return [_randomR];
		}
		
		override public function getXMLTagName():String {
			return "CircleZone";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x = x;
			xml.@y = y;
			xml.@radius = radius;
			//xml.@randomR = _randomR.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x.length()) x = parseFloat(xml.@x);
			if (xml.@y.length()) y = parseFloat(xml.@y);
			if (xml.@radius.length()) radius = parseFloat(xml.@radius);
			//randomR = builder.getElementByName(xml.@randomR) as Random;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
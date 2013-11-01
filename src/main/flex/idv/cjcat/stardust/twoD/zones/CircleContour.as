package idv.cjcat.stardust.twoD.zones {
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData2D;
	
	/**
	 * Circular contour zone.
	 */
	public class CircleContour extends Contour {
		
		/**
		 * The X coordinate of the center.
		 */
		public var x:Number;
		/**
		 * The Y coordinate of the center.
		 */
		public var y:Number;
		//private var _randomT:Random;
		
		private var _radius:Number;
		private var _r1SQ:Number;
		private var _r2SQ:Number;
		private var _radiusSQ:Number;
		private var _area:Number;
		
		public function CircleContour(x:Number = 0, y:Number = 0, radius:Number = 100) {
			this.x = x;
			this.y = y
			this.radius = radius;
			//this.randomT = randomT;
		}
		
		/**
		 * The radius of the zone.
		 */
		public function get radius():Number { return _radius;  }
		public function set radius(value:Number):void {
			_radius = value;
			_radiusSQ = value * value;
			var r1:Number = value + 0.5 * virtualThickness;
			var r2:Number = value - 0.5 * virtualThickness;
			_r1SQ = r1 * r1;
			_r2SQ = r2 * r2;
			updateArea();
		}
		
		//public function get randomT():Random { return _randomT; }
		//public function set randomT(value:Random):void {
			//if (!value) value = new UniformRandom(Math.PI, Math.PI);
			//_randomT = value;
		//}
		
		override protected function updateArea():void {
			area = (_r1SQ - _r2SQ) * Math.PI * virtualThickness;
		}
		
		override public function contains(x:Number, y:Number):Boolean {
			var dx:Number = this.x - x;
			var dy:Number = this.y - y;
			var dSQ:Number = dx * dx + dy * dy;
			
			if ((dSQ > _r1SQ) || (dSQ < _r2SQ)) return false;
			return true;
		}
		
		override public function calculateMotionData2D():MotionData2D {
			//randomT.setRange(0, StardustMath.TWO_PI);
			//var theta:Number = randomT.random();
			var theta:Number = StardustMath.TWO_PI * Math.random();
			return new MotionData2D(_radius * Math.cos(theta) + x, _radius * Math.sin(theta) + y);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [];
			//return [_randomT];
		}
		
		override public function getXMLTagName():String {
			return "CircleContour";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x = x;
			xml.@y = y;
			xml.@radius = radius;
			//xml.@randomT = _randomT.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x.length()) x = parseFloat(xml.@x);
			if (xml.@y.length()) y = parseFloat(xml.@y);
			if (xml.@radius.length()) radius = parseFloat(xml.@radius);
			//randomT = builder.getElementByName(xml.@randomT) as Random;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
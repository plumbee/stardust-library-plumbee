package idv.cjcat.stardust.twoD.zones {
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData2D;
	
	/**
	 * Line segment zone.
	 */
	public class Line extends Contour {
		
		/**
		 * The X coordinate of one end of the line.
		 */
		public var x1:Number;
		/**
		 * The Y coordinate of one end of the line.
		 */
		public var y1:Number;
		/**
		 * The X coordinate of the other end of the line.
		 */
		public var x2:Number;
		/**
		 * The Y coordinate of the other end of the line.
		 */
		public var y2:Number;
		private var _random:Random;
		public function Line(x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0, random:Random = null) {
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
			this.random = random;
			updateArea();
		}
		
		public function get random():Random { return _random; }
		public function set random(value:Random):void {
			if (!value) value = new UniformRandom();
			_random = value;
		}
		
		override public function calculateMotionData2D():MotionData2D {
			_random.setRange(0, 1);
			var rand:Number = _random.random();
			return new MotionData2D(StardustMath.interpolate(0, x1, 1, x2, rand), StardustMath.interpolate(0, y1, 1, y2, rand));
		}
		
		override public function contains(x:Number, y:Number):Boolean {
			if ((x < x1) && (x < x2)) return false;
			if ((x > x1) && (x > x2)) return false;
			if (((x - x1) / (x2 - x1)) == ((y - y1) / (y2 - y1))) return true;
			return false;
		}
		
		override protected function updateArea():void {
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			area = Math.sqrt(dx * dx + dy * dy) * virtualThickness;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Line";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x1 = x1;
			xml.@y1 = y1;
			xml.@x2 = x2;
			xml.@y2 = y2;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x1.length()) x1 = parseFloat(xml.@x1);
			if (xml.@y1.length()) y1 = parseFloat(xml.@y1);
			if (xml.@x2.length()) x2 = parseFloat(xml.@x2);
			if (xml.@y2.length()) y2 = parseFloat(xml.@y2);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
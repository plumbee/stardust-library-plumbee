package idv.cjcat.stardust.twoD.zones {
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData2D;
	
	/**
	 * Sector-shaped zone.
	 */
	public class SectorZone extends Zone {
		
		/**
		 * The X coordinate of the center of the sector.
		 */
		public var x:Number;
		/**
		 * The Y coordinate of the center of the sector.
		 */
		public var y:Number;
		
		//private var _randomR:Random;
		private var _randomT:Random;
		private var _minRadius:Number;
		private var _maxRadius:Number;
		private var _minAngle:Number;
		private var _maxAngle:Number;
		private var _minAngleRad:Number;
		private var _maxAngleRad:Number;
		private var _r1SQ:Number;
		private var _r2SQ:Number;
		
		public function SectorZone(x:Number = 0, y:Number = 0, minRadius:Number = 0, maxRadius:Number = 100, minAngle:Number = 0, maxAngle:Number = 360) {
			_randomT = new UniformRandom();
			
			this.x = x;
			this.y = y;
			this._minRadius = minRadius;
			this._maxRadius = maxRadius;
			this._minAngle = minAngle;
			this._maxAngle = maxAngle;
			//this.randomR = randomR;
			
			updateArea();
		}
		
		/**
		 * The minimum radius of the sector.
		 */
		public function get minRadius():Number { return _minRadius; }
		public function set minRadius(value:Number):void {
			_minRadius = value;
			updateArea();
		}
		
		/**
		 * The maximum radius of the sector.
		 */
		public function get maxRadius():Number { return _maxRadius; }
		public function set maxRadius(value:Number):void {
			_maxRadius = value;
			updateArea();
		}
		
		/**
		 * The minimum angle of the sector.
		 */
		public function get minAngle():Number { return _minAngle; }
		public function set minAngle(value:Number):void {
			_minAngle = value;
			updateArea();
		}
		
		/**
		 * The maximum angle of the sector.
		 */
		public function get maxAngle():Number { return _maxAngle; }
		public function set maxAngle(value:Number):void {
			_maxAngle = value;
			updateArea();
		}
		
		//public function get randomR():Random { return _randomR; }
		//public function set randomR(value:Random):void {
			//if (!value) value = new UniformRandom();
			//_randomR = value;
		//}
		
		override public function calculateMotionData2D():MotionData2D {
			if (_maxRadius == 0) return new MotionData2D(x, y);
			
			//_randomR.setRange(_minRadius, _maxRadius);
			_randomT.setRange(_minAngleRad, _maxAngleRad);
			var theta:Number = _randomT.random();
			var r:Number = StardustMath.interpolate(0, _minRadius, 1, _maxRadius, Math.sqrt(Math.random()));
			
			return new MotionData2D(r * Math.cos(theta) + x, r * Math.sin(theta) + y);
		}
		
		override protected function updateArea():void {
			
			_minAngleRad = _minAngle * StardustMath.DEGREE_TO_RADIAN;
			_maxAngleRad = _maxAngle * StardustMath.DEGREE_TO_RADIAN;
			var dT:Number = _maxAngleRad - _minAngleRad;
			
			_r1SQ = _minRadius * _minRadius;
			_r2SQ = _maxRadius * _maxRadius;
			var dRSQ:Number = _r2SQ - _r1SQ;
			
			area = Math.abs(dRSQ * dT);
		}
		
		override public function contains(x:Number, y:Number):Boolean {
			return false;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [];
			//return [_randomR];
		}
		
		override public function getXMLTagName():String {
			return "SectorZone";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@x = x;
			xml.@y = y;
			xml.@minRadius = minRadius;
			xml.@maxRadius = maxRadius;
			xml.@minAngle = minAngle;
			xml.@maxAngle = maxAngle;
			//xml.@randomR = randomR.name;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@x.length()) x = parseFloat(xml.@x);
			if (xml.@y.length()) y = parseFloat(xml.@y);
			if (xml.@minRadius.length()) minRadius = parseFloat(xml.@minRadius);
			if (xml.@maxRadius.length()) maxRadius = parseFloat(xml.@maxRadius);
			if (xml.@minAngle.length()) minAngle = parseFloat(xml.@minAngle);
			if (xml.@maxAngle.length()) maxAngle = parseFloat(xml.@maxAngle);
			//randomR = builder.getElementByName(xml.@randomR) as Random;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
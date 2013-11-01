package idv.cjcat.stardust.twoD.zones {
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.Vec2D;
	
	/**
	 * Provides an easier interface to define a sector zone.
	 */
	public class LazySectorZone extends SectorZone {
		
		private var _radius:Number;
		private var _radiusVar:Number;
		private var _direction:Vec2D;
		private var _directionVar:Number;
		
		public function LazySectorZone(radius:Number = 50, radiusVar:Number = 50) {
			_radius = radius;
			_radiusVar = radiusVar;
			_direction = new Vec2D(0, -1);
			_direction.onChange.add(updateSector);
			_directionVar = 180;
			updateSector();
		}
		
		/**
		 * The average radius of the zone.
		 */
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void {
			_radius = value;
			updateSector();
		}
		
		/**
		 * The variation of the radius of the zone.
		 */
		public function get radiusVar():Number { return _radiusVar; }
		public function set radiusVar(value:Number):void {
			_radiusVar = value;
			updateSector();
		}
		
		/**
		 * The direciton of the line dividing the sector.
		 */
		public function get direction():Vec2D { return _direction; }
		
		/**
		 * The variation of the direciton.
		 */
		public function get directionVar():Number { return _directionVar; }
		public function set directionVar(value:Number):void {
			_directionVar = value;
			updateSector();
		}
		
		public function updateSector(vec:Vec2D = null):void {
			minRadius = _radius - _radiusVar;
			maxRadius = _radius + _radiusVar;
			minAngle = _direction.angle - _directionVar;
			maxAngle = _direction.angle + _directionVar;
			updateArea();
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "LazySectorZone";
		}
		
		override public function toXML():XML {
			var xml:XML = getXMLTag();
			
			xml.@radius = radius;
			xml.@radiusVar = radiusVar;
			xml.@directionX = direction.x;
			xml.@directionY = direction.y;
			xml.@directionVar = directionVar;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			_direction.onChange.remove(updateSector);
			
			if (xml.@radius.length()) _radius = parseFloat(xml.@radius);
			if (xml.@radiusVar.length()) _radiusVar = parseFloat(xml.@radiusVar);
			
			var dx:Number = 0;
			var dy:Number = 0;
			if (xml.@directionX.length()) dx = parseFloat(xml.@directionX);
			if (xml.@directionY.length()) dy = parseFloat(xml.@directionY);
			 _direction.set(dx, dy);
			 
			if (xml.@directionVar.length()) _directionVar = parseFloat(xml.@directionVar);
			
			updateSector();
			
			_direction.onChange.add(updateSector);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
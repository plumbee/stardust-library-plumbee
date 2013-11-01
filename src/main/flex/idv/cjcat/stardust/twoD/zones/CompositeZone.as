package idv.cjcat.stardust.twoD.zones {
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.geom.MotionData2D;
	
	/**
	 * This is a group of zones. 
	 * 
	 * <p>
	 * The <code>calculateMotionData2D()</code> method returns random points in these zones. 
	 * These points are more likely to be situated in zones with bigger area.
	 * </p>
	 */
	public class CompositeZone extends Zone {
		
		private var _zones:Array;
		
		public function CompositeZone() {
			_zones = [];
		}
		
		override public function calculateMotionData2D():MotionData2D {
			var position:Number = Math.random() * getArea();
			var sum:Number = 0;;
			for (var i:int = 0; i < _zones.length; i++) {
				sum += Zone(_zones[i]).getArea();
				if (position < sum) {
					return Zone(_zones[i]).calculateMotionData2D();
				}
			}
			
			return new MotionData2D();
		}
		
		override public function contains(x:Number, y:Number):Boolean {
			for each (var zone:Zone in _zones) {
				if (zone.contains(x, y)) return true;
			}
			return false;
		}
		
		public final function addZone(zone:Zone):void {
			_zones.push(zone);
			updateArea()
		}
		
		public final function removeZone(zone:Zone):void {
			var index:int;
			while ((index = _zones.indexOf(zone)) >= 0) {
				_zones.splice(index, 1);
			}
			updateArea()
		}
		
		public final function clearZones():void {
			_zones = [];
			updateArea()
		}
		
		override protected function updateArea():void {
			area = 0;
			for each (var zone:Zone in _zones) {
				area += zone.getArea();
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return _zones;
		}
		
		override public function getXMLTagName():String {
			return "CompositeZone";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			if (_zones.length > 0) {
				xml.appendChild(<zones/>);
				var zone:Zone;
				for each (zone in _zones) {
					xml.zones.appendChild(zone.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			clearZones();
			for each (var node:XML in xml.zones.*) {
				addZone(builder.getElementByName(node.@name) as Zone);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
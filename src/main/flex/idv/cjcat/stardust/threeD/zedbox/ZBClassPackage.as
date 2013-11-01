package idv.cjcat.stardust.threeD.zedbox {
	import idv.cjcat.stardust.common.xml.ClassPackage;
	import idv.cjcat.stardust.threeD.zedbox.actions.ZBBillboardOriented;
	import idv.cjcat.stardust.threeD.zedbox.actions.ZBStardustSpriteUpdate;
	import idv.cjcat.stardust.threeD.zedbox.handlers.ZBDisplayObjectHandler;
	import idv.cjcat.stardust.threeD.zedbox.initializers.ZBDisplayObjectClass;
	import idv.cjcat.stardust.threeD.zedbox.initializers.ZBPooledDisplayObjectClass;
	import idv.cjcat.stardust.threeD.zedbox.initializers.ZBStardustSpriteInit;
	
	/**
	 * Packs together classes for the Stardust ZedBox extension.
	 * 
	 * <p>
	 * To enable XML support for this extension, use the <code>XMLBuilder.registerClassesFromClassPackage()</code> method 
	 * to register related classes to the <code>XMLBuilder</code> object first.
	 * </p>
	 */
	public class ZBClassPackage extends ClassPackage {
		
		private static var _instance:ZBClassPackage;
		
		public static function getInstance():ZBClassPackage {
			if (!_instance) _instance = new ZBClassPackage();
			return _instance;
		}
		
		public function ZBClassPackage() {
			
		}
		
		
		override protected final function populateClasses():void {
			//ZedBox actions
			classes.push(ZBBillboardOriented);
			classes.push(ZBStardustSpriteUpdate);
			
			//ZedBox initializers
			classes.push(ZBDisplayObjectClass);
			classes.push(ZBPooledDisplayObjectClass);
			classes.push(ZBStardustSpriteInit);
			
			//ZedBox particle handlers
			classes.push(ZBDisplayObjectHandler);
		}
	}
}
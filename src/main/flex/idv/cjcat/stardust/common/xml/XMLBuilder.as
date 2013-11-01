package idv.cjcat.stardust.common.xml {
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import idv.cjcat.stardust.common.errors.DuplicateElementNameError;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.Stardust;
	
	//import idv.cjcat.stardust.common.CommonClassPackage;
	//import idv.cjcat.stardust.threeD.ThreeDClassPackage;
	//import idv.cjcat.stardust.twoD.TwoDClassPackage;
	
	/**
	 * <code>XMLBuilder</code> can generate Stardust elements' XML representations and reconstruct elements from existing XML data.
	 * 
	 * <p>
	 * Every <code>StardustElement</code> objects can generate its XML representation through the <code>StardustElement.toXML()</code> method. 
	 * And they can reconstrcut configurations from existing XML data through the <code>StardustElement.parseXML()</code> method.
	 * </p>
	 */
	public class XMLBuilder {
		
		//XML building
		//------------------------------------------------------------------------------------------------
		
		/**
		 * Generate the XML representation of an Stardust element.
		 * 
		 * <p>
		 * All related elements' would be included in the XML representation.
		 * </p>
		 * @param	element
		 * @return
		 */
		public static function buildXML(element:StardustElement):XML {
			var tempElements:Dictionary = new Dictionary();
			var root:XML = <StardustParticleSystem/>;
			root.@version = Stardust.VERSION;
			
			var relatedElements:Dictionary = new Dictionary();
			traverseRelatedObjects(element, relatedElements);
			
			var relatedElementsArray:Array = [];
			var element:StardustElement;
			for each(element in relatedElements) {
				relatedElementsArray.push(element);
			}
			relatedElementsArray.sort(elementTypeSorter);
			
			for each (element in relatedElementsArray) {
				var elementXML:XML = element.toXML();
				var typeXML:XML = element.getElementTypeXMLTag();
				
				if (root[typeXML.name()].length() == 0) root.appendChild(typeXML);
				root[typeXML.name()].appendChild(elementXML);
			}
			
			return root;
		}
		
		private static function elementTypeSorter(e1:StardustElement, e2:StardustElement):Number {
			if (e1.getElementTypeXMLTag().name() > e2.getElementTypeXMLTag().name()) return 1;
			else if (e1.getElementTypeXMLTag().name() < e2.getElementTypeXMLTag().name()) return -1;
			
			if (e1.getXMLTagName() > e2.getXMLTagName()) return 1;
			else if (e1.getXMLTagName() < e2.getXMLTagName())  return -1;
			
			if (e1.name > e2.name) return 1;
			else return -1;
		}
		
		private static function traverseRelatedObjects(element:StardustElement, relatedElements:Dictionary):void {
			if (!element) return;
			
			if (relatedElements[element.name] != undefined) {
				if (relatedElements[element.name] != element) {
					throw new DuplicateElementNameError("Duplicate element name: " + element.name, element.name, relatedElements[element.name], element);
				}
			} else {
				relatedElements[element.name] = element;
			}
			for each (var e:StardustElement in element.getRelatedObjects()) {
				traverseRelatedObjects(e, relatedElements);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML building
		
		
		private var elementClasses:Dictionary;
		private var elements:Dictionary;
		
		public function XMLBuilder() {
			elementClasses = new Dictionary();
			elements = new Dictionary();
			
			//registerClassesFromClassPackage(CommonClassPackage.getInstance());
			//registerClassesFromClassPackage(TwoDClassPackage.getInstance());
			//registerClassesFromClassPackage(ThreeDClassPackage.getInstance());
		}
		
		/**
		 * To use <code>XMLBuilder</code> with your custom subclasses of Stardust elements, 
		 * you must register your class and XML tag name first.
		 * 
		 * <p>
		 * For example, if you register the <code>MyAction</code> class with XML tag name "HelloWorld", 
		 * <code>XMLBuilder</code> knows you are refering to the <code>MyAction</code> class when a <HelloWorld> tag appears in the XML representation.
		 * All default classes in the Stardust engine are already registered, 
		 * </p>
		 * @param	elementClass
		 * @param	xmlTagClassName
		 */
		public function registerClass(elementClass:Class):void {
			var element:StardustElement = StardustElement(new elementClass());
			if (!element) {
				throw new IllegalOperationError("The class is not a subclass of the StardustElement class.");
			}
			if (elementClasses[element.getXMLTagName()] != undefined) {
				throw new IllegalOperationError("This element class name is already registered: " + element.getXMLTagName());
			}
			elementClasses[element.getXMLTagName()] = elementClass;
		}
		
		/**
		 * Registers multiple classes.
		 * @param	classes
		 */
		public function registerClasses(classes:Array):void {
			for each (var c:Class in classes) {
				registerClass(c);
			}
		}
		
		/**
		 * Registers multiple classes from a <code>ClassPackage</code> object.
		 * @param	classPackage
		 */
		public function registerClassesFromClassPackage(classPackage:ClassPackage):void {
			registerClasses(classPackage.getClasses());
		}
		
		/**
		 * Undos the XML tag name registration.
		 * @param	name
		 */
		public function unregisterClass(name:String):void {
			delete elementClasses[name];
		}
		
		/**
		 * After reconstructing elements through the <code>buildFromXML()</code> method, 
		 * reconstructed elements can be extracted through this method.
		 * 
		 * <p>
		 * Each Stardust element has a name; this name is used to identify elements.
		 * </p>
		 * @param	name
		 * @return
		 */
		public function getElementByName(name:String):StardustElement {
			if (elements[name] == undefined) {
				throw new IllegalOperationError("Element not found: " + name);
			}
			return elements[name];
		}
		
		/**
		 * Reconstructs elements from XML representations.
		 * 
		 * <p>
		 * After calling this method, you may extract constrcuted elements through the <code>getElementByName()</code> method.
		 * </p>
		 * @param	xml
		 */
		public function buildFromXML(xml:XML):void {
			if (elements) {
				for (var key:* in elements) {
					delete elements[key];
				}
			}
			elements = new Dictionary();
			
			var element:StardustElement;
			var node:XML;
			for each (node in xml.*.*) {
				element = StardustElement(new elementClasses[node.name()]());
				if (elements[node.@name] != undefined) {
					throw new DuplicateElementNameError("Duplicate element name: " + node.@name, node.@name, elements[node.@name], element);
				}
				elements[node.@name.toString()] = element;
			}
			for each (node in xml.*.*) {
				element = StardustElement(elements[node.@name.toString()]);
				element.parseXML(node, this);
			}
		}
	}
}
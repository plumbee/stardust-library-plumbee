package idv.cjcat.stardust.twoD.actions {
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.actions.ActionCollection;
	import idv.cjcat.stardust.common.actions.Age;
	import idv.cjcat.stardust.common.actions.AlphaCurve;
	import idv.cjcat.stardust.common.actions.CompositeAction;
	import idv.cjcat.stardust.common.actions.DeathLife;
	import idv.cjcat.stardust.common.actions.ScaleCurve;
	import idv.cjcat.stardust.common.actions.triggers.DeathTrigger;
	import idv.cjcat.stardust.common.easing.EasingFunctionType;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	import idv.cjcat.stardust.twoD.deflectors.Deflector;
	import idv.cjcat.stardust.twoD.fields.Field;
	
	/**
	 * This is a wrapper class of several common and useful actions. 
	 * As it's name suggests, you can use this class whenever you're too lazy to create actions one by one.
	 * You don't directly control these component actions; 
	 * instead, you use the abstract properties provided by this class.
	 *  
	 * <p>
	 * This composite action is consisted of the folling actions:
	 * <ul>
	 * <li>Move (multiplier = 1 by default)</li>
	 * <li>Spin (multiplier = 1 by default)</li>
	 * <li>Oriented (false by default)</li>
	 * <li>DeathLife (active by default)</li>
	 * <li>DeathTrigger (empty by default)</li>
	 * <li>Collision (inactive by default)</li>
	 * <li>SpeedLimit (inactive by default)</li>
	 * <li>Deflect (empty by default)</li>
	 * <li>Gravity (empty by default)</li>
	 * <li>Damping (zero damping by default)</li>
	 * <li>Acceleration (zero acceleration by default)</li>
	 * <li>ScaleCurve (zero in and out lifespans by default)</li>
	 * <li>AlphaCurve (zero in and out lifespans by default)</li>
	 * </ul>
	 * </p>
	 */
	public class LazyAction extends CompositeAction {
		
		//tier 1
		private var _age:Age;
		private var _move:Move;
		private var _spin:Spin;
		private var _oriented:Oriented;
		private var _deathLife:DeathLife;
		private var _stardustSpriteUpdateAction:StardustSpriteUpdate;
		private var _deathTrigger:DeathTrigger;
		
		//tier 2
		private var _collide:Collide;
		private var _speedLimit:SpeedLimit;
		private var _deflect:Deflect;
		private var _gravity:Gravity;
		private var _damping:Damping;
		private var _accelerate:Accelerate;
		
		//tier 3
		private var _scaleCurve:ScaleCurve;
		private var _alphaCurve:AlphaCurve;
		
		public function LazyAction() {
			//tier 1
			_age = new Age();
			_deathLife = new DeathLife();
			_move = new Move();
			_spin = new Spin();
			_oriented = new Oriented(1, 90);
			_oriented.active = false;
			_stardustSpriteUpdateAction = new StardustSpriteUpdate();
			_stardustSpriteUpdateAction.active = false;
			_deathTrigger = new DeathTrigger();
			
			superAddAction(_age);
			superAddAction(_deathLife);
			superAddAction(_move);
			superAddAction(_spin);
			superAddAction(_oriented);
			superAddAction(_stardustSpriteUpdateAction);
			superAddAction(_deathTrigger);
			
			
			//tier 2
			_collide = new Collide();
			_speedLimit = new SpeedLimit(25);
			_deflect = new Deflect();
			_gravity = new Gravity();
			_damping = new Damping();
			_accelerate = new Accelerate(0);
			
			_collide.active = false;
			
			superAddAction(_collide);
			superAddAction(_speedLimit);
			superAddAction(_deflect);
			superAddAction(_damping);
			superAddAction(_gravity);
			superAddAction(_accelerate);
			
			
			//tier 3
			_scaleCurve = new ScaleCurve(0, 0);
			_alphaCurve = new AlphaCurve(0, 0);
			
			superAddAction(_scaleCurve);
			superAddAction(_alphaCurve);
		}
		
		override public function get mask():int { return super.mask; }
		override public function set mask(value:int):void {
			super.mask = 
			_move.mask = 
			_spin.mask = 
			_oriented.mask = 
			_deathLife.mask = 
			_stardustSpriteUpdateAction.mask = 
			_deathTrigger.mask = 
			_collide.mask = 
			_speedLimit.mask = 
			_deflect.mask = 
			_damping.mask = 
			_gravity.mask = 
			_accelerate.mask = 
			_scaleCurve.mask = 
			_alphaCurve.mask = value;
		}
		
		
		//tier 1
		//------------------------------------------------------------------------------------------------
		
		/**
		 * The age action's multiplier.
		 */
		public function get ageMultiplier():Number { return _age.multiplier; }
		public function set ageMultiplier(value:Number):void {
			_age.multiplier = value;
		}
		
		/**
		 * The move action's multiplier.
		 */
		public function get moveMultiplier():Number { return _move.multiplier; }
		public function set moveMultiplier(value:Number):void {
			_move.multiplier = value;
		}
		
		/**
		 * The spin action's multiplier.
		 */
		public function get spinMultiplier():Number { return _spin.multiplier; }
		public function set spinMultiplier(value:Number):void {
			_spin.multiplier = value;
		}
		
		/**
		 * Whether the particles rotatoin are oriented to their velocities.
		 */
		public function get oriented():Boolean { return _oriented.active; }
		public function set oriented(value:Boolean):void {
			_oriented.active = value;
		}
		
		/**
		 * The orientation factor, 1 by default.
		 */
		public function get orientationFactor():Number { return _oriented.factor; }
		public function set orientationFactor(value:Number):void {
			_oriented.factor = value;
		}
		
		/**
		 * The orientation offset, 90 by default.
		 */
		public function get orientationOffset():Number { return _oriented.offset; }
		public function set orientationOffset(value:Number):void {
			_oriented.offset = value;
		}
		
		/**
		 * If set to true, particles would not be marked dead when their lives are less than or equal to zero.
		 */
		public function get undead():Boolean { return !_deathLife.active; }
		public function set undead(value:Boolean):void {
			_deathLife.active = !value;
		}
		
		/**
		 * Whether the display class is a <code>StardustSprite</code> subclass, false by default.
		 */
		public function get stardustSpriteUpdate():Boolean { return _stardustSpriteUpdateAction.active; }
		public function set stardustSpriteUpdate(value:Boolean):void {
			_stardustSpriteUpdateAction.active = value;
		}
		
		/**
		 * The death trigger for particles. 
		 * You can add actions that you wish to act on particles upon their death to this action trigger.
		 */
		public function get deathTrigger():DeathTrigger { return _deathTrigger; }
		
		//------------------------------------------------------------------------------------------------
		//end of tier 1
		
		
		//tier 2
		//------------------------------------------------------------------------------------------------
		
		/**
		 * Whether particles would collide against each other.
		 */
		public function get collision():Boolean { return _collide.active; }
		public function set collision(value:Boolean):void {
			_collide.active = value;
		}
		
		/**
		 * The particles' speed limit.
		 */
		public function get speedLimit():Number { return _speedLimit.limit; }
		public function set speedLimit(value:Number):void {
			_speedLimit.limit = value;
		}
		
		/**
		 * You can add deflectors to the simulation with this <code>Deflect</code> object reference.
		 */
		public function get deflectors():Deflect { return _deflect; }
		/**
		 * You can add gravity fields to the simulation with this <code>Gravity</code> object reference.
		 */
		public function get gravity():Gravity { return _gravity; }
		
		/**
		 * The velocity damping coefficient.
		 */
		public function get damping():Number { return _damping.damping; }
		public function set damping(value:Number):void {
			_damping.damping = value;
		}
		
		/**
		 * The particles' velocity acceleration.
		 */
		public function get acceleration():Number { return _accelerate.acceleration; }
		public function set acceleration(value:Number):void {
			_accelerate.acceleration = value;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of tier 2
		
		
		//tier3
		//------------------------------------------------------------------------------------------------
		
		public function get inScale():Number { return _scaleCurve.inScale; }
		public function set inScale(value:Number):void {
			_scaleCurve.inScale = value;
		}
		
		public function get outScale():Number { return _scaleCurve.outScale; }
		public function set outScale(value:Number):void {
			_scaleCurve.outScale = value;
		}
		
		public function get inScaleLifespan():Number { return _scaleCurve.inLifespan; }
		public function set inScaleLifespan(value:Number):void {
			_scaleCurve.inLifespan = value;
		}
		
		public function get outScaleLifespan():Number { return _scaleCurve.outLifespan; }
		public function set outScaleLifespan(value:Number):void {
			_scaleCurve.outLifespan = value;
		}
		
		public function get inScaleFunction():Function { return _scaleCurve.inFunction; }
		public function set inScaleFunction(value:Function):void {
			_scaleCurve.inFunction = value;
		}
		
		public function get outScaleFunction():Function { return _scaleCurve.outFunction; }
		public function set outScaleFunction(value:Function):void {
			_scaleCurve.outFunction = value;
		}
		
		public function get inScaleFunctionExtraParams():Array { return _scaleCurve.inFunctionExtraParams; }
		public function set inScaleFunctionExtraParams(value:Array):void {
			_scaleCurve.inFunctionExtraParams = value;
		}
		
		public function get outScaleFunctionExtraParams():Array { return _scaleCurve.outFunctionExtraParams; }
		public function set outScaleFunctionExtraParams(value:Array):void {
			_scaleCurve.outFunctionExtraParams = value;
		}
		
		public function get inAlpha():Number { return _alphaCurve.inAlpha; }
		public function set inAlpha(value:Number):void {
			_alphaCurve.inAlpha = value;
		}
		
		public function get outAlpha():Number { return _alphaCurve.outAlpha; }
		public function set outAlpha(value:Number):void {
			_alphaCurve.outAlpha = value;
		}
		
		public function get inAlphaLifespan():Number { return _alphaCurve.inLifespan; }
		public function set inAlphaLifespan(value:Number):void {
			_alphaCurve.inLifespan = value;
		}
		
		public function get outAlphaLifespan():Number { return _alphaCurve.outLifespan; }
		public function set outAlphaLifespan(value:Number):void {
			_alphaCurve.outLifespan = value;
		}
		
		public function get inAlphaFunction():Function { return _alphaCurve.inFunction; }
		public function set inAlphaFunction(value:Function):void {
			_alphaCurve.inFunction = value;
		}
		
		public function get outAlphaFunction():Function { return _alphaCurve.outFunction; }
		public function set outAlphaFunction(value:Function):void {
			_alphaCurve.outFunction = value;
		}
		
		public function get inAlphaFunctionExtraParams():Array { return _alphaCurve.inFunctionExtraParams; }
		public function set inAlphaFunctionExtraParams(value:Array):void {
			_alphaCurve.inFunctionExtraParams = value;
		}
		
		public function get outAlphaFunctionExtraParams():Array { return _alphaCurve.outFunctionExtraParams; }
		public function set outAlphaFunctionExtraParams(value:Array):void {
			_alphaCurve.outFunctionExtraParams = value;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of tier 3
		
		
		//additional actions
		//------------------------------------------------------------------------------------------------
		
		protected function superAddAction(action:Action):void {
			super.addAction(action);
		}
		
		private var additionalActions:ActionCollection = new ActionCollection();
		override public function addAction(action:Action):void {
			super.addAction(action);
			additionalActions.addAction(action);
		}
		
		override public function removeAction(action:Action):void {
			super.removeAction(action);
			additionalActions.removeAction(action);
		}
		
		override public function clearActions():void {
			super.clearActions();
			additionalActions.clearActions();
		}
		
		//------------------------------------------------------------------------------------------------
		//end ofadditional actions
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return deathTrigger.sd::actions.sd::actions
					.concat(additionalActions.sd::actions);
		}
		
		override public function getXMLTagName():String {
			return "LazyAction";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			delete xml.actions; 
			
			//tier 1
			xml.@ageMultiplier = ageMultiplier;
			xml.@moveMultiplier = moveMultiplier;
			xml.@spinMultiplier = spinMultiplier;
			xml.@oriented = oriented;
			xml.@orientationFactor = orientationFactor;
			xml.@orientationOffset = orientationOffset;
			xml.@undead = undead;
			xml.@stardustSpriteUpdate = stardustSpriteUpdate;
			
			if (deathTrigger.sd::actions.sd::actions.length > 0) {
				xml.appendChild(<deathTriggerActions/>);
				var action:Action;
				for each (action in deathTrigger.sd::actions.sd::actions) {
					xml.deathTriggerActions.appendChild(action.getXMLTag());
				}
			}
			
			if (additionalActions.sd::actions.length > 0) {
				xml.appendChild(<actions/>);
				for each (action in additionalActions.sd::actions) {
					xml.actions.appendChild(action.getXMLTag());
				}
			}
			
			
			//tier 2
			xml.@collision = collision;
			xml.@speedLimit = speedLimit;
			xml.@damping = damping;
			xml.@acceleration = acceleration;
			
			if (deflectors.sd::deflectors.length > 0) {
				xml.appendChild(<deflectors/>);
				var deflector:Deflector;
				for each (deflector in deflectors.sd::deflectors) {
					xml.deflectors.appendChild(deflector.getXMLTag());
				}
			}
			
			if (gravity.sd::fields.length > 0) {
				xml.appendChild(<gravityFields/>);
				var field:Field;
				for each (field in gravity.sd::fields) {
					xml.gravityFields.appendChild(field.getXMLTag());
				}
			}
			
			
			//tier 3
			xml.@inScale = inScale;
			xml.@outScale = outScale;
			xml.@inScaleLifespan = inScaleLifespan;
			xml.@outScaleLifespan = outScaleLifespan;
			xml.@inScaleFunction = EasingFunctionType.functions[inScaleFunction];
			xml.@outScaleFunction = EasingFunctionType.functions[outScaleFunction];
			xml.@inAlpha = inAlpha;
			xml.@outAlpha = outAlpha;
			xml.@inAlphaLifespan = inAlphaLifespan;
			xml.@outAlphaLifespan = outAlphaLifespan;
			xml.@inAlphaFunction = EasingFunctionType.functions[inAlphaFunction];
			xml.@outAlphaFunction = EasingFunctionType.functions[outAlphaFunction];
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			name = xml.@name;
			active = (xml.@active == "true");
			mask = parseInt(xml.@mask);
			
			
			//tier 1
			if (xml.@ageMultiplier.length()) ageMultiplier = parseFloat(xml.@ageMultiplier);
			if (xml.@moveMultiplier.length()) moveMultiplier = parseFloat(xml.@moveMultiplier);
			if (xml.@spinMultiplier.length()) spinMultiplier = parseFloat(xml.@spinMultiplier);
			if (xml.@oriented.length()) oriented = (xml.@oriented == "true");
			if (xml.@orientationFactor.length()) orientationFactor = parseFloat(xml.@orientationFactor);
			if (xml.@orientationOffset.length()) orientationOffset = parseFloat(xml.@orientationOffset);
			if (xml.@undead.length()) undead = (xml.@undead == "true");
			if (xml.@stardustSpriteUpdate.length()) stardustSpriteUpdate = (xml.@stardustSpriteUpdate == "true");
			
			var node:XML;
			_deathTrigger.clearActions();
			for each (node in xml.deathTriggerActions.*) {
				_deathTrigger.addAction(builder.getElementByName(node.@name) as Action);
			}
			
			additionalActions.clearActions();
			for each (node in xml.actions.*) {
				addAction(builder.getElementByName(node.@name) as Action);
			}
			
			
			//tier 2
			if (xml.@collision.length()) collision = (xml.@collision == "true");
			if (xml.@speedLimit.length()) speedLimit = parseFloat(xml.@speedLimit);
			if (xml.@damping.length()) damping = parseFloat(xml.@damping);
			if (xml.@acceleration.length()) acceleration = parseFloat(xml.@acceleration);
			
			deflectors.clearDeflectors();
			for each (node in xml.deflectors.*) {
				deflectors.addDeflector(builder.getElementByName(node.@name) as Deflector);
			}
			
			gravity.clearFields();
			for each (node in xml.gravityFields.*) {
				gravity.addField(builder.getElementByName(node.@name) as Field);
			}
			
			
			//tier 3
			if (xml.@inScale.length()) inScale = parseFloat(xml.@inScale);
			if (xml.@outScale.length()) outScale = parseFloat(xml.@outScale);
			if (xml.@inScaleLifespan.length()) inScaleLifespan = parseFloat(xml.@inScaleLifespan);
			if (xml.@outScaleLifespan.length()) outScaleLifespan = parseFloat(xml.@outScaleLifespan);
			if (xml.@inScaleFunction.length()) inScaleFunction = EasingFunctionType.functions[xml.@inScaleFunction.toString()];
			if (xml.@outScaleFunction.length()) outScaleFunction = EasingFunctionType.functions[xml.@outScaleFunction.toString()];
			if (xml.@inAlpha.length()) inAlpha = parseFloat(xml.@inAlpha);
			if (xml.@outAlpha.length()) outAlpha = parseFloat(xml.@outAlpha);
			if (xml.@inAlphaLifespan.length()) inAlphaLifespan = parseFloat(xml.@inAlphaLifespan);
			if (xml.@outAlphaLifespan.length()) outAlphaLifespan = parseFloat(xml.@outAlphaLifespan);
			if (xml.@inAlphaFunction.length()) inAlphaFunction = EasingFunctionType.functions[xml.@inAlphaFunction.toString()];
			if (xml.@outAlphaFunction.length()) outAlphaFunction = EasingFunctionType.functions[xml.@outAlphaFunction.toString()];
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
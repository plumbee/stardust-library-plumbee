﻿package idv.cjcat.stardustextended.common.emitters {

import flash.crypto.generateRandomBytes;

import idv.cjcat.stardustextended.cjsignals.ISignal;
import idv.cjcat.stardustextended.cjsignals.Signal;
import idv.cjcat.stardustextended.common.StardustElement;
import idv.cjcat.stardustextended.common.actions.Action;
import idv.cjcat.stardustextended.common.actions.ActionCollection;
import idv.cjcat.stardustextended.common.actions.ActionCollector;
import idv.cjcat.stardustextended.common.clocks.Clock;
import idv.cjcat.stardustextended.common.clocks.ImpulseClock;
import idv.cjcat.stardustextended.common.clocks.SteadyClock;
import idv.cjcat.stardustextended.common.handlers.ParticleHandler;
import idv.cjcat.stardustextended.common.initializers.Initializer;
import idv.cjcat.stardustextended.common.initializers.InitializerCollector;
import idv.cjcat.stardustextended.common.particles.InfoRecycler;
import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.common.particles.PooledParticleFactory;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.sd;

use namespace sd;

	/**
	 * This class takes charge of the actual particle simulation of the Stardust particle system.
	 */
	public class Emitter extends StardustElement implements ActionCollector, InitializerCollector {


		//signals
		//------------------------------------------------------------------------------------------------

		private const _onDischargeComplete: ISignal = new Signal();
		private const _onEmpty:ISignal = new Signal(Emitter);
		private const _onStepBegin:ISignal = new Signal(Emitter, Vector.<Particle>, Number);
		private const _onStepEnd:ISignal = new Signal(Emitter, Vector.<Particle>, Number);
		private const _actionCollection:ActionCollection = new ActionCollection();
        private const activeActions : Vector.<Action> = new Vector.<Action>();

		private var _blendMode: String = "normal";

		public function Emitter(clock:Clock = null, particleHandler:ParticleHandler = null) {
			needsSort = false;

			this.clock = clock;
			this.active = true;
			this.particleHandler = particleHandler;
		}

		//------------------------------------------------------------------------------------------------
		//end of signals


		//particle collections
		//------------------------------------------------------------------------------------------------
		/**
		 * Whether the emitter is active, true by default.
		 *
		 * <p>
		 * If the emitter is active, it creates particles in each step according to its clock.
		 * Note that even if an emitter is not active, the simulation of existing particles still goes on in each step.
		 * </p>
		 */
		public var active:Boolean;
		/** @private */
		public var needsSort:Boolean;

		//------------------------------------------------------------------------------------------------
		//end of particle collections
        public var currentTime : Number = 0;
		/** @private */
		protected var factory:PooledParticleFactory;

		/**
		 * Dispatched when the emitter is empty of particles.
		 * <p/>
		 * Signature: (emitter:Emitter)
		 */
		public function get onEmpty():ISignal { return _onEmpty; }

		/**
		* Dispatched if the clock is an ImpulseClock and the clock
		 * completes a single discharge and any repeats it my have
		 * to do
		 * <p/>
		 * Signature: ()
		* */
		public function get onDischargeComplete() : ISignal	{ return _onDischargeComplete; }

		/**
		 * Dispatched at the beginning of each step.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection, time:Number)
		 */
		public function get onStepBegin():ISignal { return _onStepBegin; }

		/**
		 * Dispatched at the end of each step.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection, time:Number)
		 */
		public function get onStepEnd():ISignal { return _onStepEnd; }

		/** @private */
		sd var _particles:Vector.<Particle> = new Vector.<Particle>();

		/**
		 * Returns an array of particles for custom parameter manipulation.
		 * Note that the returned array is merely a copy of the internal particle array,
		 * so splicing particles out from this array does not remove the particles from simulation.
		 * @return
		 */
		public function get particles():Vector.<Particle> { return _particles; }

		private var _clock:Clock;

		/**
		 * The clock determines how many particles the emitter creates in each step.
		 */
		public function get clock():Clock { return _clock; }

		public function set clock(value:Clock):void {
			if (!value) value = new SteadyClock(0);
			_clock = value;
			setupDischargeSignal();
		}

		public function set ticksPerCall(value : Number) : void
		{
			if(clock is SteadyClock)
			{
				SteadyClock(clock).ticksPerCall = value
			}
		}

		public function get ticksPerCall() : Number
		{
			if(clock is SteadyClock)
			{
				return SteadyClock(clock).ticksPerCall;
			}
			else
			{
				return 0;
			}

		}

		private var _particleHandler:ParticleHandler;

		public function get particleHandler():ParticleHandler { return _particleHandler; }

		public function set particleHandler(value:ParticleHandler):void {
			if (!value) value = ParticleHandler.getSingleton();
			_particleHandler = value;
		}

		//main loop
		//------------------------------------------------------------------------------------------------

		/**
		 * The number of particles in the emitter.
		 */
		public final function get numParticles():int {
			return _particles.length;
		}

		//------------------------------------------------------------------------------------------------
		//end of main loop


		//actions & initializers
		//------------------------------------------------------------------------------------------------

		override public function getRelatedObjects():Array {
			return [_clock].concat(initializers).concat(actions).concat([particleHandler]);
		}

		override public function getXMLTagName():String {
			return "Emitter";
		}

		override public function getElementTypeXMLTag():XML {
			return <emitters/>;
		}

		override public function toXML():XML {
			var xml:XML = super.toXML();

			xml.@active = active.toString();

			xml.@clock = _clock.name;

			xml.@particleHandler = _particleHandler.name;

			if (actions.length) {
				xml.appendChild(<actions/>);
				for each (var action:Action in actions) {
					xml.actions.appendChild(action.getXMLTag());
				}
			}

			if (initializers.length) {
				xml.appendChild(<initializers/>);
				for each (var initializer:Initializer in initializers) {
					xml.initializers.appendChild(initializer.getXMLTag());
				}
			}

			return xml;
		}

		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);

			_actionCollection.clearActions();
			factory.clearInitializers();

			if (xml.@active.length()) active = (xml.@active == "true");
			if (xml.@clock.length()) clock = builder.getElementByName(xml.@clock) as Clock;
			if (xml.@particleHandler.length()) particleHandler = builder.getElementByName(xml.@particleHandler) as ParticleHandler;

			var node:XML;
			for each (node in xml.actions.*) {
				addAction(builder.getElementByName(node.@name) as Action);
			}
			for each (node in xml.initializers.*) {
				addInitializer(builder.getElementByName(node.@name) as Initializer);
			}
		}

		/**
		 * This method is the main simulation loop of the emitter.
		 *
		 * <p>
		 * In order to keep the simulation go on, this method should be called continuously.
		 * It is recommended that you call this method through the <code>Event.ENTER_FRAME</code> event or the <code>TimerEvent.TIMER</code> event.
		 * </p>
		 * @param	time The time interval of a single step of simulation. For instance, doubling this parameter causes the simulation to go twice as fast.
		 */
		public function step(time:Number = 1):void
		{
			stepEmitter(time);
			stepClock();
		}

		private function stepClock() : void
		{
			if(_clock is ImpulseClock)
			{
				const impulseClock : ImpulseClock = ImpulseClock(_clock);
				if (this.currentTime >= impulseClock.nextBurstTime)
				{
					ImpulseClock(_clock).impulse(currentTime);
				}
			}

		}

		public function stepEmitter(time:Number = 1):void {
			onStepBegin.dispatch(this, particles, time);
			_particleHandler.stepBegin(this, particles, time);

			var i:int;
            var len:int;
			var action:Action;
			var p:Particle;
			var key:*;
			var sorted:Boolean = false;

			//query clock ticks
			if (active) {
				var pCount:int = clock.getTicks(time);
				var newParticles:Vector.<Particle> = factory.createParticles(pCount, currentTime);
				addParticles(newParticles);
			}

			//filter out active actions
			activeActions.length = 0;
            len = actions.length;
			for (i = 0; i < len; ++i) {
				action = actions[i];
				if (action.active && action.mask) activeActions.push(action);
			}

			//sorting
			len = activeActions.length;
			for (i = 0; i < len; ++i) {
				action = activeActions[i];
				if (action.needsSortedParticles) {
					//sort particles
					_particles.sort(Particle.compareFunction);
					sorted = true;
					break;
				}
			}
			//invoke action preupdates.
            for (i = 0; i < len; ++i) {
                activeActions[i].preUpdate(this, time);
            }

			//update the remaining particles
            for (var m : int = 0; m < _particles.length; ++m) {
                p = _particles[m];
				for (i = 0; i < len; ++i) {
					action = activeActions[i];

					//update particle
					if (p.mask & action.mask) action.update(this, p, time, currentTime);
				}

				if (p.isDead) {
					//handle dead particle
					for (key in p.recyclers) {
						InfoRecycler(key).recycleInfo(p);
					}
					//invoke handler
					_particleHandler.particleRemoved(p);

					p.destroy();
					factory.recycle(p);

                    _particles.splice(m, 1);
                    m--;
				} else {
					_particleHandler.readParticle(p);
				}
			}

			//postUpdate
			for (i = 0; i < len; ++i) {
                activeActions[i].postUpdate(this, time);
			}

			onStepEnd.dispatch(this, particles, time);
			_particleHandler.stepEnd(this, particles, time);
			if (!numParticles) onEmpty.dispatch(this);

            currentTime = currentTime + time;
		}

		/**
		 * Adds an action to the emitter.
		 * @param	action
		 */
		public function addAction(action:Action):void {
			_actionCollection.addAction(action);
			action.onAdd.dispatch(this, action);
		}

		/**
		 * Removes an action from the emitter.
		 * @param	action
		 */
		public final function removeAction(action:Action):void {
			_actionCollection.removeAction(action);
			action.onRemove.dispatch(this, action);
		}
		//------------------------------------------------------------------------------------------------
		//end of actions & initializers

		/**
		 * Removes all actions from the emitter.
		 */
		public final function clearActions():void {
			var actions:Array = _actionCollection.actions;
			for (var i:int = 0, len:int = actions.length; i < len; ++i) {
				var action:Action = actions[i];
				action.onRemove.dispatch(this, action);
			}
			_actionCollection.clearActions();
		}

		//particles
		//------------------------------------------------------------------------------------------------

		/**
		 * Adds an initializer to the emitter.
		 * @param	initializer
		 */
		public function addInitializer(initializer:Initializer):void {
			factory.addInitializer(initializer);
			initializer.onAdd.dispatch(this, initializer);
		}

		/**
		 * Removes an initializer form the emitter.
		 * @param	initializer
		 */
		public final function removeInitializer(initializer:Initializer):void {
			factory.removeInitializer(initializer);
			initializer.onRemove.dispatch(this, initializer);
		}

		/**
		 * Removes all initializers from the emitter.
		 */
		public final function clearInitializers():void {
			var initializers:Array = factory.initializerCollection.initializers;
			for (var i:int = 0, len:int = initializers.length; i < len; ++i) {
				var initializer:Initializer = initializers[i];
				initializer.onRemove.dispatch(this, initializer);
			}
			factory.clearInitializers();
		}

		//------------------------------------------------------------------------------------------------
		//end of particles


		//XML
		//------------------------------------------------------------------------------------------------

        /**
         * Resets all properties to their default values and removes all particles.
         */
        public function reset() : void
        {
            currentTime = 0;
            clearParticles();
            for (var i:int = 0; i < initializers.length; ++i) {
                Initializer(initializers[i]).reset();
            }
            for (i = 0; i < actions.length; ++i) {
                Action(actions[i]).reset();
            }
            clock.reset();
        }

		public function set maxDischarges(dischargeLimit : int) : void
		{
			if(clock is ImpulseClock)
			{
				(clock as ImpulseClock).dischargeLimit = dischargeLimit;
			}
		}

		private function setupDischargeSignal() : void
		{
			if(clock is ImpulseClock)
			{
				(clock as ImpulseClock).dischargeComplete.add(_onDischargeComplete.dispatch);
			}
		}

		/**
		 * This method is used to manually add existing particles to the emitter's simulation.
		 *
		 * <p>
		 * You should use the <code>particleFactory</code> class to manually create particles.
		 * </p>
		 * @param	particles
		 */
		public final function addParticles(particles:Vector.<Particle>):void {
            var particle:Particle;
            const plen : uint = particles.length;
            for (var m : int = 0; m < plen; ++m) {
                particle = particles[m];
				_particles.push(particle);
				//handle adding
				_particleHandler.particleAdded(particle);
			}
		}

		/**
		 * Clears all particles from the emitter's simulation.
		 */
		public final function clearParticles():void {
			var particle:Particle;
            for (var m : int = 0; m < _particles.length; ++m) {
                particle = _particles[m];
				//handle removal
				_particleHandler.particleRemoved(particle);

				particle.destroy();
				factory.recycle(particle);
			}
			_particles = new Vector.<Particle>();
		}

		public function removeInitializersByClass(classToRemove : Class) : void
		{
			for(var i:uint=0;i<initializers.length;i++){
				if(initializers[i] is classToRemove){
					initializers.splice(i,1);
					--i;
				}
			}
		}

		public function getInitializersByClass(initializerClazz : Class) : Vector.<Initializer>
		{
			return Vector.<Initializer>(initializers.filter(function(element:Initializer, index:int, arr:Array):Boolean{
				return element is initializerClazz;
			}));
		}

		public function getActionsByClass(actionClazz: Class): Vector.<Action>
		{
			return Vector.<Action>(actions.filter(function(element: Action, index:int, arr:Array): Boolean{
				return element is actionClazz;
			}));
		}

		/** @private */
		sd final function get actions():Array { return _actionCollection.sd::actions; }

		/** @private */
		sd final function get initializers():Array { return factory.sd::initializerCollection.sd::initializers; }

		//------------------------------------------------------------------------------------------------
		//end of XML

		public function get blendMode() : String
		{
			return _blendMode;
		}

		public function set blendMode(value : String) : void
		{
			_blendMode = value;
		}
	}
}
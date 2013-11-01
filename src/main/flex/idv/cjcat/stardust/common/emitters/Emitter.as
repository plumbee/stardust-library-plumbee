package idv.cjcat.stardust.common.emitters {
	import idv.cjcat.signals.ISignal;
	import idv.cjcat.signals.Signal;
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.actions.ActionCollection;
	import idv.cjcat.stardust.common.actions.ActionCollector;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.common.handlers.ParticleHandler;
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.initializers.InitializerCollector;
	import idv.cjcat.stardust.common.particles.InfoRecycler;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.particles.ParticleCollectionType;
	import idv.cjcat.stardust.common.particles.ParticleFastArray;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.particles.ParticleList;
	import idv.cjcat.stardust.common.particles.PooledParticleFactory;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This class takes charge of the actual particle simulation of the Stardust particle system.
	 */
	public class Emitter extends StardustElement implements ActionCollector, InitializerCollector {
		
		
		//signals
		//------------------------------------------------------------------------------------------------
		
		private var _onEmpty:ISignal = new Signal(Emitter);
		/**
		 * Dispatched when the emitter is empty of particles.
		 * <p/>
		 * Signature: (emitter:Emitter)
		 */
		public function get onEmpty():ISignal { return _onEmpty; }
		
		private var _onStepBegin:ISignal = new Signal(Emitter, ParticleCollection, Number);
		/**
		 * Dispatched at the beginning of each step.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection, time:Number)
		 */
		public function get onStepBegin():ISignal { return _onStepBegin; }
		
		private var _onStepEnd:ISignal = new Signal(Emitter, ParticleCollection, Number);
		/**
		 * Dispatched at the end of each step.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection, time:Number)
		 */
		public function get onStepEnd():ISignal { return _onStepEnd; }
		
		//------------------------------------------------------------------------------------------------
		//end of signals
		
		
		//particle collections
		//------------------------------------------------------------------------------------------------
		
		/** @private */
		sd var _particles:ParticleCollection;
		/**
		 * Returns an array of particles for custom parameter manipulation. 
		 * Note that the returned array is merely a copy of the internal particle array, 
		 * so splicing particles out from this array does not remove the particles from simulation.
		 * @return
		 */
		public function get particles():ParticleCollection { return _particles; }
		
		//------------------------------------------------------------------------------------------------
		//end of particle collections
		
		
		private var _clock:Clock;
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
		
		/** @private */
		protected var factory:PooledParticleFactory;
		
		private var _actionCollection:ActionCollection = new ActionCollection();
		
		private var _particleHandler:ParticleHandler;
		public function get particleHandler():ParticleHandler { return _particleHandler; }
		public function set particleHandler(value:ParticleHandler):void {
			if (!value) value = ParticleHandler.getSingleton();
			_particleHandler = value;
		}
		
		public function Emitter(clock:Clock = null, particleHandler:ParticleHandler = null,  particlesCollectionType:int = 0) {
			needsSort = false;
			
			this.clock = clock;
			this.active = true;
			this.particleHandler = particleHandler;
			this.particleCollectionType = particlesCollectionType;
		}
		
		/**
		 * The clock determines how many particles the emitter creates in each step.
		 */
		public function get clock():Clock { return _clock; }
		public function set clock(value:Clock):void {
			if (!value) value = new SteadyClock(0);
			_clock = value;
		}
		
		//main loop
		//------------------------------------------------------------------------------------------------
		
		/**
		 * This method is the main simulation loop of the emitter.
		 * 
		 * <p>
		 * In order to keep the simulation go on, this method should be called continuously. 
		 * It is recommended that you call this method through the <code>Event.ENTER_FRAME</code> event or the <code>TimerEvent.TIMER</code> event.
		 * </p>
		 * @param	time The time interval of a single step of simulation. For instance, doubling this parameter causes the simulation to go twice as fast.
		 */
		public final function step(time:Number = 1):void {
			onStepBegin.dispatch(this, particles, time);
			_particleHandler.stepBegin(this, particles, time);
			
			var i:int, len:int;
			var action:Action;
			var activeActions:Array;
			var p:Particle;
			var key:*;
			var iter:ParticleIterator;
			var sorted:Boolean = false;
			
			//query clock ticks
			if (active) {
				var pCount:int = clock.getTicks(time);
				var newParticles:ParticleCollection = factory.createParticles(pCount);
				addParticles(newParticles);
			}
			
			//filter out active actions
			activeActions = [];
			
			for (i = 0, len = actions.length; i < len; ++i) {
				action = actions[i];
				if (action.active && action.mask) activeActions.push(action);
			}
			
			
			//sorting
			for (i = 0, len = activeActions.length; i < len; ++i) {
				action = activeActions[i];
				if (action.needsSortedParticles) {
					//sort particles
					_particles.sort();
					
					//set sorted index iterators
					iter = _particles.getIterator();
					while (p = iter.particle()) {
						p.sortedIndexIterator = iter.clone();
						iter.next();
					}
					sorted = true;
					break;
				}
			}
			
			len = activeActions.length;
			
			//update the first particle + invoke action preupdates.
			iter = _particles.getIterator();
			p = iter.particle();
			if (p) {
				for (i = 0; i < len; ++i) {
					action = activeActions[i];
					
					//preUpdate
					action.preUpdate(this, time);
					
					//update particle
					if (action.mask & p.mask) action.update(this, p, time);
				}
				
				if (p.isDead) {
					//handle dead particle
					for (key in p.recyclers) {
						InfoRecycler(key).recycleInfo(p);
					}
					
					//handle removal
					_particleHandler.particleRemoved(p);
					//p.handler().particleRemoved(p);
					
					p.destroy();
					factory.recycle(p);
					
					iter.remove();
				} else {
					_particleHandler.readParticle(p);
					//p.handler().readParticle(p);
					iter.next();
				}
			}
			
			//update the remaining particles
			while (p = iter.particle()) {
				for (i = 0; i < len; ++i) {
					action = activeActions[i];
					
					//update particle
					if (p.mask & action.mask) action.update(this, p, time);
				}
				
				if (p.isDead) {
					//handle dead particle
					for (key in p.recyclers) {
						InfoRecycler(key).recycleInfo(p);
					}
					//invoke handler
					_particleHandler.particleRemoved(p);
					//p.handler().particleRemoved(p);
					
					p.destroy();
					factory.recycle(p);
					
					iter.remove();
				} else {
					_particleHandler.readParticle(p);
					//p.handler().readParticle(p);
					iter.next();
				}
			}
			
			//postUpdate
			for (i = 0; i < len; ++i) {
				action = activeActions[i];
				action.postUpdate(this, time);
			};
			
			onStepEnd.dispatch(this, particles, time);
			_particleHandler.stepEnd(this, particles, time);
			if (!numParticles) onEmpty.dispatch(this);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of main loop
		
		
		//actions & initializers
		//------------------------------------------------------------------------------------------------
		/** @private */
		sd final function get actions():Array { return _actionCollection.sd::actions; }
		
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
		
		/** @private */
		sd final function get initializers():Array { return factory.sd::initializerCollection.sd::initializers; }
		
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
		//end of actions & initializers
		
		
		//particles
		//------------------------------------------------------------------------------------------------
		
		/**
		 * The number of particles in the emitter.
		 */
		public final function get numParticles():int {
			return _particles.size;
		}
		
		/**
		 * This method is used to manually add existing particles to the emitter's simulation.
		 * 
		 * <p>
		 * You should use the <code>particleFactory</code> class to manually create particles.
		 * </p>
		 * @param	particles
		 */
		public final function addParticles(particles:ParticleCollection):void {
			var particle:Particle;
			var iter:ParticleIterator = particles.getIterator();
			while (particle = iter.particle()) {
				_particles.add(particle);
				
				//handle adding
				_particleHandler.particleAdded(particle);
				//particle.handler().particleAdded(particle);
				
				iter.next();
			}
		}
		
		/**
		 * Clears all particles from the emitter's simulation.
		 */
		public final function clearParticles():void {
			var particle:Particle;
			var iter:ParticleIterator = _particles.getIterator();
			while (particle = iter.particle()) {
				//handle removal
				_particleHandler.particleRemoved(particle);
				//particle.handler().particleRemoved(particle);
				
				particle.destroy();
				factory.recycle(particle);
				
				iter.remove();
			}
			
			_particles.clear();
		}
		
		/**
		 * Determines the collection used internally by the emitter. There are two options: linked-lists and arrays. 
		 * Linked-Lists are generally faster to iterate through and remove particles from, while arrays are faster at sorting. 
		 * By default, linked-lists are used. Switch to arrays if the particles need to be sorted.
		 * 
		 * <p>
		 * There are two possible values that can assigned to this property: <code>ParticleCollectionType.LINKED_LIST</code> and <code>ParticleCollectionType.ARRAY</code>.
		 * </p>
		 * @see idv.cjcat.stardust.common.particles.ParticleCollectionType
		 */
		public function get particleCollectionType():int {
			if (_particles is ParticleFastArray) return ParticleCollectionType.FAST_ARRAY;
			else if (_particles is ParticleList) return ParticleCollectionType.LINKED_LIST;
			return -1;
		}
		
		public function set particleCollectionType(value:int):void {
			var temp:ParticleCollection;
			
			switch (value) {
				case ParticleCollectionType.FAST_ARRAY:
					temp = new ParticleFastArray();
					break;
				default:
				case ParticleCollectionType.LINKED_LIST:
					temp = new ParticleList();
					break;
			}
			
			if (_particles) {
				var iter:ParticleIterator = _particles.getIterator();
				var p:Particle;
				while (p = iter.particle()) {
					temp.add(p);
					iter.remove();
				}
			}
			
			_particles = temp;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of particles
		
		
		//XML
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
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
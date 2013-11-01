package idv.cjcat.stardust.twoD.actions  {
	import idv.cjcat.signals.ISignal;
	import idv.cjcat.signals.Signal;
	import idv.cjcat.stardust.common.easing.EasingFunctionType;
	import idv.cjcat.stardust.common.easing.Linear;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.actions.Action2D;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * Restores particle states to previously taken "snapshot" by the <code>Snapshot</code> class. 
	 * You can also specify the duration and easing curve for the restoration process.
	 * 
	 * <p>
	 * Default priority = -7;
	 * </p>
	 * 
	 * @see idv.cjcat.stardust.twoD.actions.Snapshot
	 */
	public class SnapshotRestore extends Action2D {
		
		
		//signals
		//------------------------------------------------------------------------------------------------
		
		private var _onComplete:ISignal = new Signal(SnapshotRestore);
		/**
		 * Dispatched when the snapshot restoration is complete.
		 * <p/>
		 * Signature: (snapshotRestore:SnapshotRestore)
		 */
		public function get onComplete():ISignal { return _onComplete; }
		
		//------------------------------------------------------------------------------------------------
		//end of signals
		
		
		/**
		 * Flags determining whether the positions, rotations, or scales of particles are restored.
		 * @see idv.cjcat.stardust.twoD.actions.SnapshotRestoreFlag
		 */
		public var flags:int;
		private var _duration:Random;
		private var _curve:Function;
		
		public function SnapshotRestore(duration:Random = null, flags:int = 1, curve:Function = null) {
			priority = -7;
			
			this.duration = duration;
			this.flags = flags;
			this.curve = curve;
		}
		
		private var _started:Boolean = false;
		private var _started2:Boolean = false;
		private var _counter:Number;
		private var _maxDuration:Number;
		public function start():void {
			_started = true;
			_started2 = true;
			_counter = 0;
			_maxDuration = _duration.getRange()[1];
		}
		
		/**
		 * The duration of snapshot restoration for a particle.
		 */
		public function get duration():Random { return _duration; }
		public function set duration(value:Random):void {
			if (!value) value = new UniformRandom(0, 0);
			_duration = value;
		}
		private var _durationKey:Object = {};
		
		override public function preUpdate(emitter:Emitter, time:Number):void {
			_counter += time;
			_counter = StardustMath.clamp(_counter, 0, _maxDuration);
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			if (!_started) {
				skipThisAction = true;
				return;
			}
			
			var p2D:Particle2D = Particle2D(particle);
			if (!p2D.dictionary[Snapshot]) return;
			
			if (_started2) {
				p2D.dictionary[SnapshotRestore] = new SnapshotData(p2D);
				p2D.dictionary[_durationKey] = _duration.random();
			}
			var initData:SnapshotData = p2D.dictionary[SnapshotRestore] as SnapshotData;
			var finalData:SnapshotData = p2D.dictionary[Snapshot] as SnapshotData;
			var duration:Number = p2D.dictionary[_durationKey];
			var counter:Number = StardustMath.clamp(_counter, 0, duration);
			
			if (flags & SnapshotRestoreFlag.POSITION) {
				p2D.x = curve.apply(null, [counter, initData.x, finalData.x - initData.x, duration]);
				p2D.y = curve.apply(null, [counter, initData.y, finalData.y - initData.y, duration]);
			}
			
			if (flags & SnapshotRestoreFlag.ROTATION) {
				p2D.rotation = curve.apply(null, [counter, initData.rotation, finalData.rotation - initData.rotation, duration]);
			}
			
			if (flags & SnapshotRestoreFlag.SCALE) {
				p2D.scale = curve.apply(null, [counter, initData.scale, finalData.scale - initData.scale, duration]);
			}
			
			p2D.vx = p2D.vy = p2D.omega = 0;
		}
		
		override public function postUpdate(emitter:Emitter, time:Number):void {
			if (_started2) _started2 = false;
			if (_started) {
				if (_counter >= _maxDuration) {
					_started = false;
					onComplete.dispatch(this);
				}
			}
		}
		
		/**
		 * The easing function for snapshot restoration.
		 */
		public function get curve():Function { return _curve; }
		public function set curve(value:Function):void {
			if (value == null) value = Linear.easeOut;
			_curve = value;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_duration];
		}
		
		override public function getXMLTagName():String {
			return "SnapshotRestore";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@duration = duration.name;
			xml.@flags = flags;
			xml.@curve = EasingFunctionType.functions[curve];
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@duration.length()) duration = builder.getElementByName(xml.@duration) as Random;
			if (xml.@flags.length()) flags = parseInt(xml.@flags);
			if (xml.@curve.length()) curve = EasingFunctionType.functions[xml.@curve.toString()];
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}
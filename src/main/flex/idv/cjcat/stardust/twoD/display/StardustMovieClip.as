package idv.cjcat.stardust.twoD.display {
	import flash.display.MovieClip;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	
	public class StardustMovieClip extends MovieClip implements IStardustSprite {
		
		public function StardustMovieClip() {
			
		}
		
		/**
		 * Default behavior: MovieClip.gotoAndPlay(1);
		 */
		public function init(particle:Particle):void {
			gotoAndPlay(1);
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(emitter:Emitter, particle:Particle, time:Number):void {
			
		}
		
		/**
		 * Default behavior: MovieClip.stop();
		 */
		public function disable():void {
			stop();
		}
	}
}
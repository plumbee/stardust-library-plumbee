/**
 * Created by guymclean on 14/04/2015.
 */
package idv.cjcat.stardustextended.twoD.utils
{
import flash.display.BlendMode;

public class BlendModeSets
{

	//This string id is copied by the one created by Roger's extended flump runtime (which also registers the custom blend mode)
	//Which means this is dependant upon FlumpExtendedRuntime, should be refactored eventually.
	public static const ATF_ADD_ID: String = "atf_add";

	public static const STARLING_REGULAR_BLEND_MODES : Vector.<String> = new <String>[
		BlendMode.NORMAL,
		BlendMode.MULTIPLY,
		BlendMode.SCREEN,
		BlendMode.ADD,
		BlendMode.ERASE
	];

	public static const STARLING_ATF_BLEND_MODES : Vector.<String> = new <String>[
		BlendMode.NORMAL,
		BlendMode.MULTIPLY,
		BlendMode.SCREEN,
		ATF_ADD_ID,
		BlendMode.ERASE
	];
}
}

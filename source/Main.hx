package;

import openfl.Lib;
import flixel.FlxG;
import flixel.system.FlxSplash;
import openfl.display.Sprite; //for main ig
import openfl.display.StageScaleMode;
import flixel.FlxGame;
import openfl.events.Event;
import WallpaperState;

/**
 * Command-line argument modes for the executable, which controls what GUI elements are shown.
 * 
 * **Flags:**
 * ```haxe
 * // Wallpaper-specific
 * if (Main.mode == Wallpaper) {fullGUIRender(elements);} // Interactive UI goes here
 * // Screen-saver specific
 * if (Main.mode == ScreenSaver) {limitedRender(elements);} // Only HUD elements go here
 * ```
 */
enum Args {
	/**
	* **Wallpaper context for rendering interactive elements.**
	*/
	Wallpaper;
	/**
	* **Screen saver context for general elements.**
	*/
	ScreenSaver;
}
class Main extends Sprite {
	/**
		Window initialization settings for FlxGame, derived from Psych Engine.
	**/
    var state = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: WallpaperState, // starting state
		zoom: -1.0, // game state bounds, SET TO -1 FOR CALCULATIONS
		framerate: 60,
		skipSplash: false, // Flixel splash
		startFullscreen: false
	};
	/**App context for object rendering optimization.*/
	public static var mode:Args = Wallpaper;
	private final arg:Array<String> = Sys.args();

	// You can ignore everything below this point unless you want to add other contexts.
    
	public function new() {
        super();
		if (arg.length == 1) {
			if (arg[0] == "--scr") {
				mode = ScreenSaver;
			}
		}

        FlxSplash.creditOverride(Context.Wallpaper);
        if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
    }

    public static function main():Void
	{
		Lib.current.addChild(new Main());
	}
    private function init(?E:Event):Void {
        if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);
		setupGame();
    }
    private function setupGame() {
		FlxG.autoPause = false;
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (state.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / state.width;
			var ratioY:Float = stageHeight / state.height;
			state.zoom = Math.min(ratioX, ratioY);
			state.width = Math.ceil(stageWidth / state.zoom);
			state.height = Math.ceil(stageHeight / state.zoom);
		}
        addChild(new FlxGame(state.width, state.height, state.initialState, #if (flixel < "5.0.0") state.zoom, #end state.framerate, state.framerate, state.skipSplash, state.startFullscreen));

		Sys.println("%%%%% Post-setup %%%%%\n");
    }
}
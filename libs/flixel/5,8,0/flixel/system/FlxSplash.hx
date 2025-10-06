package flixel.system;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite; //e
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

enum Context {
	PsychSource;
	Wallpaper;
	Custom(path:String);
}

class FlxSplash extends FlxState
{
	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;
	var sprite = new FlxSprite();
	var _sprite:Sprite;
	var _gfx:Graphics;
	var _text:TextField;
	var _credit:TextField;

	var init = new FlxTimer();

	var _times:Array<Float>;
	var _colors:Array<Int>;
	var _functions:Array<Void->Void>;
	var _curPart:Int = 0;
	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;
	
	var initBool:Bool = false;

	var nextState:NextState;

	static var contextOverride:String = "bulkAssets/bozo.png"; //default..
	public static function creditOverride(ctx:Context):Void {
		switch(ctx) {
			case Wallpaper:
				contextOverride = "bulkAssets/bozo.png";
			case Custom(path):
				contextOverride = path;
			default:
				throw "Invalid splash override context.";
		} //custom
	}
	
	public function new(nextState:NextState)
	{
		super();
		this.nextState = nextState;
	}
	
	override public function create():Void
	{
		//Sys.sleep(1);
		init.start(0.5, function(init:FlxTimer) { //oops i forgot
			_cachedBgColor = FlxG.cameras.bgColor;
			FlxG.cameras.bgColor = FlxColor.BLACK;
	
			// This is required for sound and animation to synch up properly
			_cachedTimestep = FlxG.fixedTimestep;
			FlxG.fixedTimestep = false;
	
			_cachedAutoPause = FlxG.autoPause;
			FlxG.autoPause = false;
	
			#if FLX_KEYBOARD
			FlxG.keys.enabled = false;
			#end
	
			_times = [0.041, 0.184, 0.334, 0.495, 0.636];
			_colors = [0x00b922, 0xffc132, 0xf5274e, 0x3641ff, 0x04cdfb];
			_functions = [drawGreen, drawYellow, drawRed, drawBlue, drawLightBlue];
	
			for (time in _times)
			{
				new FlxTimer().start(time, timerCallback);
			}
	
			var stageWidth:Int = Lib.current.stage.stageWidth;
			var stageHeight:Int = Lib.current.stage.stageHeight;

			//Gotta self insert ykyk
			trace("Context for override: "+ contextOverride);
			sprite.loadGraphic(contextOverride ?? "bulkAssets/bozo.png");
			sprite.x = 680;
			sprite.y = 230;

			_sprite = new Sprite();
			FlxG.stage.addChild(_sprite);
			_gfx = _sprite.graphics;
			_sprite.x = (480);
			_sprite.y = (320);
	
			_text = new TextField();
			_text.selectable = false;
			_text.embedFonts = true;
			var dtf = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xffffff);
			dtf.align = TextFormatAlign.CENTER;
			_text.defaultTextFormat = dtf;
			_text.text = "HaxeFlixel - Testing";
			FlxG.stage.addChild(_text);
			_text.x = _sprite.x - 53;
			_text.y = _sprite.y + 80;

			//hehe more funni
			_credit = new TextField();
			_credit.selectable = false;
			_credit.embedFonts = true;
			_credit.defaultTextFormat = dtf;
			_credit.text = "Edited";
			FlxG.stage.addChild(_credit);
			_credit.x = sprite.x + 23;
			_credit.y = sprite.y + 160;
			onResize(stageWidth, stageHeight);
	
			#if FLX_SOUND_SYSTEM
			if (!muted)
			{
				FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel")).play();
			}
			#end
			initBool = true;
		});
	}

	override public function destroy():Void
	{
		_sprite = null;
		_gfx = null;
		_text = null;
		_times = null;
		_colors = null;
		_functions = null;
		_credit = null;
		super.destroy();
	}
	
	function complete()
	{
		FlxG.switchState(nextState);
	}
	
	override public function onResize(Width:Int, Height:Int):Void
	{
		if (initBool) {
		super.onResize(Width, Height);

		_sprite.x = (Width / 2) - 150;
		_sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

		_text.width = Width / FlxG.game.scaleX;
		_text.x = Width;
		_text.y = _sprite.y + 80 * FlxG.game.scaleY;

		_sprite.scaleX = _text.scaleX = FlxG.game.scaleX;
		_sprite.scaleY = _text.scaleY = FlxG.game.scaleY;
		}
	}

	function timerCallback(Timer:FlxTimer):Void
	{
		var guh = new FlxTimer();
		var qwe = new FlxTimer();
		_functions[_curPart]();
		_text.textColor = _colors[_curPart];
		
		_text.text = "HaxeFlixel - Testing";
		_curPart++;

		if (_curPart == 5)
		{
			_credit.textColor = 0x55D7F8;
			qwe.start(0.15, function(qwe:FlxTimer) {
				_credit.textColor = 0x2AD3FD;
				qwe.start(0.15, function(qwe:FlxTimer) {
					_credit.textColor = 0x00CCFF;
				});
			});
			add(sprite);
			// Make the logo a tad bit longer, so our users fully appreciate our hard work :D
			FlxTween.tween(_sprite, {alpha: 0}, 3.0, {ease: FlxEase.quadOut, onComplete: (_)->complete()});
			FlxTween.tween(_text, {alpha: 0}, 3.0, {ease: FlxEase.quadOut});
			FlxTween.tween(sprite, {alpha: 0}, 3.0, {ease: FlxEase.quadOut, onComplete: (_)->complete()});
			FlxTween.tween(_credit, {alpha: 0}, 3.6, {ease: FlxEase.quadOut});
			guh.start(0.1, function(guh:FlxTimer) {
				FlxTween.tween(_sprite, {y: 1000}, 1.6, {ease: FlxEase.quintIn});
				FlxTween.tween(_text, {y: 1000}, 1.6, {ease: FlxEase.quintIn});
				FlxTween.tween(sprite, {y: 1000}, 1.6, {ease: FlxEase.quintIn});
				FlxTween.tween(_credit, {y: 1000}, 1.6, {ease: FlxEase.quintIn});
			});
		}
	}

	function drawGreen():Void
	{
		_gfx.beginFill(_colors[0]	/*0x00b922*/);
		_gfx.moveTo(0, -37);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(0, -37);
		_gfx.endFill();
		trace("fun");
	}

	function drawYellow():Void
	{
		_credit.text = "Edited by";
		_gfx.beginFill(_colors[1]/*0xeeff00*/);
		_gfx.moveTo(-50, -50);
		_gfx.lineTo(-25, -50);
		_gfx.lineTo(0, -37);
		_gfx.lineTo(-37, 0);
		_gfx.lineTo(-50, -25);
		_gfx.lineTo(-50, -50);
		_gfx.endFill();
		trace("ny");
	}

	function drawRed():Void
	{
		_credit.text = "Edited by\nPotate";
		_gfx.beginFill(_colors[2]/*0x9f00fc*/);
		_gfx.moveTo(50, -50);
		_gfx.lineTo(25, -50);
		_gfx.lineTo(1, -37);
		_gfx.lineTo(37, 0);
		_gfx.lineTo(50, -25);
		_gfx.lineTo(50, -50);
		_gfx.endFill();
		trace("self");
	}

	function drawBlue():Void
	{
		_credit.text = "Edited by\nPotateX";
		_gfx.beginFill(_colors[3]/*0x3641ff*/);
		_gfx.moveTo(-50, 50);
		_gfx.lineTo(-25, 50);
		_gfx.lineTo(0, 37);
		_gfx.lineTo(-37, 1);
		_gfx.lineTo(-50, 25);
		_gfx.lineTo(-50, 50);
		_gfx.endFill();
		trace("in");
	}

	function drawLightBlue():Void
	{
		_credit.text = "Edited by\nPotateX2";
		_gfx.beginFill(_colors[4] /*0x04cdfb*/);
		_gfx.moveTo(50, 50);
		_gfx.lineTo(25, 50);
		_gfx.lineTo(1, 37);
		_gfx.lineTo(37, 1);
		_gfx.lineTo(50, 25);
		_gfx.lineTo(50, 50);
		_gfx.endFill();
		trace("sert");
	}

	override function startOutro(onOutroComplete:() -> Void)
	{
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end
		FlxG.stage.removeChild(_sprite);
		FlxG.stage.removeChild(_text);
		FlxG.stage.removeChild(_credit);
		
		super.startOutro(onOutroComplete);
	}
}

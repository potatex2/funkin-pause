import haxe.Json; // parser
import openfl.Lib;
import sys.io.Process as Cmd;
import sys.io.File;
import sys.FileSystem;

import flixel.FlxState;
import flixel.FlxSprite as Img;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxCamera as HUD;
import flixel.math.FlxMath;
import classes.PathSound as Music;
import classes.UI;
import classes.Bar;
import flixel.tweens.*;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop as BG;
import Main;

/**
 * **The bulk of what's rendered on your screen (or window, if you're testing or debugging).**
 * 
 * All elements that will be rendered must be placed here through `add()`
 */
class WallpaperState extends FlxState {
    /**
    * **The directory where all the assets are jumbled up.**
    *     
    * _I know, I know, not a good practice... this is a hyperfixation, alright?_
    */
    public var RootDirectory:String = "bulkAssets/";

    /**
    * **You know I had to do a self-insert for this. :3**
    * 
    * _Placeholder image that bops to the music beat (independent of `camHUD`)._
    */
    var bopper:Img;
    /**
     * Camera instance for anything that will bop to the music playing.
     */
    var camHUD:HUD;
    var bgGoofy:BG;
    public var pause:Music = new Music();
    public var toggle:Music = new Music();

    var startBop:Bool = false;
    var bopConst:Float;
    var jason:Int;
    var shutdown:UI;
    var files:UI;
    var realTime:FlxText;
    var musicProg:Bar;
    override function create() {
        super.create();

        if (FileSystem.exists(RootDirectory + "bgGoofy.png")) trace("okay");
        FlxG.autoPause = false; // DO NOT TOUCH THIS, IT'S A WALLPAPER FOR A REASON.
		bgGoofy = new BG(RootDirectory + "bgGoofy.png"); 
		bgGoofy.updateHitbox(); 
		bgGoofy.alpha = 1; 
		bgGoofy.screenCenter(X); 
		add(bgGoofy);
        bgGoofy.alpha = 0;
        bgGoofy.angle = 45/2;
        bgGoofy.velocity.set(50, 25); // Yes it does, Flixel. Yes. It. Does.
        FlxTween.tween(bgGoofy, {alpha: 0.25}, 1.4, {ease: FlxEase.quartInOut});

        pause.soundCheck("pause.ogg", false);
        camHUD = new HUD();
        FlxG.cameras.add(camHUD, false);
        camHUD.bgColor.alpha = 0; // Yes. It. Does.

        bopper = new Img(FlxG.width + 200, FlxG.height / 2).loadGraphic(RootDirectory + "bozo.png");
        bopper.alpha = 0;
        add(bopper);
        //bopper.cameras = [camHUD];

        realTime = new FlxText(FlxG.width - 405, FlxG.height - 25, 400, "Current Time: ", 20);
        realTime.alpha = 0.001;
        realTime.setFormat("PhantomMuff.ttf", 20, 0xff8aff86, "right");
        add(realTime);
        realTime.cameras = [camHUD];
        FlxTween.tween(realTime, {alpha: 1}, 1.4, {ease: FlxEase.sineInOut});

        musicProg = new Bar(0, FlxG.height - 18, "musicBar", function() return pause.time / pause.length);
        musicProg.alpha = 0;
        add(musicProg);
        FlxTween.tween(musicProg, {alpha: 0.7}, 1.4, {ease: FlxEase.sineInOut});

        // differentiate for screen saver

        if (Main.mode == Wallpaper) {
            shutdown = new UI(FlxG.width - 100, FlxG.height - 60, "Shutdown", () -> {
                if (!shutdown.buffer) {
                    shutdown.buffer = true;
                    Type.createInstance(Cmd, ["shutdown /p"]);
                    toggle.soundCheck("ToggleJingle.ogg");
                    new FlxTimer().start(1, (_) -> shutdown.buffer = false);
                }
            });
            add(shutdown);
            shutdown.alpha = 0;
            FlxTween.tween(shutdown, {alpha: 1}, 1.7, {ease: FlxEase.sineOut});

            files = new UI(FlxG.width - 100, FlxG.height - 80, "Desktop", () -> {
                if (!files.buffer) {
                    files.buffer = true;
                    Type.createInstance(Cmd, ["explorer \""+Sys.getEnv("USERPROFILE")+"\\Desktop\""]);
                    toggle.soundCheck("ToggleJingle.ogg");
                    new FlxTimer().start(1, (_) -> files.buffer = false);
                }
            });
            add(files);
            files.alpha = 0;
            FlxTween.tween(files, {alpha: 1}, 1.7, {ease: FlxEase.sineOut});
        }

        if (FileSystem.exists(RootDirectory + "metadata.json")) {
            jason = Json.parse(File.getContent(RootDirectory + "metadata.json")).song.bpm;
            trace('Data BPM: $jason');
        }
        FlxTween.tween(bopper, {alpha: 1, x: FlxG.width/2}, 1.7, {ease: FlxEase.sineOut, onComplete: (_) -> {startBop = true; bopConst = bopper.x;}});
    }

    var boopWay:Bool = true;
    var delayy:Bool = false;
    var camBeat:Int;
    override function update(elapsed:Float) {
        var secondsTotal:Float = FlxMath.roundDecimal(pause.time / 1000, 4);
        var croshet:Float = FlxMath.roundDecimal(60 / jason,4);
        if (secondsTotal % croshet >= 0 && secondsTotal % croshet <= 0.025) {
            if (!delayy) {
                if (startBop) {
                    FlxTween.completeTweensOf(bopper);
                    camBeat++;
                    if (camBeat % 2 == 0) {
                        camHUD.zoom = 1.01;
                        FlxTween.tween(camHUD, {zoom: 1}, croshet*1.02, {ease: FlxEase.sineOut});
                    }
                    bopper.x += (camBeat % 2 == 0 ? 5 : -5);
                    FlxTween.tween(bopper, {x: bopConst}, croshet * 0.97, {ease: FlxEase.expoOut});
                }
                boopWay = !boopWay;
                bopper.angle = boopWay ? 10 : -10;
                bopper.scale.set(0.9,0.9); //YES. IT. DOES.
                FlxTween.tween(bopper, {angle: 0}, croshet/1.2, {ease: FlxEase.circOut});
                FlxTween.tween(bopper.scale, {x: 0.75, y: 0.75}, croshet/1.5, {ease: FlxEase.quadOut});
                delayy = true;
                new FlxTimer().start(croshet/4, (_) -> delayy = false);
            }
        }

        var timestuff:String = Date.now().toString();
        var aawur:Int = Std.parseInt(timestuff.substring(timestuff.substring(11,12) == "0" ? 12 : 11, 13));
        var AmPm:String = (aawur <= 11 ? " AM" : " PM");
        var Hour12:Int = ((aawur == 0 || aawur == 12) ? 12 : Std.parseInt(timestuff.substring(11,13)) % 12);
        realTime.text = "Current Time: " + Hour12 + timestuff.substr(13) + AmPm;

        super.update(elapsed);
    }
}
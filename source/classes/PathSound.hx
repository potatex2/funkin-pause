package classes;

import flixel.sound.FlxSound;
import flixel.FlxG;
import sys.FileSystem;
import WallpaperState;

class PathSound extends FlxSound {
    var RootDirectory:String = "bulkAssets/";
    public function soundCheck(path:String, sound:Bool = true):Void {
        if (this == null || !FileSystem.exists(RootDirectory + path)) return;
        try {
            this.loadEmbedded(RootDirectory + path, !sound);
            FlxG.sound.list.add(this);
            trace('$path | in '+FlxG.sound.list);
            this.play();
        } catch(nul) throw nul;
    }
}
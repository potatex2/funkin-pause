package classes;

import flixel.ui.FlxButton;

class UI extends FlxButton {
    public var buffer:Bool = false;
    public function new(x:Int, y:Int, text:String, func:Void->Void) {
        super(x, y, text, func);
    }
}
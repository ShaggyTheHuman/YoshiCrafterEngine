package options;

import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class OptionScreen extends MusicBeatState {
    public var options:Array<FunkinOption> = [];

    public var emptyTxt:FlxText;
    public var canSelect:Bool = true;
    public var curSelected:Int = 0;

    var spawnedOptions:Array<OptionSprite> = [];
    public function new() {
        super();
    }
    public override function create() {
        super.create();
        CoolUtil.addBG(this);
        if (options.length <= 0) {
            emptyTxt = new FlxText(0, 0, 0, "Oops! Seems like this menu is empty.\nPress [Esc] to go back.\n");
            emptyTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            emptyTxt.antialiasing = true;
            emptyTxt.scrollFactor.set();
            emptyTxt.screenCenter();
            emptyTxt.offset.y = 50;
            emptyTxt.alpha = 0;
            add(emptyTxt);
        } else {
            for(o in options) {
                var option = new OptionSprite(o);
                spawnedOptions.push(option);
                add(option);
            }
        }
    }

    var time:Float = 0;
    public override function update(elapsed:Float) {
        super.update(elapsed);
        time += elapsed;
        if (controls.BACK) onExit();
        if (options.length <= 0) {
            var l = FlxEase.quintOut(FlxMath.bound(time, 0, 1));
            emptyTxt.offset.y = FlxMath.lerp(50, 0, l);
            emptyTxt.alpha = FlxMath.lerp(0, 1, l);
            return;   
        }
        for(k=>o in spawnedOptions) {
            var i = k - curSelected;
            o.x = FlxMath.lerp(o.x, 0 + (i * 10), 0.125 * elapsed * 60);
            o.y = FlxMath.lerp(o.y, ((FlxG.height / 2) - 50) + (i * 125), 0.125 * elapsed * 60);
            o.alpha = FlxMath.lerp(o.alpha, k == curSelected ? 1 : 0.3, 0.125 * elapsed * 60);
        }
        if (canSelect) {
            var oldCur = curSelected;
            if (controls.DOWN_P)
                curSelected++;
            if (controls.UP_P)
                curSelected--;
            if (curSelected != oldCur) {
                while(curSelected < 0) curSelected += spawnedOptions.length;
                curSelected %= spawnedOptions.length;
                CoolUtil.playMenuSFX(0);
            }
        }
    }

    public function onExit() {
        FlxG.switchState(new MainMenuState());
    }
}
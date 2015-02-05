package com.nevosoft.skiptest;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import haxe.Timer;
import openfl.text.TextFormat;
import openfl.text.TextField;

/**
 * ...
 * @author kukuruz
 */

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	private var _renderFrameTime: Float; // precalculated duration of render frame
	
	
	public static inline var RENDER_FPS:Int = 60;
	
	
	private var _lastRenderTickTime:Float = 0.0;
	
	
	var tf:TextField;
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		tf = new TextField();
		tf.text = "started \n";
		tf.defaultTextFormat = new TextFormat( null, 14, 0xffffff);
		tf.width = 600;
		tf.height = 1000;
		addChild( tf );

		
      
		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
		
		_renderFrameTime       = 1.0 / Main.RENDER_FPS;
		addEventListener(Event.ENTER_FRAME, onFrame);
		
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	//Event handlers
	private function onFrame(event: Event):Void 
	{
		var dt:Float = 0;
		
		
        var currTime:Float = Timer.stamp();
		
		//if not first tick
		if (_lastRenderTickTime != 0.0)		
			dt = (currTime - _lastRenderTickTime); 					
		else		
		{
			_lastRenderTickTime = currTime;			
			return;
		}
		
		
		
		
		if (dt >= _renderFrameTime)
		{
			var fr: Int = Math.floor(dt / _renderFrameTime);
			if (fr > 2)
			{
				tf.text += 'skip frame warning: ${fr - 1} frames, ct: $currTime, ltt: $_lastRenderTickTime \n';				
			}
			_lastRenderTickTime = currTime;
		}
	}	
	
	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}

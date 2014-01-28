package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;
import flash.events.Event;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class CodecBlock extends AnimatedObject
{

	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/codec-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 743, 6, 96, 161, 0.3, false);
		createAnimation('1', 0, 743, 1, 96, 161);
		createAnimation('2', 161, 743, 1, 96, 161);
		createAnimation('3', 161*2, 743, 1, 96, 161);
		createAnimation('4', 161*3, 743, 1, 96, 161);
		createAnimation('5', 161*4, 743, 1, 96, 161);
		createAnimation('6', 161*5, 743, 1, 96, 161);
		createAnimation('7', 161*6, 743, 1, 96, 161);
		createAnimation('8', 161*7, 743, 1, 96, 161);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
}
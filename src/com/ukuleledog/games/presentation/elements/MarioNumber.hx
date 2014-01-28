package com.ukuleledog.games.presentation.elements;

import com.ukuleledog.games.presentation.core.AnimatedObject;

import flash.display.Bitmap;
import openfl.Assets;
import flash.events.Event;
import box2D.common.math.B2Vec2;

/**
 * ...
 * @author Matt
 */
class MarioNumber extends AnimatedObject
{

	private var status:String = 'full';
	
	public function new() 
	{
		super();
		this.bmd = Assets.getBitmapData("img/mario-sprite.png",true);
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		createAnimation('idle', 0, 734, 1, 8, 8);
		createAnimation('0', 0, 734, 1, 8, 8);
		createAnimation('1', 8, 734, 1, 8, 8);
		createAnimation('2', 14, 734, 1, 8, 8);
		createAnimation('3', 22, 734, 1, 8, 8);
		createAnimation('4', 30, 734, 1, 8, 8);
		createAnimation('5', 38, 734, 1, 8, 8);
		createAnimation('6', 46, 734, 1, 8, 8);
		createAnimation('7', 54, 734, 1, 8, 8);
		createAnimation('8', 62, 734, 1, 8, 8);
		createAnimation('9', 70, 734, 1, 8, 8);
		animate();
		
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	public function empty() : Bool
	{
		if ( status == 'full' )
			return false;
		return true;
	}
	
	public function hit()
	{
		status = 'empty';
		setAnimation('empty');
	}
	
}
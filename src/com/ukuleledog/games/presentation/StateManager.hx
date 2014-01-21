package com.ukuleledog.games.presentation;

import com.ukuleledog.games.presentation.states.CodecState;
import com.ukuleledog.games.presentation.states.FightState;
import com.ukuleledog.games.presentation.states.MapState;
import com.ukuleledog.games.presentation.states.MarioState;
import com.ukuleledog.games.presentation.states.SplashState;
import com.ukuleledog.games.presentation.states.State;
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author Matt
 */
class StateManager extends Sprite
{

	private static var instance:StateManager;
	private var currentState:State;
	
	private function new() 
	{
		super();
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	public static function getInstance() : StateManager
	{
		if ( instance == null )
			instance = new StateManager();
			
		return instance;
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
				
		currentState = new MarioState();
		currentState.addEventListener(Event.COMPLETE, mapHandle);
		addChild(currentState);
	}
	
	private function mapHandle( e:Event )
	{
		currentState.removeEventListener(Event.COMPLETE, mapHandle);
		removeChild(currentState);
		currentState = null;
		
		currentState = new MapState();
		currentState.addEventListener(Event.COMPLETE, marioHandle);
		addChild(currentState);
	}
	
	private function marioHandle( e:Event )
	{
		currentState.removeEventListener(Event.COMPLETE, marioHandle);
		removeChild(currentState);
		currentState = null;
		
		currentState = new MarioState();
		currentState.addEventListener(Event.COMPLETE, ff6Handle);
		addChild(currentState);
	}
	
	private function ff6Handle( e:Event )
	{
		currentState.removeEventListener(Event.COMPLETE, ff6Handle);
		removeChild(currentState);
		currentState = null;
		
		currentState = new FightState();
		currentState.addEventListener(Event.COMPLETE, codecHandle);
		addChild(currentState);
	}
	
	private function codecHandle( e:Event )
	{
		currentState.removeEventListener(Event.COMPLETE, codecHandle);
		removeChild(currentState);
		currentState = null;
		
		currentState = new CodecState();
		currentState.addEventListener(Event.COMPLETE, personaHandle);
		addChild(currentState);
	}
	
	private function personaHandle( e:Event )
	{
		currentState.removeEventListener(Event.COMPLETE, personaHandle);
		removeChild(currentState);
		currentState = null;
		
		trace("persona");
	}
	
}
package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.LoadSimEvent;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.net.FileFilter;
import flash.net.FileReference;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class FileLoadCommand implements ICommand
{

    private var _loadFile : FileReference;

    [Inject]
    public var dispatcher : IEventDispatcher;

    public function execute() : void
    {
        _loadFile = new FileReference();
        _loadFile.addEventListener( Event.SELECT, selectHandler );
        _loadFile.addEventListener( Event.CANCEL, cancelHandler );
        _loadFile.browse( [new FileFilter( "Stardust editor project (*.sde)", "*.sde" )] );
    }

    private function cancelHandler( event : Event ) : void
    {
        _loadFile.removeEventListener( Event.SELECT, selectHandler );
        _loadFile.removeEventListener( Event.CANCEL, cancelHandler );
    }

    private function selectHandler( event : Event ) : void
    {
        _loadFile.removeEventListener( Event.SELECT, selectHandler );
        _loadFile.removeEventListener( Event.CANCEL, cancelHandler );

        _loadFile.addEventListener( Event.COMPLETE, loadCompleteHandler );
        _loadFile.load();
    }

    private function loadCompleteHandler( event : Event ) : void
    {
        _loadFile.removeEventListener( Event.COMPLETE, loadCompleteHandler );

        var fileName : String = _loadFile.name;
        var fileNameNoExtension : String = fileName.substr(0, fileName.lastIndexOf(".")  );

        dispatcher.dispatchEvent( new LoadSimEvent(_loadFile.data, fileNameNoExtension) );
    }

}
}


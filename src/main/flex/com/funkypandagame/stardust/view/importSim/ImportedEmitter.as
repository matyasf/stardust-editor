package com.funkypandagame.stardust.view.importSim
{
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import flash.display.BitmapData;

public class ImportedEmitter
{
    private var _emitterVo : EmitterValueObject;
    private var _emitterImages : Vector.<BitmapData>;

    public function ImportedEmitter(emitterValueObject : EmitterValueObject, images : Vector.<BitmapData>)
    {
        _emitterVo = emitterValueObject;
        _emitterImages = images;
    }

    public function get emitterImages():Vector.<BitmapData>
    {
        return _emitterImages;
    }

    public function get emitterVo():EmitterValueObject
    {
        return _emitterVo;
    }
}
}

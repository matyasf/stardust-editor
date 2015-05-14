package com.funkypandagame.stardust.config
{

import com.funkypandagame.stardust.controller.AddEmitterCommand;
import com.funkypandagame.stardust.controller.ChangeEmitterInFocusCommand;
import com.funkypandagame.stardust.controller.CloneEmitterCommand;
import com.funkypandagame.stardust.controller.FileLoadCommand;
import com.funkypandagame.stardust.controller.ImpulseClockRendererUpdateEmitterInfoCommand;
import com.funkypandagame.stardust.controller.InitializeZoneDrawerFromEmitterCommand;
import com.funkypandagame.stardust.controller.ChangeBackgroundCommand;
import com.funkypandagame.stardust.controller.LoadEmitterImageFromFileReferenceCommand;
import com.funkypandagame.stardust.controller.LoadEmitterPathCommand;
import com.funkypandagame.stardust.controller.LoadSimCommand;
import com.funkypandagame.stardust.controller.MainEnterFrameLoopCommand;
import com.funkypandagame.stardust.controller.OnActionACAddCommand;
import com.funkypandagame.stardust.controller.OnActionACRemoveCommand;
import com.funkypandagame.stardust.controller.OnInitializerACAddCommand;
import com.funkypandagame.stardust.controller.OnInitializerACRemoveCommand;
import com.funkypandagame.stardust.controller.RegenerateEmitterTexturesCommand;
import com.funkypandagame.stardust.controller.RemoveEmitterCommand;
import com.funkypandagame.stardust.controller.SaveSimCommand;
import com.funkypandagame.stardust.controller.SetEmitterInFocusClockTypeToImpulseCommand;
import com.funkypandagame.stardust.controller.SetEmitterInFocusClockTypeToSteadyCommand;
import com.funkypandagame.stardust.controller.StartSimCommand;
import com.funkypandagame.stardust.controller.StoreParticleSnapshotCommand;
import com.funkypandagame.stardust.controller.UpdateClockInEmitterGroupCommand;
import com.funkypandagame.stardust.controller.UpdateClockValuesFromModelCommand;
import com.funkypandagame.stardust.controller.UpdateEmitterDropDownListCommand;
import com.funkypandagame.stardust.controller.UpdateEmitterInfoTicksPerCallCommand;
import com.funkypandagame.stardust.controller.events.BackgroundChangeEvent;
import com.funkypandagame.stardust.controller.events.ChangeEmitterInFocusEvent;
import com.funkypandagame.stardust.controller.events.CloneEmitterEvent;
import com.funkypandagame.stardust.controller.events.EmitterChangeEvent;
import com.funkypandagame.stardust.controller.events.FileLoadEvent;
import com.funkypandagame.stardust.controller.events.LoadSimEvent;
import com.funkypandagame.stardust.controller.events.RegenerateEmitterTexturesEvent;
import com.funkypandagame.stardust.controller.events.SaveSimEvent;
import com.funkypandagame.stardust.controller.events.SnapshotEvent;
import com.funkypandagame.stardust.controller.events.StartSimEvent;
import com.funkypandagame.stardust.controller.events.UpdateClockValuesFromModelEvent;
import com.funkypandagame.stardust.controller.events.UpdateEmitterDropDownListEvent;
import com.funkypandagame.stardustplayer.ISimLoader;
import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardust.view.BackgroundProvider;
import com.funkypandagame.stardust.view.EmittersUIView;
import com.funkypandagame.stardust.view.ParticleHandlerContainer;
import com.funkypandagame.stardust.view.StardusttoolMainView;
import com.funkypandagame.stardust.view.events.ClockTypeChangeEvent;
import com.funkypandagame.stardust.view.events.ImpulseClockRendererUpdateEmitterInfoEvent;
import com.funkypandagame.stardust.view.events.InitializeZoneDrawerFromEmitterGroupEvent;
import com.funkypandagame.stardust.view.events.LoadEmitterImageFromFileEvent;
import com.funkypandagame.stardust.view.events.MainEnterFrameLoopEvent;
import com.funkypandagame.stardust.view.events.OnActionACChangeEvent;
import com.funkypandagame.stardust.view.events.OnInitializerACChangeEvent;
import com.funkypandagame.stardust.view.events.PositionInitializerEmitterPathEvent;
import com.funkypandagame.stardust.view.events.UpdateClockInEmitterGroupEvent;
import com.funkypandagame.stardust.view.events.UpdateEmitterInfoTicksPerCallEvent;
import com.funkypandagame.stardust.view.mediators.BackgroundProviderMediator;
import com.funkypandagame.stardust.view.mediators.ClockContainerMediator;
import com.funkypandagame.stardust.view.mediators.EmittersUIViewMediator;
import com.funkypandagame.stardust.view.mediators.ImpulseClockRendererMediator;
import com.funkypandagame.stardust.view.mediators.ParticleHandlerContainerMediator;
import com.funkypandagame.stardust.view.mediators.PositionInitializerMediator;
import com.funkypandagame.stardust.view.mediators.StardusttoolMainViewMediator;
import com.funkypandagame.stardust.view.mediators.SteadyClockRendererMediator;
import com.funkypandagame.stardust.view.stardust.common.clocks.ClockContainer;
import com.funkypandagame.stardust.view.stardust.common.clocks.ImpulseClockRenderer;
import com.funkypandagame.stardust.view.stardust.common.clocks.SteadyClockRenderer;
import com.funkypandagame.stardust.view.stardust.twoD.initializers.PositionInitializer;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.SimPlayer;
import com.funkypandagame.stardustplayer.sequenceLoader.ISequenceLoader;
import com.funkypandagame.stardustplayer.sequenceLoader.SequenceLoader;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IInjector;

public class AppConfig implements IConfig
{
    [Inject]
    public var injector : IInjector;

    [Inject]
    public var eventCommandMap : IEventCommandMap;

    [Inject]
    public var mediatorMap : IMediatorMap;

    public function configure() : void
    {
        mediatorMap.map( StardusttoolMainView ).toMediator( StardusttoolMainViewMediator );
        mediatorMap.map( SteadyClockRenderer ).toMediator( SteadyClockRendererMediator );
        mediatorMap.map( BackgroundProvider ).toMediator( BackgroundProviderMediator );
        mediatorMap.map( ParticleHandlerContainer ).toMediator( ParticleHandlerContainerMediator );
        mediatorMap.map( EmittersUIView ).toMediator( EmittersUIViewMediator );
        mediatorMap.map( ImpulseClockRenderer ).toMediator( ImpulseClockRendererMediator );
        mediatorMap.map( PositionInitializer ).toMediator( PositionInitializerMediator );
        mediatorMap.map( ClockContainer ).toMediator( ClockContainerMediator );

        eventCommandMap.map( StartSimEvent.START ).toCommand( StartSimCommand );
        eventCommandMap.map( UpdateEmitterInfoTicksPerCallEvent.UPDATE ).toCommand( UpdateEmitterInfoTicksPerCallCommand );
        eventCommandMap.map( EmitterChangeEvent.ADD ).toCommand( AddEmitterCommand );
        eventCommandMap.map( EmitterChangeEvent.REMOVE ).toCommand( RemoveEmitterCommand );
        eventCommandMap.map( ChangeEmitterInFocusEvent.CHANGE ).toCommand( ChangeEmitterInFocusCommand );
        eventCommandMap.map( UpdateEmitterDropDownListEvent.UPDATE ).toCommand( UpdateEmitterDropDownListCommand );
        eventCommandMap.map( UpdateClockInEmitterGroupEvent.UPDATE ).toCommand( UpdateClockInEmitterGroupCommand );
        eventCommandMap.map( ImpulseClockRendererUpdateEmitterInfoEvent.UPDATE ).toCommand( ImpulseClockRendererUpdateEmitterInfoCommand );
        eventCommandMap.map( OnActionACChangeEvent.ADD ).toCommand( OnActionACAddCommand );
        eventCommandMap.map( OnActionACChangeEvent.REMOVE ).toCommand( OnActionACRemoveCommand );
        eventCommandMap.map( OnInitializerACChangeEvent.ADD ).toCommand( OnInitializerACAddCommand );
        eventCommandMap.map( OnInitializerACChangeEvent.REMOVE ).toCommand( OnInitializerACRemoveCommand );
        eventCommandMap.map( LoadEmitterImageFromFileEvent.TYPE ).toCommand( LoadEmitterImageFromFileReferenceCommand );
        eventCommandMap.map( SaveSimEvent.SAVE ).toCommand( SaveSimCommand );
        eventCommandMap.map( LoadSimEvent.LOAD ).toCommand( LoadSimCommand );
        eventCommandMap.map( FileLoadEvent.LOAD ).toCommand( FileLoadCommand );
        eventCommandMap.map( BackgroundChangeEvent.TYPE ).toCommand( ChangeBackgroundCommand );
        eventCommandMap.map( PositionInitializerEmitterPathEvent.LOAD ).toCommand( LoadEmitterPathCommand );
        eventCommandMap.map( UpdateClockValuesFromModelEvent.UPDATE ).toCommand( UpdateClockValuesFromModelCommand );
        eventCommandMap.map( ClockTypeChangeEvent.IMPULSE_CLOCK, ClockTypeChangeEvent ).toCommand( SetEmitterInFocusClockTypeToImpulseCommand );
        eventCommandMap.map( ClockTypeChangeEvent.STEADY_CLOCK, ClockTypeChangeEvent ).toCommand( SetEmitterInFocusClockTypeToSteadyCommand );
        eventCommandMap.map( InitializeZoneDrawerFromEmitterGroupEvent.INITIALIZE, InitializeZoneDrawerFromEmitterGroupEvent ).toCommand( InitializeZoneDrawerFromEmitterCommand );
        eventCommandMap.map( MainEnterFrameLoopEvent.ENTER_FRAME, MainEnterFrameLoopEvent ).toCommand( MainEnterFrameLoopCommand );
        eventCommandMap.map( SnapshotEvent.TYPE, SnapshotEvent ).toCommand( StoreParticleSnapshotCommand );
        eventCommandMap.map( RegenerateEmitterTexturesEvent.TYPE, RegenerateEmitterTexturesEvent ).toCommand( RegenerateEmitterTexturesCommand );
        eventCommandMap.map( CloneEmitterEvent.TYPE, CloneEmitterEvent ).toCommand( CloneEmitterCommand );

        injector.map( ProjectModel ).asSingleton();
        injector.map( ISequenceLoader ).toSingleton( SequenceLoader );
        injector.map( ISimLoader ).toSingleton( SimLoader );
        injector.map(SimPlayer).asSingleton();
    }

}
}

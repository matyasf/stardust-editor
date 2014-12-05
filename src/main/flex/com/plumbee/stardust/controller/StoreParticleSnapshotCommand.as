package com.plumbee.stardust.controller
{

import com.plumbee.stardust.controller.events.SnapshotEvent;
import com.plumbee.stardust.model.ProjectModel;
import com.plumbee.stardustplayer.Particle2DSnapshot;
import com.plumbee.stardustplayer.emitter.EmitterValueObject;

import flash.net.registerClassAlias;
import flash.utils.ByteArray;

import idv.cjcat.stardustextended.common.particles.Particle;

import idv.cjcat.stardustextended.twoD.particles.Particle2D;

public class StoreParticleSnapshotCommand
{

    [Inject]
    public var projectSettings : ProjectModel;

    [Inject]
    public var event : SnapshotEvent;

    public function execute() : void
    {
        if (event.takeSnapshot == false)
        {
            for each (var emVO : EmitterValueObject in projectSettings.stadustSim.emitters)
            {
                emVO.emitterSnapshot = null;
            }
        }
        else
        {
            registerClassAlias("idv.cjcat.stardustextended.twoD.particles.Particle2DSnapshot", Particle2DSnapshot);
            const particleData : Object = {};
            for each (var em : EmitterValueObject in projectSettings.stadustSim.emitters)
            {
                const allParticles : Array = [];
                const particles : Vector.<Particle> = em.emitter.particles;
                for (var i:int = 0; i < particles.length; i++)
                {
                    var snapshot : Particle2DSnapshot = new Particle2DSnapshot();
                    snapshot.storeParticle( Particle2D(particles[i]) );
                    allParticles.push(snapshot);
                }
                particleData[em.id] = allParticles;
                // serialize particle data
                var barr : ByteArray = new ByteArray();
                barr.writeObject(allParticles);
                em.emitterSnapshot = barr;
            }
        }
    }

}
}

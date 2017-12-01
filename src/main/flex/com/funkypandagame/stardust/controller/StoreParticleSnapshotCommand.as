package com.funkypandagame.stardust.controller
{

import com.funkypandagame.stardust.controller.events.SnapshotEvent;
import com.funkypandagame.stardust.model.ProjectModel;
import com.funkypandagame.stardustplayer.emitter.EmitterValueObject;

import stardustProtos.ParticleSnapshot;
import stardustProtos.ParticleSnapshots;

import flash.utils.ByteArray;

import idv.cjcat.stardustextended.particles.Particle;

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
            for each (var em : EmitterValueObject in projectSettings.stadustSim.emitters)
            {
                const allParticles : ParticleSnapshots = new ParticleSnapshots();
                const particles : Vector.<Particle> = em.emitter.particles;
                for (var i:int = 0; i < particles.length; i++)
                {
                    var snapshot : ParticleSnapshot = new ParticleSnapshot();
                    snapshot.x = particles[i].x;
                    snapshot.y = particles[i].y;
                    snapshot.vx = particles[i].vx;
                    snapshot.vy = particles[i].vy;
                    snapshot.rotation = particles[i].rotation;
                    snapshot.omega = particles[i].omega;
                    snapshot.initLife = particles[i].initLife;
                    snapshot.initScale = particles[i].initScale;
                    snapshot.initAlpha = particles[i].initAlpha;
                    snapshot.life = particles[i].life;
                    snapshot.scale = particles[i].scale;
                    snapshot.alpha = particles[i].alpha;
                    snapshot.mass = particles[i].mass;
                    snapshot.isDead = particles[i].isDead;
                    snapshot.colorR = particles[i].colorR;
                    snapshot.colorG = particles[i].colorG;
                    snapshot.colorB = particles[i].colorB;
                    snapshot.currentAnimationFrame = particles[i].currentAnimationFrame;
                    allParticles.particles.push(snapshot);
                }
                // serialize particle data
                var barr : ByteArray = new ByteArray();
                allParticles.writeTo(barr);
                em.emitterSnapshot = barr;
            }
        }
    }

}
}

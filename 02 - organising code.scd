// -----------------------------------------------
// Organising code
// -----------------------------------------------


// Let's translate previous example into reusable Synth Definition i.e. SynthDef
(
{
	Mix.fill(15,
		{
			Pan2.ar(
				DynKlank.ar(`[
					Array.exprand(12, 30.0, 14000.0),         // frequencies
					nil,                             // amplitudes (default to 1.0)
					Array.rand(12, 0.1, 2)                // ring times
				],
				Decay.ar(Dust.ar(2), 0.03, ClipNoise.ar(0.01)) // exciter signal
				),
				rrand(-1,1.0)
			)
		}
	)
}.play
)

// SynthDef version of the convenience .play sketch method above
// we need to add envelope to be able to turn the sound on and off
// ADSR envelope: https://blog.landr.com/wp-content/uploads/2016/10/ASDR-01.jpg

(
SynthDef(\wind_chime, {
	arg out=0, gate=1, trig_freq = 2;
	var exciter, sound, envelope;

	envelope = EnvGen.kr(Env.asr(), gate, doneAction: 2);
	exciter = Decay.ar(Dust.ar(trig_freq), 0.03, ClipNoise.ar(0.01));

	sound = DynKlank.ar(`[
		Array.fill(12, {Rand(30,15000)}),         // frequencies - notice the use of UGen
		nil,                             // amplitudes (default to 1.0)
		Array.fill(12, {Rand(0.1,2.0)})               // ring times
	],
	exciter);

	sound = Pan2.ar(sound, rrand(-1.0,1.0)) * envelope;

	Out.ar(out, sound);

}).add
)

// Now this allows us to create as many of these as we want

a = Synth(\wind_chime);
b = Synth(\wind_chime);
c = Synth(\wind_chime);

a.free;
b.free;
c.free;


a.set(\gate, 0);
b.set(\gate, 0);
c.set(\gate, 0);

a.set(\trig_freq, 10);

// Now we can spawn these synths using Pbind method from the Patterns library
(
Pbind(
	\instrument, \wind_chime,
	\dur, 3.0,
).play
)




// -----------------------------------------------
// let's boot strap - sequence a base line
// -----------------------------------------------

(
SynthDef(\saw_texture, {
	arg out = 0, gate = 1, freq = 440;

	var sound, env;

	env = EnvGen.ar(Env.asr(),gate, doneAction:2);
	sound = Saw.ar(freq, 0.1);

	// sound = Mix.new(Saw.ar([freq*0.999, freq, freq*1.001], 0.1));

	Out.ar(out, sound * env!2);
}).add
)

a = Synth(\saw_texture)
a.set(\freq, 40)



TempoClock.default.tempo = 1;

(
Pbind(
	\instrument, \saw_texture,
	\freq, Pseq([40, 45, 55], inf),
	\dur, Pseq([0.5,0.5, 0.3],inf)
).play
)



//
// 10-minute excercise - make your own bass line
//
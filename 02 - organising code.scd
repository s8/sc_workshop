// Organising code


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

(
SynthDef(\wind_chime, {
	arg out=0;
	var exciter, sound;

	exciter = Decay.ar(Dust.ar(2), 0.03, ClipNoise.ar(0.01));

	sound = DynKlank.ar(`[
		Array.fill(12, {Rand(30,15000)}),         // frequencies - notice the use of UGen
		nil,                             // amplitudes (default to 1.0)
		Array.fill(12, {Rand(0.1,2.0)})               // ring times
	],
	exciter);

	sound = Pan2.ar(sound, rrand(-1.0,1.0));

	Out.ar(out, sound);

}).add
)

// Now this allows us to create as many of these as we want

a = Synth(\wind_chime);
b = Synth(\wind_chime);
c = Synth(\wind_chime);
d = Synth(\wind_chime);
e = Synth(\wind_chime);
f = Synth(\wind_chime);

a.free;
b.free;
c.free;
d.free;
e.free;
f.free;

// Now we can spawn these synths using Pbind method from the Patterns library
(
Pbind(
	\instrument, \wind_chime,
	\dur, 3.0,
).play
)

// but they're not going away. To free them we'll need to add an envelope and "gate" argument


(
SynthDef(\wind_chime, {
	arg out=0, gate = 1;
	var exciter, sound, env;

	env = EnvGen.kr(Env.new(), gate, doneAction: 2);

	exciter = Decay.ar(Dust.ar(2), 0.03, ClipNoise.ar(0.01));

	sound = DynKlank.ar(`[
		Array.fill(12, {Rand(30,15000)}),         // frequencies - notice the use of UGen
		nil,                             // amplitudes (default to 1.0)
		Array.fill(12, {Rand(0.1,2.0)})               // ring times
	],
	exciter);

	sound = Pan2.ar(sound, rrand(-1.0,1.0));
	sound = sound * env;

	Out.ar(out, sound);

}).add
)

// prerequisites:
// mutable instruments UGEns: https://github.com/v7b1/mi-UGens/releases
// put them into: ~/Library/Application\ Support/SuperCollider/Extensions/SC3plugins/


//
// sound part
//

(
SynthDef(\eno_otey, {
	|out=0, freq=440,gate=1, amp=0.5,rho=0.75, hpos=0.8, loss=0.01, detune=0.5|

	var son = OteyPianoStrings.ar(freq, amp, rho:rho, hpos:hpos, loss:loss, detune:detune)*
	// EnvGen.ar(Env.asr(0,1,0.1),gate,doneAction:2);
	EnvGen.ar(Env.new([0,1,0],[0.01,15.0],'lin'),gate, doneAction:2);

	Out.ar(
		// out,
		[20,21],
		Pan2.ar(
			son * 1,
			LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75))
	);
}).add;
);


(
SynthDef(\piano_soundboard,{
	var audio = In.ar([20, 21], 2);

	audio = OteySoundBoard.ar(audio);

	audio = MiVerb.ar(audio, 0.08, 0.5, 0.3, 0);

	Out.ar(0,audio);
}).add
);


//start soundboard effect
Synth.tail(1,\piano_soundboard);


//
// composition part
//



(
a = Pbind(
	\instrument, \eno_otey,
	\note, Pseq([12], inf),
	\dur, Pseq([17.1],inf)
));


(
b = Pbind(
	\instrument, \eno_otey,
	\note, Pseq([20, 17, 8], inf),
	\dur,	Pseq([1,1.1,23], inf)
));


(
c = Pbind(
	\instrument, \eno_otey,
	\note, Pseq([8,5,7,5], inf)
	\dur, Pseq([1,1,1,24.5], inf);
));


(
d = Pbind(
	\instrument, \eno_otey,
	\note, Pseq([10], inf),
	\dur, Pseq([31.1], inf);
));


(
e = Pbind(
	\instrument, \eno_otey,
	\note, Pseq([0,8,7,5], inf),
	\dur, Pseq([0.5,1,1,31.1], inf)
));




(
Pdef(\b,
	Pbind(
		\instrument, \eno_otey,
		\note, Pseq([20, 17, 8], inf))
);
Pdef(\b).quant = 0; // no waiting.
Pbindf(Pdef(\b), \dur, Pseq([1,1.1,23], inf)).play;
);


(
Pdef(\c,
	Pbind(
		\instrument, \eno_otey,
		\note, Pseq([8,5,7,5], inf))
);
Pdef(\c).quant = 0; // no waiting.
Pbindf(Pdef(\c), \dur, Pseq([1,1,1,24.5], inf)).play;
);


(
Pdef(\d,
	Pbind(
		\instrument, \eno_otey,
		\note, Pseq([10], inf))
);
Pdef(\d).quant = 0; // no waiting.
Pbindf(Pdef(\d), \dur, Pseq([31.1], inf)).play;
);


(
Pdef(\e,
	Pbind(
		\instrument, \eno_otey,
		\note, Pseq([0,8,7,5], inf))
);
Pdef(\e).quant = 0; // no waiting.
Pbindf(Pdef(\e), \dur, Pseq([0.5,1,1,31.1], inf)).play;
);








Pdef(\b, Pbind(\note, Pseq([-1], inf)));
Pdef(\b).quant = 0; // no waiting.
Pbindf(Pdef(\b), \dur, Pseq([23.2], inf)).play;


Pdef(\b, Pbind(\note, Pseq([-1], inf)));
Pdef(\b).quant = 0; // no waiting.
Pbindf(Pdef(\b), \dur, Pseq([23.2], inf)).play;


Pdef(\b, Pbind(\note, Pseq([-1], inf)));
Pdef(\b).quant = 0; // no waiting.
Pbindf(Pdef(\b), \dur, Pseq([23.2], inf)).play;


Pdef(\b, Pbind(\note, Pseq([-1], inf)));
Pdef(\b).quant = 0; // no waiting.
Pbindf(Pdef(\b), \dur, Pseq([23.2], inf)).play;


Pdef(\b, Pbind(\note, Pseq([-1], inf)));
Pdef(\b).quant = 0; // no waiting.
Pbindf(Pdef(\b), \dur, Pseq([23.2], inf)).play;



Pdef(\y, Pbind(\note, Pbrown(0, 6, 0.1, inf)));
Pdef(\y).quant = 0; // no waiting.
Pbindf(Pdef(\y), \dur, 2.23).play;



Pdef(\z, Pbind(\note, Pbrown(0, 6, 0.1, inf)));
Pdef(\z).quant = 0; // no waiting.
Pbindf(Pdef(\z), \dur, 3.23).play;
// prerequisites:
// mutable instruments UGEns: https://github.com/v7b1/mi-UGens/releases
// put them into: ~/Library/Application\ Support/SuperCollider/Extensions/SC3plugins/


//
// sound part
//

(
SynthDef(\eno_otey, {
	|out=0, freq=440,gate=1, amp=0.5,rho=0.7, hpos=0.8, loss=0.01, detune=0.5|

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
	\note, Pseq([8,5,7,5], inf),
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
f = Pbind(
	\instrument, \eno_otey,
	\note, Pseq([8, 12, 15,17], inf),
	\dur, Pseq([0.1,0.1,0.1,28], inf)
));

a.play;
b.play;
c.play;
d.play;
e.play;
f.play;
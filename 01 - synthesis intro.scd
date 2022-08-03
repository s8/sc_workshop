/*------------------------------------------------------------------

SuperCollider is (nearly) as vast as the world of music itself

the ways to create, control, manipulat, analyse sound are almost endless

as are the ways to structure composition for real-time performance or "tape" pieces


In this 2-hour we'll aim to

* cover basic syntax and core concepts that will help you navigate documentation and examples by yourself

* introduce most popular sound synthesis techniques

* apply this knowledge to create our own mini-compositions

------------------------------------------------------------------*/


// -----------------------------------------------
// basic shortcuts and commands
// -----------------------------------------------
// cmd + b - boot the server
// bottom right text should light up green
// interpreter: active
// server stats running

// shift + enter - on the line to execute it
// cmd + enter - to execute code within round brackets
// cmd + . - to stop the sound


// -----------------------------------------------
// Let's get into it
// -----------------------------------------------

// Immediate sound
{SinOsc.ar*0.1}.play

// now with both channels
{SinOsc.ar!2 * 0.1}.play

// Now with frequency control
{SinOsc.ar(MouseX.kr(30,3000))!2 * 0.1}.play

// Now let's see it
// and move amplitude into the "mul" argument
{SinOsc.ar(MouseX.kr(30, 3000), 0.0, 0.1) !2}.scope

// Now let's see it in frequency domain
{SinOsc.ar(MouseX.kr(30, 3000),0.0, 0.1) !2}.freqscope



// -----------------------------------------------
// scopes
// -----------------------------------------------
// cmd-shift-m - scope
// cmd-alt-m - freqscope
// keep both of them open all the time



//
// 1-minute excercise - play with plugging your numbers or UGens into freq arg
//


// -----------------------------------------------
// Modulation - nesting UGens
// -----------------------------------------------
// AM / Tremolo - amplitude modulation
// -----------------------------------------------

{SinOsc.ar(440, 0.0, SinOsc.ar(3, 0.0, 0.05, 0.1))!2}.play


// AM / Tremolo - now with mouse control
{SinOsc.ar(440, 0.0, SinOsc.ar(MouseX.kr(0.1,10000,1), 0.0, 0.05, 0.1))!2}.play


// !! notice the formation of new harmonics when modulator enters audible range

// -----------------------------------------------
// FM / Vibrato - frequency modulation
// -----------------------------------------------

// still same clean sine wave
// consider what "mul" and "add" arguments represent in this case
{SinOsc.ar(SinOsc.ar(0,0,0,440), 0.0, 0.1)!2}.play

// gentle tremolo, 20Hz wide at 8Hz
{SinOsc.ar(SinOsc.ar(1,0,10,440), 0.0, 0.1)!2}.play

// not-so gentle tremolo, 880hz wide at 3Hz
{SinOsc.ar(SinOsc.ar(3,0,440,440), 0.0, 0.1)!2}.play

// getting modulator into audio range yields rich harmonic structure
// try swapping freq scope into linear rather than logarithmic mode
{SinOsc.ar(SinOsc.ar(300,0,220,440), 0.0, 0.1)!2}.play


// modulating phase instead of frequency - yields the same effect, but the arguments need to be slighly adjusted
{SinOsc.ar(440, SinOsc.ar(MouseX.kr(1,1000,1),0, pi/4,0.5), 0.1)!2}.play

//
// 1- minute exercise - try plugging MouseX.kr into modulator frequency and amplitude
//


// PMOsc - dedicated phase modulation oscillator pair
({ PMOsc.ar(MouseX.kr(300,900,1), 600, 3, 0, 0.1) }).play; // modulate carfreq

// FM7 - implementation of Yamaha DX7 synthesiser
(
{

	// freq, phase, amp
/*	var ctls = [
		[ 300, 0,    1   ],
		[ 400, pi/2, 1   ],
		[ 730, 0,    0.5 ],
		[ 0,   0,    0   ],
		[ 0,   0,    0   ],
		[ 0,   0,    0   ] ];*/
	var ctls = [
	[LFNoise1.kr(0.5).range(300, 310), 0, 1],
	[LFNoise1.kr(0.5).exprange(3, 310), 0, 1],
	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1],
	[LFNoise1.kr(0.5).exprange(3, 100), 0, 1]
	];
	Mix.ar(FM7.arAlgo(1, ctls, MouseX.kr(0, 2)))*0.1!2;
	// Mix.ar(FM7.arAlgo(19, ctls, MouseX.kr(0, 2)))!2;
	// Mix.ar(FM7.arAlgo(23, ctls, MouseX.kr(0, 2)))!2;
}.play

)


// -----------------------------------------------
// Mixing and multichannel expansion
// -----------------------------------------------

// Binaural beats
(
{[
	SinOsc.ar(300,0.0,0.5),
	SinOsc.ar(310,0.0,0.5)
]}.play
)


// same thing but with multichannel expansion
// whenever in place of a single argument you provide an array - SC automatically creates new audio channels
{SinOsc.ar([300,310])*0.5}.play

//
// 1-minute exercise - try controlling the frequency of one of the SinOsc UGens with MouseX
//


// let's mix them in the same channel
{Mix.ar(SinOsc.ar([300,310])*0.1)!2}.play

// let's add more frequencies
{Mix.ar(SinOsc.ar([300,310,320,330.1])*0.1)!2}.play

// let's make some noise - generate hundreds of sine waves
// what is that click?
{Mix.ar(FSinOsc.ar(Array.rand(100,30,12000),0.0,0.01)*0.1)!2}.play

// click is gone - spot the difference in code
{Mix.ar(FSinOsc.ar(Array.rand(100,30.0,12000),0.0,0.01)*0.1)!2}.play


// now in stereo
(
{[
	Mix.ar(FSinOsc.ar(Array.exprand(100,30,12000),0.0,0.01)*0.5),
	Mix.ar(FSinOsc.ar(Array.exprand(100,30,12000),0.0,0.01)*0.5)
]}.play
)



// now let's unpack and restructure this so we can have individual pan for each SinOsc
// panning each sinewave around using slow-moving noise generator yields a dynmic immersive texture
(
{
	Mix.fill(300,
		{
			Pan2.ar(
				SinOsc.ar(
					exprand(30,22000),
					0.0,
					rrand(0.001,0.05)
				),
				LFNoise2.ar(rrand(0.1,20))
				// rrand(-1.0,1.0)
			)
		}
	)*0.25
}.scope
)

// -----------------------------------------------
// Additive synthesis
// -----------------------------------------------

// now let's give our sine waves a harmonic structure
// by adding 300 sine waves we get a triangluar wave
// look at the CPU usage
// theoretically you could use additive to create any desired sound, but it's very inefficient
(
{
	Mix.ar(
		Array.fill(
			300,
			{ |i| // loop counter
				Pan2.ar(
					SinOsc.ar(
						(i+1) * 50,
						0.0,
						0.5/(i+1)
					),
					0
				)
			}
		)
	)*0.1
}.scope
)


// there's an easier way to get the same waveshape
// look at the CPU usage now

{Saw.ar(50,0.1)!2}.play



// -----------------------------------------------
// Subtractive synthesis
// -----------------------------------------------


// resonant low-pass filter
{RLPF.ar(Saw.ar(50,0.75),MouseX.kr(50,15000,1),MouseY.kr(0.01,1))!2}.play

// moog filters models

{MoogVCF.ar(Saw.ar(50,0.75),MouseX.kr(50,15000,1),MouseY.kr(0.01,1))!2}.play
{MoogLadder.ar(Saw.ar(50,1),MouseX.kr(50,15000,1),MouseY.kr(0.01,1))!2}.play


// -----------------------------------------------
// Modal synthesis
// -----------------------------------------------

// feeding pulse bursts into banks of filters to emulate physical systems


// noise bursts
{Decay.ar(Impulse.ar(2) + Dust.ar(2), 0.03, PinkNoise.ar(0.1))}.play


// let's feed them through the filter
(
{
	Mix.fill(5,
		{
			Pan2.ar(
				Klank.ar(`[
					Array.rand(12, 30.0, 14000.0),         // frequencies
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




// -----------------------------------------------
// Granular synthesis
// -----------------------------------------------

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
{PlayBuf.ar(1, b)}.play


// basic granulation pitch shifter
{TGrains.ar(2, Impulse.ar(100),b,MouseY.kr(0.5,3,1),MouseX.kr(0,BufDur.kr(b)), 0.1, 0)}.play


// adding Dust to Impulse gives a bit more organic texture
{TGrains.ar(2, Impulse.ar(50)+ Dust.ar(50),b,MouseY.kr(0.5,3,1),MouseX.kr(0,BufDur.kr(b)), 0.1, 0)}.play


// create several channels of granulator for a cloud-like texture
(
{
	Mix.new(
		Array.fill(5,
			{
				TGrains.ar(
					2, // num channels
					Dust.ar(rrand(5.0,50)), // triggers
					b, // buffer
					LFNoise0.ar(rrand(0.5,2.0),0.25,1), // rate
					LFNoise0.ar(rrand(0.1,10), BufDur.kr(b), BufDur.kr(b)/2), // centerPos
					LFNoise0.ar(rrand(0.1,0.25), 0.1,0.11), // dur
					LFNoise0.ar(rrand(0.1,10)), // pan
					0.1,
					4
				)
			}
		)
	)
}.play
)

//
(
{
	var trate, dur, rate;
	trate = MouseY.kr(2,200,1);
	dur = 4 / trate;
	rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
	TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4);
)





Ndef(\tgrains_test).play
Ndef(\tgrains_test).fadeTime = 2.0;



(
Ndef(\tgrains_test,
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(0.2,500,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}
)
)

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");



(
Ndef(\tgrains_test,
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(0.2,500,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}
)
)

Quarks.gui


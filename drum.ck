
OscParamSend oscSend;
oscSend.initPort(TP.OSC_PORT);

spork ~ oscSend.sendFloatShred("drumGain");

Score.hhDrumBeats @=> ParamIntPatterns hhBeats;
spork ~ oscSend.sendIntShred("hhBeat");
spork ~ oscSend.m_params.bindIntShred("hhBeat", hhBeats.m_params, "value");
hhBeats.play(100, .2);

Score.tomDrumBeats @=> ParamIntPatterns tomBeats;
spork ~ oscSend.sendIntShred("tomBeat");
spork ~ oscSend.m_params.bindIntShred("tomBeat", tomBeats.m_params, "value");
tomBeats.play(100, .2);

Score.cowbellDrumBeats @=> ParamIntPatterns cbBeats;
spork ~ oscSend.sendIntShred("cbBeat");
spork ~ oscSend.m_params.bindIntShred("cbBeat", cbBeats.m_params, "value");
cbBeats.play(100, .2);



SampleSet ss;
[["data/closehat.wav",
  "data/closehat.wav",
  "data/closehat.wav",
  "data/closehat.wav",
  "data/closehat.wav",
  "data/closehat.wav",
  "data/closehat.wav",
  "data/closehatac.wav",
  "data/cymbal.wav"],
 ["data/lowtom.wav",
  "data/lowtom.wav",
  "data/lowtom.wav",
  "data/lowtom.wav",
  "data/lowtomac.wav",
  "data/hightom.wav"],
 ["data/snare2.wav",
 // "data/snareac.wav",
  "data/cowbell.wav",
  "data/snare-chili.wav",
  "data/snare-hop.wav"]
] @=> ss.m_files;





// osc beat slave
OscParamRecv oscRecv;
oscRecv.initPort(TP.OSC_PORT);

oscRecv.listenForInt("drumGain");
spork ~ ss.m_params.bindFloatShred("gain", oscRecv.m_params, "drumGain");

oscRecv.listenForInt("hhBeat");
spork ~ ss.m_params.bindIntShred("hh", oscRecv.m_params, "hhBeat");
ss.playSample(0, "hh");

oscRecv.listenForInt("tomBeat");
spork ~ ss.m_params.bindIntShred("tom", oscRecv.m_params, "tomBeat");
ss.playSample(1, "tom");

oscRecv.listenForInt("cbBeat");
spork ~ ss.m_params.bindIntShred("cb", oscRecv.m_params, "cbBeat");
ss.playSample(2, "cb");

/*
spork ~ ss.m_params.bindIntShred("hh", oscRecv.m_params, "hhBeat");
spork ~ ss.m_params.logIntShred("hh");
ss.playSample(0, "h");
*/


//
//  TrackPads


TrackPad.getTPs() @=> TrackPad @ tps[];

for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;

    if (i == 0)
    {
        spork ~ ss.m_params.bindFloatShred("gain", tp.m_params, "pinch_distance");
    }
    if (i == 1)
    {
        spork ~ oscSend.m_params.bindFloatShred("drumGain", tp.m_params, "y");

        spork ~ hhBeats.m_params.bindIntToFloatShred("patternIndex", tp.m_params, "x");
        spork ~ tomBeats.m_params.bindIntToFloatShred("patternIndex", tp.m_params, "x");
        spork ~ cbBeats.m_params.bindIntToFloatShred("patternIndex", tp.m_params, "x");
    }
}


// 24h
1::day => now;

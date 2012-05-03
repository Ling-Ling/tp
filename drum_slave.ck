

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


// osc slave
OscParamRecv oscRecv;
oscRecv.initPort(TP.OSC_PORT);

oscRecv.listenForInt("drumGain");
spork ~ ss.m_params.bindFloatShred("masterGain", oscRecv.m_params, "drumGain");

oscRecv.listenForInt("hhBeat");
spork ~ ss.m_params.bindIntShred("hh", oscRecv.m_params, "hhBeat");
ss.playSample(0, "hh");

oscRecv.listenForInt("tomBeat");
spork ~ ss.m_params.bindIntShred("tom", oscRecv.m_params, "tomBeat");
ss.playSample(1, "tom");

oscRecv.listenForInt("cbBeat");
spork ~ ss.m_params.bindIntShred("cb", oscRecv.m_params, "cbBeat");
ss.playSample(2, "cb");


// trackpads
TrackPad.getTPs() @=> TrackPad @ tps[];
for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;

    if (i == 0)
    {
        spork ~ ss.m_params.bindFloatShred("gain", tp.m_params, "pinch_distance");
    }
}


// 24h
1::day => now;

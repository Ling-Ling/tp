//
//  master.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

// trackpads
TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);


//
//  Pinch master
//

// mode progression
[
 XD.MODE("major"),
 XD.MODE("minor"),
 XD.MODE("minor"),
 XD.MODE("major"),
 XD.MODE("major"),
 XD.MODE("major"),
 XD.MODE("minor"),
 XD.MODE("dim"),
 XD.MODE("major")
]
@=> int modeProgression[];

// note progresssion
[
 XD.KEY("c"),
 XD.KEY("e"),
 XD.KEY("a"),
 XD.KEY("g"),
 XD.KEY("c"),
 XD.KEY("f"),
 XD.KEY("d"),
 XD.KEY("b"),
 XD.KEY("c")
] 
@=> int noteProgression[];

// osc pincher frequency patterns master
OscFreqSend oscFreqSend;
oscFreqSend.initPort(OSC_PORT);
oscFreqSend.m_modePattern.init(modeProgression);
oscFreqSend.m_notePattern.init(noteProgression);
spork ~ oscFreqSend.freqLoopShred(10);

// map TrackPad x to Pincher pattern indices
spork ~ oscFreqSend.m_notePattern.m_params.bindIntToFloatShred("index", tps[1].m_params, "x");
spork ~ oscFreqSend.m_modePattern.m_params.bindIntToFloatShred("index", tps[1].m_params, "x");

// map TrackPad y to osc gain master
spork ~ oscFreqSend.sendFloatShred("pinchGain");
spork ~ oscFreqSend.m_params.bindFloatShred("pinchGain",tps[0].m_params,"y");


//
//  Beat Master 
//

// osc beat master
OscBeatSend oscBeatSend;
oscBeatSend.initPort(OSC_PORT);
spork ~ oscBeatSend.beatLoopShred();



OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);
oscRecv.listenForInt("freq0");
oscRecv.listenForInt("beatNum");

DrumPad dp;

[ 
 [1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 0, 0],

 [1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 
  1, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 1, 0, 0],

 [1, 0, 0, 0, 0, 0, 0, 0, 
  1, 0, 0, 0, 0, 0, 0, 0, 
  1, 0, 0, 0, 0, 0, 0, 0, 
  1, 0, 0, 0, 0, 1, 0, 0],

 [1, 0, 0, 0, 1, 0, 0, 0, 
  1, 0, 0, 0, 1, 0, 0, 0, 
  1, 0, 0, 0, 1, 0, 0, 0, 
  1, 0, 0, 0, 1, 0, 1, 0],

 [1, 0, 1, 0, 1, 0, 0, 0, 
  1, 0, 0, 0, 1, 0, 1, 0, 
  1, 0, 1, 0, 1, 0, 0, 0, 
  1, 0, 0, 0, 1, 0, 1, 1],

 [1, 0, 1, 0, 1, 0, 1, 0,
  1, 0, 1, 0, 1, 0, 1, 0,
  1, 0, 1, 0, 1, 0, 1, 0,
  0, 1, 0, 1, 0, 1, 1, 1]

] @=> dp.m_patterns;

["data/closehat.wav"] @=> dp.m_files;
["data/hihat-open.wav"] @=> dp.m_mixFiles;


spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");

dp.m_params.setFloatRange("openness", 0, .5);
spork ~ dp.m_params.bindFloatShred("openness", tps[2].m_params, "y");

dp.m_params.setIntRange("pattern", 0, dp.m_patterns.size());
spork ~ dp.m_params.bindIntToFloatShred("pattern", tps[2].m_params, "x");


//
// wub
//

Mouse.initMice(2) @=> Mouse @ mice[];

Wub wub;

spork ~ wub.m_params.bindIntShred("play", mice[1].m_params, "mouse_click");

spork ~ wub.m_params.bindIntShred("midiNote", oscRecv.m_params, "freq0");


// 24h
1::day => now;

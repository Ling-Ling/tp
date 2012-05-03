//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

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

// trackpads
TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

// osc pincher frequencies master
OscFreqSend oscFreqSend;
oscFreqSend.initPort(OSC_PORT);
oscFreqSend.m_modePattern.init(modeProgression);
oscFreqSend.m_notePattern.init(noteProgression);
spork ~ oscFreqSend.freqLoopShred(10);

// map TrackPad x to Pincher pattern indices
spork ~ oscFreqSend.m_notePattern.m_params.bindIntToFloatShred("index", tps[0].m_params, "x");
spork ~ oscFreqSend.m_modePattern.m_params.bindIntToFloatShred("index", tps[0].m_params, "x");

// map TrackPad y to master gain
spork ~ oscFreqSend.sendFloatShred("gain");
spork ~ oscFreqSend.m_params.bindFloatShred("gain",tps[0].m_params,"y");

/*
// osc beat master
OscBeatSend oscBeatSend;
oscBeatSend.initPort(OSC_PORT);
// send beat 
spork ~ oscBeatSend.beatLoopShred();
*/

// 24h
1::day => now;

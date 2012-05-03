//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);


OscBeatSend oscBeatSend;
oscBeatSend.initPort(OSC_PORT);
// send beat 
spork ~ oscBeatSend.beatLoopShred();



OscFreqSend oscFreqSend;
oscFreqSend.initPort(OSC_PORT);

// send Pincher frequencies
spork ~ oscFreqSend.freqLoopShred(10);

// map TrackPad x to Pincher pattern indices
spork ~ oscFreqSend.m_notePattern.m_params.bindIntToFloatShred("index", tps[0].m_params, "x");
spork ~ oscFreqSend.m_modePattern.m_params.bindIntToFloatShred("index", tps[0].m_params, "x");

// map TrackPad y to master gain
spork ~ oscFreqSend.sendFloatShred("gain");
spork ~ oscFreqSend.m_params.bindFloatShred("gain",tps[0].m_params,"y");
spork ~ oscFreqSend.m_params.logFloatShred("gain");


// 24h
1::day => now;

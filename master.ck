//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

//Mouse @ mice[tps.size()];
//Mouse.initMice(mice);


//
//  OSC master
//

OscBeatSend oscBeatSend;
oscBeatSend.initPort(OSC_PORT);
// send beat 
spork ~ oscBeatSend.beatLoopShred();

OscFreqSend oscFreqSend;
oscFreqSend.initPort(OSC_PORT);
// send freq
spork ~ oscFreqSend.freqLoopShred();

OscParamSend oscGainSend;
oscGainSend.initPort(OSC_PORT);

//master gain control
spork ~ oscGainSend.sendFloatShred("gain");
spork ~ oscGainSend.m_params.bindFloatShred("gain",tps[0].m_params,"y");
spork ~ oscGainSend.m_params.logFloatShred("gain");


// 24h
1::day => now;

//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);



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

/*
OscGainSend oscGainSend;
oscGainSend.initPort(OSC_PORT);
// send freq
spork ~ oscGainSend.gainLoopShred();

spork ~ oscGainSend.m_params.logFloatShred("gain");
*/

// 24h
1::day => now;

//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

Mouse @ mice[tps.size()];
Mouse.initMice(mice);


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


//
//  OSC slave
//

OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);

// receive beat
oscRecv.listenForInt("beatNum");
oscRecv.m_params.setIntRange("beatNum", 0, 8);

//receive freqs
oscRecv.listenForInt("freq1");
oscRecv.listenForInt("freq2");


//
//  drums
//

DrumPad dp;

spork ~ dp.m_params.bindIntShred("hit", mice[1].m_params, "mouse_click");
//mice[1].m_params.getNewIntEvent("mouse_click") @=> dp.m_hitEvent;

spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");

spork ~ dp.m_params.bindFloatShred("openness", tps[0].m_params, "y");


//
//  pinchers
//

PincherPad pp;
PincherPad pp2;
spork ~ pp.m_params.bindFloatShred("distance", tps[0].m_params, "pinch_distance");

spork ~ pp.m_params.bindIntShred("freq1", oscRecv.m_params, "freq1");
spork ~ pp.m_params.logIntShred("freq");


// 24h
1::day => now;

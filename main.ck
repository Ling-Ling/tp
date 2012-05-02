//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


//
//  trackpads 
//

TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);


// 
//  osc 
//

8000 => int OSC_PORT;


// master:

OscBeatSend oscBeatSend;
oscBeatSend.initPort(OSC_PORT);

// send beat 
spork ~ oscBeatSend.beatLoopShred();


// slave:

OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);

// receive beat
oscRecv.listenForInt("beatNum");
//spork ~ oscRecv.m_params.logIntShred("beatNum");


//
//  drums
//

DrumPad dp;


spork ~ dp.m_params.bindIntShred("hit", tps[0].m_params, "mouse_click");
spork ~ dp.m_params.logIntShred("hit");


spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");
spork ~ dp.m_params.logIntShred("beatNum");

spork ~ dp.m_params.bindFloatShred("openness", tps[0].m_params, "y");
spork ~ dp.m_params.logFloatShred("openness");



// 24h
1::day => now;

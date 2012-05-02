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

Mouse @ mice[TrackPad.MAX_NUM_TRACKPADS];
Mouse.initMice(mice);



// 
//  osc 
//

8000 => int OSC_PORT;


// master:

//OscBeatSend oscBeatSend;
//oscBeatSend.initPort(OSC_PORT);

OscFreqSend oscFreqSend;
oscFreqSend.initPort(OSC_PORT);

// send beat 
//spork ~ oscBeatSend.beatLoopShred();
// send freq
spork ~ oscFreqSend.freqLoopShred();



// slave:

OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);

// receive beat
oscRecv.listenForInt("beatNum");
oscRecv.m_params.setIntRange("beatNum", 0, 8);
//oscRecv.listenForInt("beatNum");

//receive freqs
oscRecv.listenForInt("freq1");
oscRecv.listenForInt("freq2");


//spork ~ oscRecv.m_params.logIntShred("beatNum");



Parameters params;

/*
// Example of binding float to int
params.setInt("index", 0);
params.setIntRange("index", 0, 12);

spork ~ params.bindIntToFloatShred("index", tps[0].m_params, "x");
spork ~ params.logIntShred("index");
*/


//
//  drums
//

DrumPad dp;
PincherPad pp;
PincherPad pp2;



//spork ~ dp.m_params.bindIntShred("hit", mouse[0].m_params, "mouse_click");
spork ~ mice[0].m_params.logIntShred("mouse_click");


spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");
spork ~ dp.m_params.logIntShred("beatNum");

spork ~ dp.m_params.bindFloatShred("openness", tps[0].m_params, "y");
spork ~ dp.m_params.logFloatShred("openness");

spork ~ dp.m_params.bindIntShred("hit", tps[0].m_params, "mouse_click");

spork ~ pp.m_params.bindFloatShred("distance", tps[0].m_params, "pinch_distance");
spork ~ pp.m_params.logFloatShred("distance");

spork ~ pp.m_params.bindIntShred("freq1", oscRecv.m_params, "freq1");
spork ~ pp.m_params.logIntShred("freq");

dp.m_params.setIntRange("beatNum", 0, 8);
spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");

dp.m_params.getNewIntEvent("beatNum") @=> dp.m_beatEvent;


spork ~ dp.m_params.logIntShred("beatNum");

params.setIntRange("test1", 0, 100);
spork ~ params.bindIntShred("test1", dp.m_params, "beatNum");
spork ~ params.logIntShred("test1");

spork ~ params.bindFloatToIntShred("test2", dp.m_params, "beatNum");
spork ~ params.logFloatShred("test2");

dp.m_params.setFloatRange("openness", 0, .5);

spork ~ dp.m_params.bindFloatShred("openness", tps[0].m_params, "y");
spork ~ pp2.m_params.bindFloatShred("distance", tps[1].m_params, "pinch_distance");
spork ~ pp2.m_params.logFloatShred("distance");

spork ~ pp2.m_params.bindIntShred("freq2", oscRecv.m_params, "freq2");
spork ~ pp2.m_params.logIntShred("freq");



// 24h
1::day => now;

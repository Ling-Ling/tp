//
//  pinch.ck
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
//  OSC slave
//

OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);

//trackpad 1
oscRecv.listenForInt("freq1");
PincherPad pp;
spork ~ pp.m_params.bindFloatShred("distance", tps[1].m_params, "pinch_distance");
spork ~ pp.m_params.bindIntShred("freq", oscRecv.m_params, "freq1");
spork ~ pp.m_params.logIntShred("freq");

//trackpad 2
oscRecv.listenForInt("freq2");
PincherPad pp2;
spork ~ pp2.m_params.bindFloatShred("distance", tps[2].m_params, "pinch_distance");
spork ~ pp2.m_params.bindIntShred("freq", oscRecv.m_params, "freq2");
spork ~ pp2.m_params.logIntShred("freq");

//trackpad 3
oscRecv.listenForInt("freq3");
PincherPad pp3;
spork ~ pp3.m_params.bindFloatShred("distance", tps[3].m_params, "pinch_distance");
spork ~ pp3.m_params.bindIntShred("freq", oscRecv.m_params, "freq3");
spork ~ pp3.m_params.logIntShred("freq");

//trackpad 4
oscRecv.listenForInt("freq4");
PincherPad pp4;
spork ~ pp4.m_params.bindFloatShred("distance", tps[4].m_params, "pinch_distance");
spork ~ pp4.m_params.bindIntShred("freq", oscRecv.m_params, "freq4");
spork ~ pp4.m_params.logIntShred("freq");


// 24h
1::day => now;

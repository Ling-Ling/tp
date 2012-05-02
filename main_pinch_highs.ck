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
oscRecv.listenForInt("freq9");
PincherPad pp;
spork ~ pp.m_params.bindFloatShred("distance", tps[1].m_params, "pinch_distance");
spork ~ pp.m_params.bindIntShred("freq", oscRecv.m_params, "freq9");
spork ~ pp.m_params.logIntShred("freq");

//trackpad 2
oscRecv.listenForInt("freq10");
PincherPad pp2;
spork ~ pp2.m_params.bindFloatShred("distance", tps[2].m_params, "pinch_distance");
spork ~ pp2.m_params.bindIntShred("freq", oscRecv.m_params, "freq10");
spork ~ pp2.m_params.logIntShred("freq");

//trackpad 3
oscRecv.listenForInt("freq11");
PincherPad pp3;
spork ~ pp3.m_params.bindFloatShred("distance", tps[3].m_params, "pinch_distance");
spork ~ pp3.m_params.bindIntShred("freq", oscRecv.m_params, "freq11");
spork ~ pp3.m_params.logIntShred("freq");

//trackpad 4
oscRecv.listenForInt("freq12");
PincherPad pp4;
spork ~ pp4.m_params.bindFloatShred("distance", tps[4].m_params, "pinch_distance");
spork ~ pp4.m_params.bindIntShred("freq", oscRecv.m_params, "freq12");
spork ~ pp4.m_params.logIntShred("freq");


// 24h
1::day => now;

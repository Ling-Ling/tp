//
//  pinch.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//

4 => int numTrackPads;
1 => int startFreq;

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

oscRecv.listenForFloat("pincher_gain");

for( 0 => int i; i< numTrackPads; i++){
    oscRecv.listenForInt("freq"+(startFreq+i));
    PincherPad pp;
    spork ~ pp.m_params.bindFloatShred("distance", tps[i+1].m_params, "pinch_distance");
    spork ~ pp.m_params.bindIntShred("freq", oscRecv.m_params, "freq"+(startFreq+i));
//    spork ~ pp.m_params.logIntShred("freq");

    spork ~ pp.m_params.bindFloatShred("gain", oscRecv.m_params, "pincher_gain");
}


// 24h
1::day => now;

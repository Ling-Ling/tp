//
//  pinch.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//

2 => int numTrackPads;
8 => int startFreq;

8000 => int OSC_PORT;

// trackpads
TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

// osc slave
OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);
oscRecv.listenForInt("pinchGain");

Tilter til;
til.initTilter();

for (0 => int i; i< numTrackPads; i++)
{
    PincherPad pp;

    // map trackpad pinch distance
    spork ~ pp.m_params.bindFloatShred("pinch_dist", tps[i+1].m_params, "pinch_distance");

    // map tilt distance
    spork ~ pp.m_params.bindIntShred("tilt_dist", til.m_params, "tilt"); 
    
    // map trackpad flick distance
    spork ~ pp.m_params.bindFloatShred("flick_dist", tps[i+1].m_params, "flick_distance");

    // check if trackpad tapped
    spork ~ pp.m_params.bindIntShred("doesTap", tps[i+1].m_params, "tap");

    // map OSC freq
    oscRecv.listenForInt("freq" + (startFreq+i));
    spork ~ pp.m_params.bindIntShred("freq", oscRecv.m_params, "freq" + (startFreq + i));

    // map OSC gain
    spork ~ pp.m_params.bindIntShred("gain", oscRecv.m_params, "pinchGain");
}

// 24h
1::day => now;

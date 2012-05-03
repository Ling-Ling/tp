//
//  pinch.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//

4 => int numTrackPads;
0 => int startFreq;

8000 => int OSC_PORT;

// trackpads
TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

// osc slave
OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);
oscRecv.listenForInt("freq");
oscRecv.listenForFloat("gain");


for (0 => int i; i< numTrackPads; i++)
{
    PincherPad pp;

    // map trackpad pinch distance
    spork ~ pp.m_params.bindFloatShred("distance", tps[i].m_params, "pinch_distance");

    // map OSC freq
    oscRecv.listenForInt("freq" + (startFreq+i));
    spork ~ pp.m_params.bindIntShred("freq", oscRecv.m_params, "freq" + (startFreq + i));

    // map OSC gain
    spork ~ pp.m_params.bindFloatShred("gain", oscRecv.m_params, "gain");
}

// 24h
1::day => now;


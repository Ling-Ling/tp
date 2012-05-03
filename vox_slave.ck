
// osc slave
OscParamRecv oscRecv;
oscRecv.initPort(TP.OSC_PORT);
oscRecv.listenForFloat("pinchGain");


// trackpads
TrackPad.getTPs() @=> TrackPad @ tps[];

PincherPad pps[tps.size()];

for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;
    pps[i] @=> PincherPad pp;

    if (tp == NULL) continue;

    oscRecv.listenForFloat("pinchGain");
    spork ~ pp.m_params.bindFloatShred("gain", oscRecv.m_params, "pinchGain");
    spork ~ pp.m_params.logFloatShred("gain");

    oscRecv.listenForInt("freq" + i);
    spork ~ pp.m_params.bindIntShred("freq" + i, oscRecv.m_params, "freq" + i);

    spork ~ pp.m_params.bindFloatShred("distance", tp.m_params, "pinch_distance");
    spork ~ pp.m_params.logFloatShred("distance");
}


// 24h
1::day => now;

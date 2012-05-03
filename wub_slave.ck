

Wub wub;

// osc slave
OscParamRecv oscRecv;
oscRecv.initPort(TP.OSC_PORT);

// wubGain => masterGain
oscRecv.listenForFloat("wubGain");
spork ~ wub.m_params.bindFloatShred("masterGain", oscRecv.m_params, "wubGain");
//spork ~ oscRecv.m_params.logFloatShred("wubGain");

oscRecv.listenForInt("wubNote");
spork ~ wub.m_params.bindIntShred("midiNote", oscRecv.m_params, "wubNote");

oscRecv.listenForFloat("feedbackGain");
spork ~ wub.m_params.bindFloatShred("feedbackGain", oscRecv.m_params, "wubFeedbackGain");

oscRecv.listenForFloat("reverbMix");
spork ~ wub.m_params.bindFloatShred("reverbMix", oscRecv.m_params, "wubReverbMix");


// trackpads
TrackPad.getTPs() @=> TrackPad @ tps[];
for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;

    if (i == 0)
    {
        spork ~ wub.m_params.bindFloatShred("gain", tp.m_params, "pinch_distance");
    }
}


// 24h
1::day => now;

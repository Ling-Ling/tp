
OscParamSend oscSend;
oscSend.initPort(TP.OSC_PORT);

Score.bassNotes @=> ParamIntPattern bassNotes;
spork ~ oscSend.sendIntShred("wubNote");
spork ~ oscSend.m_params.bindIntShred("wubNote", bassNotes.m_params, "value");

spork ~ oscSend.sendFloatShred("wubGain");

spork ~ oscSend.sendFloatShred("wubFeedbackGain");

spork ~ oscSend.sendFloatShred("wubReverbMix");


// trackpads
TrackPad.getTPs() @=> TrackPad @ tps[];
for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;

    else if (i == 0)
    {
        // y => master gain
        spork ~ oscSend.m_params.bindFloatShred("wubGain", tp.m_params, "y");

        // x => pattern index => midi note
        spork ~ bassNotes.m_params.bindIntToFloatShred("index", tp.m_params, "x");
    }

    else if (i == 1)
    {
        // y => feedback gain
        spork ~ oscSend.m_params.bindFloatShred("feedbackGain", tp.m_params, "y");

        // x => reverb mix
        spork ~ oscSend.m_params.bindFloatShred("reverbMix", tp.m_params, "y");
    }
}


// 24h
1::day => now;


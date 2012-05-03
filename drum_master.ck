
// osc master
OscParamSend oscSend;
oscSend.initPort(TP.OSC_PORT);

spork ~ oscSend.sendFloatShred("drumGain");

Score.hhDrumBeats @=> ParamIntPatterns hhBeats;
spork ~ oscSend.sendIntShred("hhBeat");
spork ~ oscSend.m_params.bindIntShred("hhBeat", hhBeats.m_params, "value");
hhBeats.play(100, .2);

Score.tomDrumBeats @=> ParamIntPatterns tomBeats;
spork ~ oscSend.sendIntShred("tomBeat");
spork ~ oscSend.m_params.bindIntShred("tomBeat", tomBeats.m_params, "value");
tomBeats.play(100, .2);

Score.cowbellDrumBeats @=> ParamIntPatterns cbBeats;
spork ~ oscSend.sendIntShred("cbBeat");
spork ~ oscSend.m_params.bindIntShred("cbBeat", cbBeats.m_params, "value");
cbBeats.play(100, .2);


// trackpads
TrackPad.getTPs() @=> TrackPad @ tps[];
for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;

    if (i == 0)
    {
        spork ~ oscSend.m_params.bindFloatShred("drumGain", tp.m_params, "y");

        spork ~ hhBeats.m_params.bindIntToFloatShred("patternIndex", tp.m_params, "x");
        spork ~ tomBeats.m_params.bindIntToFloatShred("patternIndex", tp.m_params, "x");
        spork ~ cbBeats.m_params.bindIntToFloatShred("patternIndex", tp.m_params, "x");
    }
}


// 24h
1::day => now;

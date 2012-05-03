
// osc pincher frequency patterns master
OscFreqSend oscFreqSend;
oscFreqSend.initPort(TP.OSC_PORT);
Score.modePattern @=> oscFreqSend.m_modePattern;
Score.notePattern @=> oscFreqSend.m_notePattern;

spork ~ oscFreqSend.freqLoopShred(10);
spork ~ oscFreqSend.sendFloatShred("pinchGain");


// trackpads
TrackPad.getTPs() @=> TrackPad @ tps[];
for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;
    
    if (i == 0)
    {
        // map TrackPad x to vox indices
        spork ~ oscFreqSend.m_notePattern.m_params.bindIntToFloatShred("index", tp.m_params, "x");
        spork ~ oscFreqSend.m_modePattern.m_params.bindIntToFloatShred("index", tp.m_params, "x");

        spork ~ oscFreqSend.m_params.bindFloatShred("pinchGain", tp.m_params, "y");
        spork ~ tp.m_params.logFloatShred("y");
        spork ~ oscFreqSend.m_params.logFloatShred("pinchGain");

        spork ~ oscSend.m_params.bindFloatShred("drumGain", tp.m_params, "y");
        

        <<< "!">>>;
    }
}

// 24h
1::day => now;

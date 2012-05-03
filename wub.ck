

//
//  Wub wub

Wub wub;


//
//  TrackPads

// get command line trackpad numbers
int TRACKPAD_NUM[me.args()];
for (int i; i < me.args(); i++)
    Std.atoi(me.arg(i)) => TRACKPAD_NUM[i];

TrackPad @ tps[Math.min(me.args(), TrackPad.MAX_NUM_TRACKPADS) $ int];
for (0 => int i; i < tps.size(); i++)
{
    TrackPad tp;
    tp.initTrackPad(TRACKPAD_NUM[i]) @=> tps[i];
    
    if (tp == NULL)
        <<< "[x_x] error initializing trackpad", i >>>;
}

for (0 => int i ; i < tps.size(); i++)
{
    tps[i] @=> TrackPad tp;

    if (tp == NULL) continue;

    if (i == 0)
    {
        // pinch_distance => gain
        spork ~ wub.m_params.bindFloatShred("gain", tp.m_params, "pinch_distance");
//        spork ~ wub.m_params.logFloatShred("gain");
    }

    else if (i == 1)
    {
        // y => master gain
        spork ~ wub.m_params.bindFloatShred("masterGain", tp.m_params, "y");
//        spork ~ wub.m_params.logFloatShred("masterGain");

        // x => pattern index => midi note

        Score.bassNotes @=> ParamIntPattern bass;

        spork ~ bass.m_params.bindIntToFloatShred("index", tp.m_params, "x");
        spork ~ wub.m_params.bindIntShred("midiNote", bass.m_params, "value");

//        spork ~ wub.m_params.logIntShred("midiNote");
    }

    else if (i == 2)
    {
        // y => feedback gain
        spork ~ wub.m_params.bindFloatShred("feedbackGain", tp.m_params, "y");

        // x => reverb mix
        spork ~ wub.m_params.bindFloatShred("reverbMix", tp.m_params, "x");
    }
}


//
//  OSC slave

OscParamRecv oscRecv;
oscRecv.initPort(TP.OSC_PORT);

// wubGain => masterGain
spork ~ wub.m_params.bindFloatShred("masterGain", oscRecv.m_params, "wubGain");

// wubFreq => midiNote
spork ~ wub.m_params.bindIntShred("midiNote", oscRecv.m_params, "wubFreq");


// 24h
1::day => now;


//
//  tp.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


/**  Depencies. Inclue all public classes used across main scripts */
[
    "IntEvent.ck",
    "FloatEvent.ck",
    "Parameters.ck",

    // 
    //  osc

    "OscParamRecv.ck",
    "OscParamSend.ck",
    "OscBeatSend.ck",
    "OscFreqSend",

    //
    //  interfaces

    "Mouse.ck",
    "TrackPad.ck",
    // TODO: "Keyboard.ck",

    //
    //  instruments

    "Wub.ck",

    // static sample-playing utility class & instrument
    "XD.ck",
    "Sample.ck",

    // drum beat
    "DrumPad.ck",
    
    // pincher trackpad instrument
    "PincherPad.ck"
] 
@=> string depencies[];

/**  Depency directory */
"classes/" @=> string depency_dir;

// spork each depency
for (0 => int i; i < depencies.size(); i++)
    if (!Machine.add(depency_dir + depencies[i]))
    {
        <<< "[x_x] error loading depency", depencies[i] >>>;
        Machine.crash(); 
    }

<<< "[^_^]", "loaded all depencies" >>>;

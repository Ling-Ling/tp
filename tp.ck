//
//  TP.ck
//
// Ilias Karim, Jonathan Tilley, & Ling-Ling Zhang
// Stanford Laptop Orchestra (SLOrk)

TP _tp;

/**  I AM CORNHOLIO!? */
public class TP
{
    /**  Depencies. Include all public classes used across main scripts */
    [
        // static utility class (aka bad practice aka anti-pattern)
        "XD.ck",

        "StringEvent.ck",
        "IntEvent.ck",
        "FloatEvent.ck",
        "Parameters.ck",
        "ParamIntPattern.ck",
        "ParamIntPatterns.ck",
        "Score.ck",

        //"ParamTuplePattern.ck",

        // 
        //  osc

        "OscParamRecv.ck",
        "OscParamSend.ck",
        "OscBeatSend.ck",
        "OscFreqSend",

        //
        //  interfaces

        "TrackPad.ck",
        // TODO: "Keyboard.ck",

        //
        //  instruments
        
        "Wub.ck",
        "SampleSet.ck",
        "DrumPad.ck",
        "bellsound.ck",
        // vox 
        "PincherPad.ck"
    ] 
    @=> string _depencies[];

    "classes/" @=> string depency_dir;

    for (0 => int i; i < _depencies.size(); i++)
        // spork each depency
        if (!Machine.add(depency_dir + _depencies[i]))
        {
            <<< "[x_x]", "error loading depency", _depencies[i] >>>;
            Machine.crash(); 
        }

    <<< "[^_^]", "loaded all depencies" >>>;


    // 
    //  static vars & methods

    /**  OSC port static int */
    8000 => static int OSC_PORT;

    /**  Number of channels */
    Math.min(6, dac.channels()) $ int => static int NUM_CHANNELS;

    static TP @ forMy;

    _tp @=> TP.forMy;

    /**  "TP FOR MY BUNGHOLE!" */
    UGen bunghole;
    for (0 => int i; i < NUM_CHANNELS; i++)
        bunghole => dac.chan(i);
}

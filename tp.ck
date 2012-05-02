//
//  tp.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


[
    "Parameters.ck",

    // osc
    "OscParamRecv.ck",

    "OscParamSend.ck",
    "OscBeatSend.ck",

    // static sample-playing utility class
    "XD.ck",

    // generic trackpad superclass
    "Mouse.ck",
    "TrackPad.ck",

    // drum trackpad instrument
    "DrumPad.ck",

    // main script
    "main.ck"

] @=> string depencies[];


for (0 => int i; i < depencies.size(); i++)
{
    if (!Machine.add(depencies[i]))
    {
        <<< "[x_x] error loading depency", depencies[i] >>>;
        break;
    }
}

<<< "[^_^]", "loaded all depencies" >>>;

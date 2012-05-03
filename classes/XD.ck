//
//  XD.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//



/**
 *  Static utility class
 */
public class XD
{
    fun static int KEY(string key)
    {
        int _keys[0];
        48 => _keys["c"];
        49 => _keys["c#"];
        50 => _keys["d"];
        51 => _keys["d#"];
        52 => _keys["e"];
        53 => _keys["f"];
        54 => _keys["f#"];
        55 => _keys["g"];
        56 => _keys["g#"];
        57 => _keys["a"];
        58 => _keys["a#"];
        59 => _keys["b"];

        <<< "key:", key >>>;
        <<< _keys.size() >>>;
        return _keys[key];
    }

    fun static int MODE(string key)
    {
        int _modes[0];
        0 => _modes["major"];
        1 => _modes["minor"];
        2 => _modes["dim"];
        3 => _modes["major7"];
        4 => _modes["dom"];
        5 => _modes["minor7"];
        6 => _modes["hdim"];
        7 => _modes["fdim"];

        return _modes[key];
    }

    fun static int[] MODE_OFFSETS(int i)
    {
        int _modeOffsets[8][5];
        [4, 3, 5, 0] @=> _modeOffsets[MODE("major")];
        [3, 4, 5, 0] @=> _modeOffsets[MODE("minor")]; 
        [3, 3, 6, 0] @=> _modeOffsets[MODE("dim")];
        [4, 3, 4, 1] @=> _modeOffsets[MODE("major7")];
        [4, 3, 3, 2] @=> _modeOffsets[MODE("dom")];
        [3, 4, 3, 2] @=> _modeOffsets[MODE("minor7")];
        [3, 3, 4, 2] @=> _modeOffsets[MODE("hdim")];
        [3, 3, 3, 3] @=> _modeOffsets[MODE("fdim")];

        return _modeOffsets[i];
    }

    fun static void playSampleWithGain(string file, float gain)
    {
        spork ~ __playSampleShred(file, gain);
    }

    fun static void playSample(string file)
    {
        spork ~ __playSampleShred(file, .5);
    }

    fun static void __playSampleShred(string file, float gain)
    {
        SndBuf buf => Gain g => dac;
        file => buf.read;
        gain => g.gain;
        buf.length() => now;        
    }
}

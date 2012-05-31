//
//  XD.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


/**
 *  Static utility class XD
 */
public class XD
{
    fun static int KEY(string key)
    {
        int _keys[0];
        25 => _keys["c#"];
        26 => _keys["d"];
        27 => _keys["d#"];
        28 => _keys["e"];
        29 => _keys["f"];
        30 => _keys["f#"];
        31 => _keys["g"];
        32 => _keys["g#"];
        33 => _keys["a"];
        34 => _keys["a#"];
        35 => _keys["b"];
        36 => _keys["c"];

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
    
    fun static int[] SCALE_MODE_OFFSETS(int i)
    {
        int _modeOffsets[8][7];
        [2,2,2,2,1,2,1] @=> _modeOffsets[MODE("major")];
        //fix these
        [3, 4, 5, 0] @=> _modeOffsets[MODE("minor")]; 
        [3, 3, 6, 0] @=> _modeOffsets[MODE("dim")];
        [4, 3, 4, 1] @=> _modeOffsets[MODE("major7")];
        [4, 3, 3, 2] @=> _modeOffsets[MODE("dom")];
        [3, 4, 3, 2] @=> _modeOffsets[MODE("minor7")];
        [3, 3, 4, 2] @=> _modeOffsets[MODE("hdim")];
        [3, 3, 3, 3] @=> _modeOffsets[MODE("fdim")];
        
        return _modeOffsets[i];
    }


    fun static int[] createChord(int base, int mode, int n)
    {
        int frequency[n];

        if (base != 0)
        {
            for (0 => int i; i < n; i++)
            {
                base => frequency[i];
                base + 1/*XD.MODE_OFFSETS(mode)[i % 3]*/ => base;
            }
        }

        return frequency;
    }
    
    fun static int[] createScale(int base, int mode, int n)
    {
        int frequency[n];
        
        if (base != 0)
        {
            for (0 => int i; i < n; i++)
            {
                base => frequency[i];
                base + XD.SCALE_MODE_OFFSETS(mode)[i % 7] => base;
            }
        }
        
        return frequency;
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
        SndBuf buf;
        Gain g;

        Math.min(6, dac.channels()) $ int => int NUM_CHANNELS;
        for (0 => int i; i < NUM_CHANNELS; i++)
            buf => g => dac.chan(i);

        file => buf.read;
        gain => g.gain;
        buf.length() => now;        
    }
}

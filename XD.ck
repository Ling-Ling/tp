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

<<< "Loaded", "XD.ck" >>>;

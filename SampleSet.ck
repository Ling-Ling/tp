//
//   Sample.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class SampleSet
{
    string m_files[];

    Parameters m_params;
    m_params.setFloat("gain", .5);

    fun void playSampleForInt(int index, string key)
    {
        spork ~ _playLoop(index, key); 
    }

    fun void _playLoop(int index, string key)
    {
        m_params.getNewIntEvent(key) @=> IntEvent e;

        while (1)
        {
            e => now;
            
            if (e.i == 1)
                spork ~ _playSampleShred(index);
        }
    }

    fun void _playSampleShred(int index)
    {
        SndBuf buf;
        Gain g;

        Math.min(6, dac.channels()) $ int => int NUM_CHANNELS;
        for (0 => int i; i < NUM_CHANNELS; i++)
            buf => g => dac.chan(i);

        m_files[index] => buf.read;
        m_params.getFloat("gain") => g.gain;
        buf.length() => now;        
    }
}


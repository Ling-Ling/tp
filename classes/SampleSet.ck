//
//   Sample.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class SampleSet
{
    string m_files[][];

    Parameters m_params;

    // floats
    m_params.setFloat("gain", 0.);
    m_params.setFloat("masterGain", .5);
    m_params.setFloat("gainVariability", .2);

    fun void playSample(int i, string key)
    {
        spork ~_playSampleLoop(i, key);
    }

    fun void _playSampleLoop(int i, string key)
    {
        m_params.getNewIntEvent(key) @=> IntEvent e;

        while (1)
        {
            e => now;
            if (e.i == 1)
                spork ~_playSampleShred(i);
        }
    }

    fun void _playSampleShred(int i)
    {
        SndBuf buf;
        NRev rev;
        Gain g0, g1;

        .02 => rev.mix;

        Math.min(6, dac.channels()) $ int => int NUM_CHANNELS;
        for (0 => int i; i < NUM_CHANNELS; i++)
            buf => g0 => g1 => rev => dac.chan(i);
    
        
        m_files[i] @=> string files[];
        
        files[Std.rand2(0, files.size() - 1)] => buf.read;



        if (m_params.getFloat("gainInterp") < .01)
            return;

        Std.rand2f(0, m_params.getFloat("gainVariability")) => float gainVariability;
        m_params.getFloat("gainInterp") + gainVariability => g0.gain;
        m_params.getFloat("masterGain") => g1.gain;
        buf.length() => now;        
    }

    spork ~ _gainInterpLoop();

    fun void _gainInterpLoop()
    {
        now => time lastGainChange;
        float lastGain;

        while (1)
        {
            100::ms => now;

            if (lastGain == m_params.getFloat("gain") &&
                now - lastGainChange > 1::second)
            {
                m_params.setFloat("gain", 0);
                now => lastGainChange;
            }
            else if (lastGain != m_params.getFloat("gain"))
            {
                now => lastGainChange;
                m_params.getFloat("gain") => lastGain;
            }

            
            m_params.getFloat("gain") - m_params.getFloat("gainInterp") => float diff;
            m_params.setFloat("gainInterp", m_params.getFloat("gainInter") + diff / 2);


            m_params.getFloat("gain"), m_params.getFloat("gainInterp");
        }
    }

}


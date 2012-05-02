//
//   DrumPad.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class DrumPad 
{
    string m_file;
    string m_mixFile;

    //
    //  Parameters
    // 

    Parameters m_params;

    // ints
    m_params.setInt("beatNum", 0);
    m_params.setInt("hit", 0);
    m_params.setInt("sample_set", 0);
    m_params.setInt("n_hits", 0);

    // floats
    m_params.setFloat("gain", 1.);
    m_params.setFloat("freq", 0.);
    m_params.setFloat("openness", 0.);

    m_params.getNewIntEvent("beatNum") @=> Event m_beatEvent;

    spork ~ _beatLoop();
    fun void _beatLoop()
    {
        while (1)
        {
            m_beatEvent => now;

            m_params.getInt("beatNum") => int beatNum;
            m_params.getFloat("openness") => float openness;

            if (m_file != "")
                XD.playSampleWithGain(m_file, 1. * (1. - openness));

            if (m_mixFile != "")
                XD.playSampleWithGain(m_mixFile, 1. * openness);
        }
    }
}

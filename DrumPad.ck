//
//   DrumPad.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class DrumPad 
{
    string m_files[];
    string m_mixFiles[];

    //
    //  Parameters
    // 

    Parameters m_params;

    [[0]] @=> int m_patterns[][];


    // ints
    m_params.setInt("beatNum", 0);
    m_params.setInt("hit", 0);
    m_params.setInt("pattern", 0);
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

            m_params.getInt("pattern") => int pattern;

            if (m_patterns.size() > 0 && m_files != NULL && m_patterns[pattern].size() >= beatNum && m_patterns[pattern][beatNum] == 1)
            {
                XD.playSampleWithGain(m_files[Std.rand2(0, m_files.size() - 1)], 1. * (1. - openness));

                if (m_mixFiles != NULL)
                {
                    XD.playSampleWithGain(m_mixFiles[Std.rand2(0, m_mixFiles.size() - 1)], 1. * openness);
                    <<< m_mixFiles[Std.rand2(0, m_mixFiles.size() - 1)] >>>;
                }
            }
        }
    }
}

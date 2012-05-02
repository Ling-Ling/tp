//
//   Sample.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class Sample 
{
    string m_files[];

    //
    //  Parameters
    // 

    Parameters m_params;

    // ints
    m_params.setInt("hit", 0);
    m_params.setInt("beatNum", 0);
    m_params.setInt("n_hits", 0);

    // floats
    m_params.setFloat("gain", 1.);


    m_params.getNewIntEvent("hit") @=> Event m_hitEvent;

    spork ~ _hitLoop();
    fun void _hitLoop()
    {
        while (1)
        {
            m_hitEvent => now;

            if (m_params.getInt("hit"))
                m_params.setInt("n_hits", m_params.getInt("n_hits") + 1);
        }
    }


    m_params.getNewIntEvent("beatNum") @=> Event m_beatEvent;

    spork ~ _beatLoop();
    fun void _beatLoop()
    {
        while (1)
        {
            m_beatEvent => now;

            if (m_params.getInt("n_hits") > 0 && m_files != NULL && m_params.getInt("beatNum") % 2 == 0)
            {
                XD.playSampleWithGain(m_files[Std.rand2(0, m_files.size() -1)], m_params.getFloat("gain"));
                m_params.setInt("n_hits", m_params.getInt("n_hits") - 1);
            }
        }
    }
}


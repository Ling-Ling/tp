

public class ParamIntPattern
{
    int m_pattern[];

    Parameters m_params;
    m_params.setInt("index", 0);
    m_params.setInt("value", 0);

    fun void initWithPattern(int pattern[])
    {
        pattern @=> m_pattern;

        m_params.setIntRange("index", 0, m_pattern.size());
    }

    spork ~ _indexLoop();
    fun void _indexLoop()
    {
        m_params.getNewIntEvent("index") @=> IntEvent e;
        while (1)
        {
            if (m_pattern != NULL)
                m_params.setInt("value", m_pattern[e.i]);

            e => now;
        }
    }

    fun void increment()
    {
        m_params.setInt("index", m_params.getInt("index") + 1);
    }


    int m_bpm;
    float m_swing;

    fun void play(int bpm, float swing)
    {
        bpm => m_bpm;
        swing => m_swing;

        spork ~ _playLoop();
    }

    fun void _playLoop()
    {
        while (1)
        {
//            <<< m_params.getInt("value") >>>;
            1::minute / (m_bpm * 8) => dur duration;

            // compensate for swing
            if (m_params.getInt("index") % 2 == 0)
                duration * (1 - (m_swing / 4.)) => duration;
            else
                duration / (1 - (m_swing / 4.)) => duration;

            duration => now;

            increment();
        }
    }
}


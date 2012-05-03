

public class ParamIntPattern
{
    int m_pattern[];

    Parameters m_params;
    m_params.setInt("index", 0);
    m_params.setInt("value", 0);

    fun void init(int pattern[])
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
            m_params.setInt("value", m_pattern[e.i]);

            e => now;
        }
    }

    fun void increment()
    {
        m_params.setInt("index", m_params.getInt("index") + 1);
    }
}



public class ParamIntPattern
{
    int m_pattern[];

    Parameters m_params;
    m_params.setInt("index", 0);

    Parameters m_otherParams;
    string m_key;

    fun void init(Parameters params, string key, int pattern[])
    {
        params @=> m_otherParams;
        key => m_key;

        pattern @=> m_pattern;

        m_params.setIntRange("index", 0, m_pattern.size());

    }

    spork ~ _indexLoop();
    fun void _indexLoop()
    {
        m_params.getNewIntEvent("index") @=> IntEvent e;
        while (1)
        {
            e => now;
            
            m_params.setInt("value", m_pattern[e.i]);
        }
    }

}

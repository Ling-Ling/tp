

public class ParamIntPatterns extends ParamIntPattern
{
    int m_patterns[][];

    fun ParamIntPatterns initWithPatterns(int patterns[][])
    {
        patterns @=> m_patterns;

        m_params.setIntRange("patternIndex", 0, m_patterns.size());

        return this;
    }

    spork ~ _patternIndexLoop();
    fun void _patternIndexLoop()
    {
        m_params.getInt("patternIndex") @=> int lastIndex;
        m_params.getNewIntEvent("patternIndex") @=> IntEvent e;
        while (1)
        {
            if (m_patterns != NULL && e.i != lastIndex)
            {
                m_patterns[e.i] @=> m_pattern;
                m_params.setIntRange("index", 0, m_pattern.size());
                m_params.setInt("index", m_params.getInt("index"));
                e.i => lastIndex;
            }

            e => now;
        }
    }

    
}

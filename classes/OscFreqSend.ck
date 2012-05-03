//
//  OscFreqSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


public class OscFreqSend extends OscParamSend
{
    ParamIntPattern m_modePattern;
    ParamIntPattern m_notePattern;
    
    0 => int m_nFreq;

    fun void freqLoopShred(int nFreq)
    {
        nFreq => m_nFreq;

        for (0 => int i; i < nFreq; i++)
            spork ~ sendIntShred("freq" + i);
        
        while (1)
            1::day => now;
    }

    fun void _sendFreqs()
    {
        m_modePattern.m_params.getInt("value") => int mode;
        m_notePattern.m_params.getInt("value") => int base;

        int frequency[m_nFreq];
        XD.createChord(base, mode, frequency.size()) @=> frequency;

        for (0 => int i; i < frequency.size(); i++)
           m_params.setInt("freq" + i, frequency[i]);
    }

    spork ~ _noteLoop();
    fun void _noteLoop()
    {
        m_notePattern.m_params.getNewIntEvent("value") @=> IntEvent e;

        while (1)
        {
            e => now;
            _sendFreqs();
        }
    }

    spork ~ _modeLoop();
    fun void _modeLoop()
    {
        m_modePattern.m_params.getNewIntEvent("value") @=> IntEvent e;

        while (1)
        {
            e => now;
            _sendFreqs();
        }
    }
}

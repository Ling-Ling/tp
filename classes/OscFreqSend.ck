//
//  OscFreqSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//



public class OscFreqSend extends OscParamSend
{
    fun int[] createChord(int base, int mode, int n)
    {
        int frequency[n];

        if (base != 0)
        {
            for (0 => int i; i < n; i++)
            {
                base => frequency[i];
                base + XD.MODE_OFFSETS(mode)[i % 3] => base;
            }
        }

        return frequency;
    }

    [
     XD.MODE("major"),
     XD.MODE("minor"),
     XD.MODE("minor"),
     XD.MODE("major"),
     XD.MODE("major"),
     XD.MODE("major"),
     XD.MODE("minor"),
     XD.MODE("dim"),
     XD.MODE("major")
    ]
    @=> int modeProgression[];

    ParamIntPattern m_modePattern;
    m_modePattern.init(modeProgression);

    [
     XD.KEY("c"),
     XD.KEY("e"),
     XD.KEY("a"),
     XD.KEY("g"),
     XD.KEY("c"),
     XD.KEY("f"),
     XD.KEY("d"),
     XD.KEY("b"),
     XD.KEY("c")
    ] 
    @=> int noteProgression[];

    ParamIntPattern m_notePattern;
    m_notePattern.init(noteProgression);
    
    0 => int m_n;

    fun void freqLoopShred(int n)
    {
        n => m_n;

        for (0 => int i; i < n; i++)
            spork ~ sendIntShred("freq" + i);
        
        while (1)
            1::day => now;
    }

    fun void _sendFreqs()
    {
        m_modePattern.m_params.getInt("value") => int mode;
        m_notePattern.m_params.getInt("value") => int base;

        int frequency[m_n];
        createChord(base, mode, frequency.size()) @=> frequency;

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

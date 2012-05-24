//
//  OscScaleSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


public class OscScaleSend extends OscParamSend
{
    ParamIntPattern m_notePattern;
    ParamIntPattern m_modePattern;
    ["a","b","c", "d","e","f","g","h","i","j","k","l","m",
    "n","o","p","q","r","s","t","u","v","w","x","y","z"]
    @=>string alphabet[];

    
    0 => int m_nFreq;

    fun void freqLoopShred(int nFreq)
    {
        nFreq => m_nFreq;

        for (0 => int i; i < nFreq; i++)
            spork ~ sendIntShred("freq" + alphabet[i]);
        
        while (1)
            1::day => now;
    }

    fun void _sendFreqs()
    {
        //change back for this to be dynamic
        //m_modePattern.m_params.getInt("value") => int mode;
        //m_notePattern.m_params.getInt("value") => int base;

        //major
        0 => int mode;
        //c
        0 => int base;

        int frequency[m_nFreq];
        XD.createChord(base, mode, frequency.size()) @=> frequency;

       for (0 => int i; i < frequency.size(); i++){
           m_params.setInt("freq" + alphabet[i], frequency[i]);
       }
       //<<<"sent",frequency.size(), "frequencies">>>;
    }

    //remove this when chord change is controlled
    spork ~ _repeaterLoop();
    fun void _repeaterLoop()
    {  
        while (1)
        {
            1::second => now;
            _sendFreqs();
        }
    }
    //
    
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

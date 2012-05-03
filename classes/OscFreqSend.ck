//
//  OscFreqSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//



public class OscFreqSend extends OscParamSend
{
    int keys[0];
    48 => keys["c"];
    49 => keys["c#"];
    50 => keys["d"];
    51 => keys["d#"];
    52 => keys["e"];
    53 => keys["f"];
    54 => keys["f#"];
    55 => keys["g"];
    56 => keys["g#"];
    57 => keys["a"];
    58 => keys["a#"];
    59 => keys["b"];

    int modes[0];
    0 => modes["major"];
    1 => modes["minor"];
    2 => modes["dim"];
    3 => modes["major7"];
    4 => modes["dom"];
    5 => modes["minor7"];
    6 => modes["hdim"];
    7 => modes["fdim"];

    1::second => dur duration;
    
    [4, 3, 5] @=> int major[];
    [3, 4, 5] @=> int minor[];
    [3, 3, 6] @=> int dim[];
    [4, 3, 4, 1] @=> int major7[];
    [4, 3, 3, 2] @=> int dom[];
    [3, 4, 3, 2] @=> int minor7[];
    [3, 3, 4, 2] @=> int hdim[];
    [3, 3, 3, 3] @=> int fdim[];

    fun int[] createChord(int base, int mode, int n)
    {
        int frequency[n];

        if (base != 0)
        {
            for (0 => int i; i < n; i++)
            {
                if (mode == modes["major"]) {
                    base => frequency[i];
                    base + major[i%3] => base;
                }
                if (mode == modes["minor"]) {
                    base => frequency[i];
                    base + minor[i%3] => base;
                }
                if (mode == modes["dim"]) {
                    base => frequency[i];
                    base + dim[i%3] => base;
                }
               if (mode == modes["major7"]) {
                    base => frequency[i];
                    base + major7[i%3] => base;
                }
                if (mode == modes["major77"]) {
                    base => frequency[i];
                    base + dom[i%3] => base;
                }
                if (mode == modes["min7"]) {
                    base => frequency[i];
                    base + minor7[i%3] => base;
                }
               if (mode == modes["dim7"]) {
                    base => frequency[i];
                    base + hdim[i%3] => base;
                }
                if (mode == modes["dim77"]) {
                    base => frequency[i];
                    base + fdim[i%3];
                }
            }
        }

        return frequency;
    }
    

    ParamIntPattern notePattern;
    ParamIntPattern modePattern;
    
    0 => int m_n;

    fun void freqLoopShred(int n)
    {
        n => m_n;

        spork ~ sendIntShred("freq1");
        spork ~ sendIntShred("freq2");
        spork ~ sendIntShred("freq3");
        spork ~ sendIntShred("freq4");
        spork ~ sendIntShred("freq5");
        spork ~ sendIntShred("freq6");
        spork ~ sendIntShred("freq7");
        spork ~ sendIntShred("freq8");
        spork ~ sendIntShred("freq9");
        spork ~ sendIntShred("freq10");
        
        //-2 => int lowOctave;
        //0 => int midOctave;
        //1 => int highOctave;

        [
         modes["major"],
         modes["minor"],
         modes["minor"],
         modes["major"],
         modes["major"],
         modes["major"],
         modes["minor"],
         modes["dim"],
         modes["major"]
        ]
        @=> int modeProgression[];

        modePattern.init(modeProgression);

//        spork ~ modePattern.m_params.logIntShred("value");


        [
         keys["c"],
         keys["e"],
         keys["a"],
         keys["g"],
         keys["c"],
         keys["f"],
         keys["d"],
         keys["b"],
         keys["c"]
        ] 
        @=> int noteProgression[];

        notePattern.init(noteProgression);


        while (1)
        {
            test();

            // wait
            duration => now;
        }
    }
    fun void test()
    {

            modePattern.increment();
            notePattern.increment();

            modePattern.m_params.getInt("value") => int mode;
            notePattern.m_params.getInt("value") => int base;

            int frequency[m_n];
            createChord(base, mode, frequency.size()) @=> frequency;

            for (0 => int i; i < frequency.size(); i++)
               m_params.setInt("freq" + i, frequency[i]);
    }

    fun void _sendFreqs()
    {
        /*
        
        modePattern.m_params.getInt("value") => int mode;
        notePattern.m_params.getInt("value") => int base;

        int frequency[m_n];
        createChord(base, mode, frequency.size()) @=> frequency;

        for (0 => int i; i < frequency.size(); i++)
        {
           m_params.setInt("freq" + i, frequency[i]);
           //<<< i, frequency[i] >>>;
        }
        */
    }

    spork ~ _noteLoop();
    fun void _noteLoop()
    {
        notePattern.m_params.getNewIntEvent("value") @=> IntEvent e;

        while (1)
        {
            e => now;
    
            _sendFreqs();
        }
    }

    spork ~ _modeLoop();
    fun void _modeLoop()
    {
        modePattern.m_params.getNewIntEvent("value") @=> IntEvent e;

        while (1)
        {
            e => now;
    
            _sendFreqs();
        }
    }
}

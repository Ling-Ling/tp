//
//  OscFreqSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//

public class OscFreqSend extends OscParamSend
{
    4::second => dur duration;
    
    [4, 3, 5] @=> int major[];
    [3, 4, 5] @=> int minor[];
    [3, 3, 6] @=> int dim[];
    [4, 3, 4, 1] @=> int major7[];
    [4, 3, 3, 2] @=> int dom[];
    [3, 4, 3, 2] @=> int minor7[];
    [3, 3, 4, 2] @=> int hdim[];
    [3, 3, 3, 3] @=> int fdim[];

    fun int[] createChord(int base, string mode, int n)
    {
        int frequency[n];

        if (base != 0)
        {
            for (0 => int i; i < n; i++)
            {
                if (mode == "major") {
                    base => frequency[i];
                    base + major[i%3] => base;
                }
                if (mode == "minor") {
                    base => frequency[i];
                    base + minor[i%3] => base;
                }
                if (mode == "dim") {
                    base => frequency[i];
                    base + dim[i%3] => base;
                }
               if (mode == "major7") {
                    base => frequency[i];
                    base + major7[i%3] => base;
                }
                if (mode == "major77") {
                    base => frequency[i];
                    base + dom[i%3] => base;
                }
                if (mode == "min7") {
                    base => frequency[i];
                    base + minor7[i%3] => base;
                }
               if (mode == "dim7") {
                    base => frequency[i];
                    base + hdim[i%3] => base;
                }
                if (mode == "dim77") {
                    base => frequency[i];
                    base + fdim[i%3];
                }
            }
        }

        return frequency;
    }

    fun void freqLoopShred()
    {
        10 => int n;

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


        string noteChar;

        ["major","minor","minor","major","major","major","minor","dim","major"] @=> string modeProgression[];

        ["c", "e", "a", "g", "c", "f", "d", "b", "c"] @=> string noteProgression[];

        int noteBases[0];
        48 => noteBases["c"];
        49 => noteBases["c#"];
        50 => noteBases["d"];
        51 => noteBases["d#"];
        52 => noteBases["e"];
        53 => noteBases["f"];
        54 => noteBases["f#"];
        55 => noteBases["g"];
        56 => noteBases["g#"];
        57 => noteBases["a"];
        58 => noteBases["a#"];
        59 => noteBases["b"];

        0 => int posInProgression;
        //I iii vi V I IV ii vii I
        0 => int wait;
        0 => int i;
        0 => int base;
        "major" => string mode;

        int frequency[n];        

        while (1)
        {
            modeProgression[posInProgression%9] => mode;
            noteProgression[posInProgression%9] => noteChar;
                       
            noteBases["noteChar"] => base;
        
            createChord(base, mode, frequency.size()) @=> frequency;

            0 => base;

            for (0 => int i; i < frequency.size(); i++)
                m_params.setInt("freq" + i, frequency[i]);

            // wait
            duration => now;
            posInProgression++;
        }
    }
}

//
//  OscFreqSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


public class OscFreqSend extends OscParamSend
{

4::second => dur duration;
    fun void freqLoopShred()
    {
        this.setHost(MULTIPLEX_IP_ADDRESS, m_port);

        spork ~ sendIntShred("freq1");
        spork ~ sendIntShred("freq2");
        spork ~ sendIntShred("freq3");
        spork ~ sendIntShred("freq4");
        spork ~ sendIntShred("freq5");
        spork ~ sendIntShred("freq6");
        spork ~ sendIntShred("freq7");
        spork ~ sendIntShred("freq8");



        [4, 3, 5] @=> int major[];
        [3, 4, 5] @=> int minor[];
        [3, 3, 6] @=> int dim[];
        [4, 3, 4, 1] @=> int major7[];
        [4, 3, 3, 2] @=> int dom[];
        [3, 4, 3, 2] @=> int minor7[];
        [3, 3, 4, 2] @=> int hdim[];
        [3, 3, 3, 3] @=> int fdim[];

        "c" => string noteChar;

        ["major","minor","minor","major","major","major","minor","dim","major"] @=> string modeProgression[];
        ["c", "e", "a", "g", "c", "f", "d", "b", "c"] @=> string noteProgression[];
        0 => int posInProgression;
        //I iii vi V I IV ii vii I
        0 => int wait;
        0 => int numWaves;
        0 => int base;
        "major" => string mode;

        int frequency[20];        

        while (1){

            modeProgression[posInProgression%9] => mode;
            noteProgression[posInProgression%9] => noteChar;
                       
            if (noteChar == "c") 48 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "c#") 49 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "d") 50 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "d#") 51 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "e") 52 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "f") 53 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "f#") 54 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "g") 55 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "g#") 56 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "a") 57 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "a#") 58 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "b") 59 => base;//frequency[channel][numWaves[channel]-1];
        
            if (base != 0){
                0 => numWaves;
                for (0 => int i; i < 8; i++)
                {
                    if (mode == "major") {
                        base => frequency[numWaves];
                        base + major[i%3] => base;
                        }
                    if (mode == "minor") {
                        base => frequency[numWaves];
                        base + minor[i%3] => base;
                    }
                    if (mode == "dim") {
                        base => frequency[numWaves];
                        base + dim[i%3] => base;
                    }
                   if (mode == "major7") {
                        base => frequency[numWaves];
                        base + major7[i%3] => base;
                    }
                    if (mode == "major77") {
                        base => frequency[numWaves];
                        base + dom[i%3] => base;
                    }
                    if (mode == "min7") {
                        base => frequency[numWaves];
                        base + minor7[i%3] => base;
                    }
                   if (mode == "dim7") {
                        base => frequency[numWaves];
                        base + hdim[i%3] => base;
                    }
                    if (mode == "dim77") {
                        base => frequency[numWaves];
                        base + fdim[i%3];
                    }
                    numWaves++;
                } 
            }
            0 => base;

            m_params.setInt("freq1", frequency[0]);
            m_params.setInt("freq2", frequency[1]);
            m_params.setInt("freq3", frequency[2]);
            m_params.setInt("freq4", frequency[3]);
            m_params.setInt("freq4", frequency[4]);
            m_params.setInt("freq4", frequency[5]);
            m_params.setInt("freq4", frequency[6]);
            m_params.setInt("freq4", frequency[7]);

            // wait
            duration => now;
            posInProgression++;
        }
    }
}

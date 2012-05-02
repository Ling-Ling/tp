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

        while (1){
            Std.rand2(44,45) => int freq;
            m_params.setInt("freq1", freq);
            m_params.setInt("freq2", freq + Std.rand2(3,4));
            
            // wait
            duration => now;
       }
    }
}

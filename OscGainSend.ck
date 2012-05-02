//
//  OscGainSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


public class OscGainSend extends OscParamSend
{

    fun void gainLoopShred()
    {
        this.setHost(MULTIPLEX_IP_ADDRESS, m_port);

        spork ~ sendFloatShred("gain");
        
        0.0 => float gain;
        1 => int isRising;

        while (1)
        {
            m_params.setFloat("gain", gain);
            2::second => now;
            if(isRising)
                gain + .05 => gain;
             else
                 gain -.05 => gain;
             if(gain >= 1.0)
                 0 => isRising;
             <<<"master gain ", gain>>>;
        }
    }
}

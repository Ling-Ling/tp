//
//   PincherPad.ck
//
//  Jonathan Tiley
//  Stanford Laptop Orchestra (SLOrk)
//


public class PincherPad 
{

    //
    //  Parameters
    // 

    Parameters m_params;

    //units
    FMVoices s => dac;
    0.0=>s.gain;
    Envelope e => blackhole;
    .5::second => e.duration;

    // floats
    m_params.setFloat("distance", 1.);
    m_params.setFloat("freq", 0.);
    
    spork ~ _pinchLoop();
    fun void _pinchLoop()
    {
        m_params.getNewFloatEvent("distance") @=> Event event;

        while (1)
        {
            event => now;
            m_params.getFloat("distance") => float dist;
            (s.gain() * 1000) $ int => e.value;
            if(dist > .9){
                900 => e.target;
            }else{
                (dist * 1000) $ int => e.target;
            }
            if(Std.fabs((e.target() / 1000) - s.gain()) > .2){
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    (e.value() $ float) / 1000 => s.gain;
                    s.gain() => s.vowel;
                    1::samp => now;
                }
            }else{
                (e.target() $ float) / 1000 => s.gain;
                s.gain() => s.vowel;
            }
        }
    }
    
    
    spork ~ _freq1Loop();
    fun void _freq1Loop()
    {
        m_params.getNewIntEvent("freq1") @=> Event event;
        
        while (1)
        {
            event => now;
            Std.mtof(m_params.getInt("freq1")) => s.freq;
        }
    }
    
    spork ~ _freq2Loop();
    fun void _freq2Loop()
    {
        m_params.getNewIntEvent("freq2") @=> Event event;
        
        while (1)
        {
            event => now;
            Std.mtof(m_params.getInt("freq2")) => s.freq;
        }
    }

}

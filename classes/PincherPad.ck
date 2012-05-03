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
    now => time lastTouch;
    0 => float globalGain;

    // floats
    m_params.setFloat("distance", 0.);
    m_params.setFloat("freq", 0.);
    m_params.setFloat("gain", 0.);
    
//    spork ~ m_params.logFloatShred("gain");

    spork ~ _fadeOuter();
    fun void _fadeOuter(){
        while(1){
            1::second => now;
            if(now - lastTouch > 1::second){
                0 => e.target;
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    (e.value() $ float) / 1000 => s.gain;
                    s.gain() * m_params.getFloat("gain") => s.vowel;
                    1::samp => now;
                }
            }
        }
    }
    
    spork ~ _pinchLoop();
    fun void _pinchLoop()
    {
        m_params.getNewFloatEvent("distance") @=> Event event;

        while (1)
        {
            event => now;
            now => lastTouch;
            m_params.getFloat("distance") => float dist;
            (s.gain() * 1000 * m_params.getFloat("gain")) $ int => e.value;
            if(dist > .9){
                900 => e.target;
            }else{
                (dist * 1000) $ int => e.target;
            }
            if(Std.fabs((e.target() / 1000) - s.gain() * m_params.getFloat("gain")) > .2){
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    globalGain * (e.value() $ float) / 1000 => s.gain;
                    s.gain() => s.vowel;
                    1::samp => now;
                }
            }else{
                 globalGain * (e.target() $ float) / 1000 => s.gain;
                s.gain() => s.vowel;
            }
        }
    }
    
    
    spork ~ _freqLoop();
    fun void _freqLoop()
    {
        m_params.getNewIntEvent("freq") @=> Event event;
        
        while (1)
        {
            event => now;
            Std.mtof(m_params.getInt("freq")) => s.freq;
        }
    }
    
    spork ~ _gainLoop();
    fun void _gainLoop()
    {
        m_params.getNewFloatEvent("gain") @=> Event event;
        
        while (1)
        {
            event => now;
            Std.mtof(m_params.getFloat("gain")) => globalGain;
        }
    }

}

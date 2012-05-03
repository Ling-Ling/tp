//
//   PincherPad.ck
//
//  Jonathan Tiley
//  Stanford Laptop Orchestra (SLOrk)
//


public class PincherPad 
{
 
    //constants
    .8 => float maxGain;
    1000 => int intMultiplier;
    
    
    //
    //  Parameters
    // 

    Parameters m_params;

    //units
    FMVoices s => Gain g => dac;
    0.0=>s.gain;
    Envelope e => blackhole;
    .5::second => e.duration;
    now => time lastTouch;

    // floats
    m_params.setFloat("distance", 0.);
    m_params.setInt("freq", 0);
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
                    (e.value() $ float) / intMultiplier => s.gain;
                    s.gain() => s.vowel;
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
            (s.gain() * intMultiplier) $ int => e.value;
            if(dist > maxGain){
                maxGain * intMultiplier => e.target;
            }else{
                (dist * intMultiplier) $ int => e.target;
            }
            if(Std.fabs((e.target() / intMultiplier) - s.gain()) > .2){
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    (e.value() $ float) / intMultiplier => s.gain;
                    s.gain() => s.vowel;
                    1::samp => now;
                }
            }else{
                 (e.target() $ float) / intMultiplier => s.gain;
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
            m_params.getFloat("gain") => g.gain;
        }
    }

}

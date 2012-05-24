//
//   PincherPad.ck
//
//  Jonathan Tiley
//  Stanford Laptop Orchestra (SLOrk)
//

//Machine.add("bellsound.ck");



public class PincherPad 
{
 
    BellSound bellSound;
    bellSound.SetGain(0);
//    50 => float bellFreq;
    //constants
    .8 => float MAX_GAIN;
    
    //
    //  Parameters
    // 

    Parameters m_params;

    //units
    //FMVoices
    SinOsc s => Gain g => dac;
    0.0=>s.gain;
    now => time lastTouch;

    // floats
    m_params.setFloat("pinch_dist", 0.);
    m_params.setFloat("flick_dist", 0.);
    m_params.setInt("doesTap", 0);
    m_params.setInt("freq", 0);
    m_params.setFloat("gain", 0.);
    
    spork ~ m_params.logFloatShred("gain");

    spork ~ _fadeOuter();
    fun void _fadeOuter(){
        Envelope e => blackhole;
        .5::second => e.duration;
        while(1){
            1::second => now;
            if(now - lastTouch > 1::second){
                s.gain() => e.value;
                0. => e.target;
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    e.value() => s.gain;
                    //s.gain() => s.vowel;
                    1::samp => now;
                }
            }
        }
    }
    
    spork ~ _pinchLoop();
    fun void _pinchLoop()
    {
        m_params.getNewFloatEvent("pinch_dist") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while (1)
        {
            event => now;
            now => lastTouch;
            m_params.getFloat("pinch_dist") => float dist;
            s.gain() => e.value;
            if(dist > MAX_GAIN){
                MAX_GAIN => e.target;
            }else{
                dist => e.target;
            }
            if(Std.fabs(e.target() - s.gain()) > .2){
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    e.value() => s.gain;
                    //s.gain() => s.vowel;
                    1::samp => now;
                }
            }else{
                 e.target() => s.gain;
                //s.gain() => s.vowel;
            }
        }
    }
    

    spork ~ _flickLoop();
    fun void _flickLoop()
    {
        m_params.getNewFloatEvent("flick_dist") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while (1)
        {
            event => now;
            now => lastTouch;
            m_params.getFloat("flick_dist") => float dist;
            s.gain() => e.value;
            if(dist > MAX_GAIN){
                MAX_GAIN => e.target;
            }else{
                dist => e.target;
            }
            if(Std.fabs(e.target() - s.gain()) > .2){
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    e.value() => s.gain;
                    //s.gain() => s.vowel;
                    1::samp => now;
                }
            }else{
                e.target() => s.gain;
                //s.gain() => s.vowel;
            }
        }
    }

    
    spork ~ _tapLoop();
    fun void _tapLoop()
    {
        <<<"tap loop">>>;
        m_params.getNewIntEvent("doesTap") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while (1)
        {
            //<<<"tap?">>>;
            event => now;
            now => lastTouch;
            m_params.getInt("doesTap") => int tap;
            //s.gain() => e.value;
	    //<<<"tap", tap>>>;
            if(tap == 1){
                <<<"tap==yes">>>;
                spork ~ bellSound.RingBell();//Std.mtof(bellFreq));
            }
            <<<bellSound.GetGain()>>>;
            if(bellSound.GetGain() > .05){
                <<<"?">>>;
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                //    e.value() => s.gain;
                  //  s.gain() => s.vowel;
                    1::samp => now;
                }
            }else{
                //e.target() => s.gain;
                //s.gain() => s.vowel;
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
            bellSound.SetFreq(Std.mtof(m_params.getInt("freq")));
	}
    }
    
    spork ~ _gainLoop();
    fun void _gainLoop()
    {
        m_params.getNewFloatEvent("gain") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while(1){
            event => now;
             g.gain() => e.value;
            m_params.getFloat("gain") => e.target;
            now + e.duration() => time later; //swoop for 1 second
            //"manually" use changing envelope value to set freq
            while (now < later) { 
                    e.value() => g.gain;
                    1::samp => now;
           }
       }           
    }
    
}

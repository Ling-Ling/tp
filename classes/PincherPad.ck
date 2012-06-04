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

    // params
    m_params.setFloat("pinch_dist", 0.);
    m_params.setFloat("bow_height", 0.);
    m_params.setFloat("doesTap", 0.);
    m_params.setInt("freq", 0);
    m_params.setFloat("gain", 0.);
    m_params.setFloat("size", 0.);
    m_params.setInt("tilt_dist", 0); 
 
    //spork ~ m_params.logFloatShred("gain");

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
    spork ~ _tiltLoop();
    fun void _tiltLoop()
    {
        m_params.getNewIntEvent("tilt_dist") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while(1)
        {
            event => now;
            now => lastTouch;
            m_params.getInt("tilt_dist") => int tilt;
            if (tilt == 1) {
                spork ~ bellSound.RingBell(s.freq(), .5);
            }
            if (bellSound.GetGain() > .05) {
                now + e.duration() => time later;
                while (now < later) {
                    1::samp => now;
                }
            }
        }      
    }

    
    //spork ~ _pinchLoop();
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
    

    spork ~ _tapLoop();
    fun void _tapLoop()
    {
        m_params.getNewFloatEvent("doesTap") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while (1)
        {
            event => now;
            now => lastTouch;
            m_params.getFloat("doesTap") => float tap;
            
            <<<"tap">>>;
            if (tap > 0) {
                spork ~ bellSound.RingBell(s.freq(), tap/2);
            }
            if(bellSound.GetGain() > .1) {//Std.fabs(e.target() - s.gain()) > .2){
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) { 
                    1::samp => now;
                }
            }
        }
    }

    
    spork ~ _bowLoop();
    fun void _bowLoop()
    {
        <<<"tap loop">>>;
        m_params.getNewFloatEvent("bow_height") @=> Event event;
        Envelope e => dac;
        .5::second => e.duration;
        float lastFreq;
        
        while (1)
        {
            <<<"bow">>>;
            event => now;
            now => lastTouch;
            m_params.getFloat("bow_height") => float bow;
            bellSound.GetGain() => e.value;
            if (bow > 0){
                    bellSound.SetGain(bow/2);
                    bow/2 => lastFreq;
                //tap => e.target;//Std.mtof(bellFreq));
            } else {
                spork ~ bellSound.RingBell(s.freq(), lastFreq);
                bellSound.SetGain(0);
                /*bellSound.SetFreq(s.freq());
                Gain g;
                bellSound.GetGain() => g.gain;
                spork ~ bellSound.ExpDecay(g);
                while (g.gain() > 0) {
                    bellSound.SetGain(g.gain());
                    1::ms => now;
                }*/
                //2::second => now;
            }
            
            //<<<bellSound.GetGain()>>>;
            /*
            if(bellSound.GetGain() > .05){
                //<<<"?">>>;
                now + e.duration() => time later; //swoop for 1 second
                //"manually" use changing envelope value to set freq
                while (now < later) {
                    bellSound.SetGain(e.value());
                    1::samp => now;
                }
            }else{
                <<<"set gain">>>;
                bellSound.SetGain(e.target());
                //e.target() => s.gain;
                //s.gain() => s.vowel;
            }
            */
        }
    }

    spork ~ _onReleaseLoop();
    fun void _onReleaseLoop()
    {
        m_params.getNewIntEvent("onRelease") @=> Event event;
        Envelope e => blackhole;
        .5::second => e.duration;
        
        while (1)
        {
           event => now;
           m_params.getInt("onRelease") => int release;

           if (release == 2){
               bellSound.SetFreq(s.freq());
               Gain g;
               bellSound.GetGain() => g.gain;
               spork ~ bellSound.ExpDecay(g);
               while (g.gain() > 0) {
                   bellSound.SetGain(g.gain());
                   1::ms => now;
               }
               2::second => now;
           }

           //<<<"released">>>;
        }
    }

    spork ~ _freqLoop();
    fun void _freqLoop()
    {
        m_params.getNewIntEvent("freq") @=> Event event;
        
        while (1)
        {
            event => now;
            m_params.getInt("freq")=>int freq;
            Std.mtof(freq) => s.freq;
            //<<<Std.mtof(m_params.getInt("freq"))>>>;
            <<<freq>>>;
            bellSound.SetFreq(Std.mtof(freq));
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

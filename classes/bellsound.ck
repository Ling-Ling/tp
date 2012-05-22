// For testing and reference only
class SawSound {
    SawOsc osc => Gain env => Gain master => dac;
    0 => env.gain;
    0.3 => master.gain;
    
    fun void SetGain(float gain) {
        gain => env.gain;
    }
    
    fun void SetFreq(float freq) {
        freq => osc.freq;
    }
}


/// BELL SYNTHESIS ///               

/* Bell sound uses 12 parallel SinOscs to do modal synthesis, with a LPF
that sweeps from high to low since low frequencies should ring longer.
Also adds FM-synthesized nonharmonic tones in the first moment of the sound
to emulate nonharmonic tones when bell first struck. Only really sounds like
a bell in upper register, in low register sounds like some sort of gamelan
instrument or gong. 

To use: set the frequency first, which should probably be kept constant, with
SetFreq, then at a high rate set the "gain" with SetGain which controls not
just the gain but also the tone of the sound corresponding to each volume level,
so for a simple bell hit sound, just set gain according to an exponential decay.
Other effects are also possible. To change actual gain (master volume, or velocity)
use SetMasterGain */
class BellSound {
    SinOsc harmonics[12];
    Gain harmEnv => LPF harmLPF => Gain master => NRev rev => dac;
    TriOsc hitMod => SinOsc hitCar => Gain hitEnv => HPF hitHPF => master;
    
    0.1 => master.gain;
    220 => float freq;
    500 => harmLPF.freq;
    1 => harmLPF.Q; 
    0.7 => harmLPF.gain;
    
    300 => hitMod.gain;
    0 => hitEnv.gain;
    2 => hitCar.sync;
    5 => hitHPF.Q;
    1 => hitHPF.gain;
    
    0.1 => rev.mix;
    
    [0.6,  0.998, 1.002, 1.992, 2.008, 3.03, 4.1, 5.2, 6.4, 7.9, 9.1, 10.5] @=> float harmFreqs[];  
    [0.05, 1.0,   0.2,   0.7,   0.1,   0.5,  0.4, 0.3, 0.3, 0.2, 0.2, 0.2 ] @=> float harmGains[];
    for (0 => int i; i < harmonics.cap(); i++) {
        harmGains[i] => harmonics[i].gain;
        harmonics[i] => harmEnv;
    }
    SetFreq(this.freq);   
    
    
    fun void SetFreq(float freq) {
        freq => this.freq;
        for (0 => int i; i < harmonics.cap(); i++) {
            freq * harmFreqs[i] => harmonics[i].freq;
        }
        freq => hitCar.freq;
        freq * Std.rand2f(1.55, 1.9) => hitMod.freq;
        freq * 2 => hitHPF.freq;
    }
    
    fun void SetGain(float gain) {
        gain => harmEnv.gain;
        MapValueClamp(gain, 0.5, 1, 0, 1, 1.5) => hitEnv.gain;
        MapValueClamp(gain, 0.1, 1, this.freq+300, 10000, 1) => harmLPF.freq;                          
    }
    
    fun void SetMasterGain(float mastergain) {
        mastergain => master.gain;
    }
}        
                                        

/// KEYBOARD WATCHER ///

/* Keyboard watcher shred using Hid */
fun void KeyboardWatcher() {
    Hid hi;
    HidMsg msg;
    hi.openKeyboard(0);
    while (true) {
        hi => now;
        while (hi.recv(msg)) {
            if (msg.isButtonDown()) {
                KeyPress(msg.ascii);
            }
        }
    }
}

/* Returns true if key is the ascii value of spacebar */ 
fun int IsSpace(int key) { 
    return (key == 32);
}

fun void KeyPress(int key) {
    if (IsSpace(key)) {
        spork ~ RingBell(std.mtof(std.rand2(40, 80)));          
    }
}                                              


/// BELL RINGING SHRED ///

/* Creates sound of ringing bell by creating BellSound object, then
continually ramping down the "gain" value exponentially (values
calculated by ExpDecay shred). Other bell-playing effects can be created
by ramping the gain value with SetGain in different ways (perhaps slow
increase with then exponential decay, which might give a zing effect, or
continually holding gain at a certain point for a continuous ring) */ 
fun void RingBell(float freq) {
    //SawSound s; // for debugging, also simple usage of interface used for BellSound
    BellSound s;
    s.SetFreq(freq);
    Gain g;
    spork ~ ExpDecay(g);
    while (g.gain() > 0) {
        s.SetGain(g.gain());
        1::ms => now;
    }
    2::second => now; // grace period for reverb tail
}

/* Exponentially decays the gain value of a gain object passed by reference.
There's not a good reason the code was designed this way and perhaps it
should be refactored. Decay time is just over 2.5 seconds, will sound longer with
reverb */
fun void ExpDecay(Gain g) {
    now => time startTime;
    while (true) {
        (now - startTime) / second => float t;
        Math.max(Math.exp(-1.8*t) - 0.01, 0) => g.gain;
        1::ms => now;
    }
}

/* Maps an input value in a given range to a given output range, linearly
interpolating if pow == 1, otherwise interpolating along curve x^pow when
input range mapped to [0, 1] */
fun float MapValueClamp(float in, float inMin, float inMax, float outMin, float outMax, float pow) {
    (in - inMin) / (inMax - inMin) => float val;
    if (val > 1) 1 => val;
    else if (val < 0) 0 => val;
    Math.pow(val, pow) => val;
    return (val * (outMax - outMin)) + outMin;
}


/// PROGRAM EXECUTION ///

spork ~ KeyboardWatcher();
while (true) {
    1::second => now; 
}
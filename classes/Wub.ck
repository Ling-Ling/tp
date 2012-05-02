//
//  Wub.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//

/**  Wub wub wub */
public class Wub
{
    //
    //  Audio patch
    //

    // TODO? subclass UGen
    SawOsc m_sawOsc => ResonZ m_res => Envelope m_env => NRev m_rev => dac;
    m_env => Delay m_delay => m_rev;
    m_delay => Gain m_feedback => m_delay;


    //
    //  Parameters
    //

    Parameters m_params;

    // on/off
    m_params.setInt("play", 0);
    m_params.setIntRange("play", 0, 1);

            /*
    spork ~ _playLoop();
    fun void _playLoop()
    {
        m_params.getNewIntEvent("play") @=> IntEvent e;
        while (1)
        {
            e => now;
            
            m_params.getFloat("gain") => m_sawOsc.gain;
            m_params.getFloat("feedbackGain") => m_feedback.gain;
            m_params.getFloat("reverbMix") => m_rev.mix;

            m_params.getInt("envDur")::ms => m_env.duration;
            m_params.getInt("delayDur")::ms => m_delay.delay;

            Std.mtof(e.i) => float freq;
            freq => m_sawOsc.freq;

            freq * m_params.getFloat("resFreq") => m_res.freq;
            m_params.getFloat("resQ") => m_res.Q;

            <<< e.i >>>;

            if (e.i)
                m_env.keyOn();
            else
                m_env.keyOff();
        }
    }
*/

    // MIDI note
    m_params.setFloat("midiNote", 25);
    m_params.setFloatRange("midiNote", 0, 50);

    spork ~ _midiNoteLoop();
    fun void _midiNoteLoop()
    {
        m_params.getNewIntEvent("midiNote") @=> IntEvent e;
        while (1)
        {
            Std.mtof(e.i) => float freq;
            freq => m_sawOsc.freq;

            e => now;
        }
    }

    // gain
    m_params.setFloat("gain", .001);
    m_params.setFloatRange("gain", 0, .05);
/*
    spork ~ _gainLoop();
    fun void _gainLoop()
    {
        m_params.getNewFloatEvent("gain") @=> FloatEvent f;
        while (1)
        {*/
            
    
    // feedback gain
    m_params.setFloat("feedbackGain", 0);
    m_params.setFloatRange("feedbackGain", 0., .8);

    // reverb mix
    m_params.setFloat("reverbMix", .01);
    m_params.setFloatRange("reverbMix", 0., .1);

    // delay duration
    m_params.setInt("delayDur", 750);
    m_params.setIntRange("delayDur", 500, 750);
    m_params.m_iMaxs["delayDur"]::second => m_delay.max; 

    // envelope duration
    m_params.setInt("envDur", 50);
    m_params.setIntRange("envDur", 0, 200);

    // key on duration
    m_params.setInt("keyOnDur", 50);
    m_params.setIntRange("keyOnDur", 0, 200);

    // key off duration
    m_params.setInt("keyOffDur", 400);
    m_params.setIntRange("keyOffDur", 0, 1000);

    // res Q
    m_params.setFloat("resQ", .1);
    m_params.setFloatRange("resQ", .1, 1);

    // res freq
    m_params.setFloat("resFreq", .1);
    m_params.setFloatRange("resFreq", .1, 15);

}

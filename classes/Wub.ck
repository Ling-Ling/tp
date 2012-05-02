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

    SawOsc m_sawOsc;
    ResonZ m_res;
    Envelope m_env;
    NRev m_rev;

    m_sawOsc => m_res => m_env => m_rev => dac;

    Delay m_delay;
    m_env => m_delay => m_rev;

    Gain m_feedback;
    m_delay => m_feedback => m_delay;


    //
    //  Parameters
    //

    Parameters m_params;

    // on/off
    m_params.setInt("play", 0);
    m_params.setIntRange("play", 0, 1);

    spork ~ _playLoop();
    fun void _playLoop()
    {
        m_params.getNewIntEvent("play") @=> IntEvent e;
        while (1)
        {
            e => now;
            
            Std.mtof(m_params.getFloat("midiNote")) => float freq;
            freq => m_sawOsc.freq;

            freq * m_params.getFloat("resFreq") => m_res.freq;
            m_params.getFloat("resQ") => m_res.Q;

            m_params.getInt("envDur")::ms => m_env.duration;

            m_params.getFloat("reverbMix") => m_rev.mix;

            m_params.getInt("delayDur")::ms => m_delay.delay;

            m_params.getFloat("feedbackGain") => m_feedback.gain;

            m_params.getFloat("gain") => m_sawOsc.gain;

            if (e.i == 1)
            {
                m_env.keyOn();
                m_params.getInt("dur")::ms => now;
                m_env.keyOff();
            }
            else
            {
                m_env.keyOff();
            }
        }
    }

    // note duration
    m_params.setInt("dur", 200);
    m_params.setIntRange("dur", 100, 500);

    // MIDI note
    m_params.setFloat("midiNote", 30);
    m_params.setFloatRange("midiNote", 0, 50);

    // gain
    m_params.setFloat("gain", .1);
    m_params.setFloatRange("gain", 0, .5);
    
    // feedback gain
    m_params.setFloat("feedbackGain", .5);
    m_params.setFloatRange("feedbackGain", 0., .8);

    // reverb mix
    m_params.setFloat("reverbMix", .05);
    m_params.setFloatRange("reverbMix", 0., .2);

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

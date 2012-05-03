//
//  Wub.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)

/**  Wub wub wub */
public class Wub
{
    //
    //  Audio patch

    // TODO? subclass UGen

    SawOsc m_sawOsc;
    ResonZ m_res;
    Envelope m_env;
    NRev m_rev;
    Gain m_gain;
    Dyno m_dyno;
    m_dyno.compress();

    // doesn't work? =(
    //m_sawOsc => m_res => m_env => m_rev => m_gain @=> TP.forMy().bunghole;

    for (0 => int i; i < TP.NUM_CHANNELS; i++)
        m_sawOsc => m_res => m_env => m_rev => m_gain => dac.chan(i);

    Delay m_delay;
    m_env => m_delay => m_rev;

    Gain m_feedback;
    m_delay => m_feedback => m_delay;


    Parameters m_params;

    fun void pause()
    {
        m_env.keyOff();
        1::second => now;
        m_params.setFloat("gain", 0); 
        m_env.keyOn();
    }

    //
    //  Parameters

    
    spork ~ _paramLoop();
    fun void _paramLoop()
    {
        m_params.m_event @=> StringEvent e;

        while (1)
        {
            _updatePatchParams();

            e => now;
        }
    }
    
    fun void _updatePatchParams()
    {
        Std.mtof(m_params.getInt("midiNote")) => float freq;
        freq => m_sawOsc.freq;

        freq * m_params.getFloat("resFreq") => m_res.freq;
        m_params.getFloat("resQ") => m_res.Q;

        m_params.getInt("envDur")::ms => m_env.duration;

        m_params.getFloat("reverbMix") => m_rev.mix;

        m_params.getInt("delayDur")::ms => m_delay.delay;

        m_params.getFloat("feedbackGain") => m_feedback.gain;

        m_params.getFloat("gain") => m_sawOsc.gain;

        m_params.getFloat("masterGain") => m_gain.gain;
    }

    m_env.keyOn();

    // on/off
    //m_params.setInt("play", 0);
    //m_params.setIntRange("play", 0, 1);

    // note duration
    //m_params.setInt("dur", 200);
    //m_params.setIntRange("dur", 100, 500);

    // MIDI note
    m_params.setFloat("midiNote", 30);
    m_params.setFloatRange("midiNote", 0, 50);

    // gain
    m_params.setFloat("gain", 0);
    m_params.setFloatRange("gain", 0, .5);
    now => time m_lastGainUpdate;
    
    /*
    spork ~ _gainLoop();
    fun void _gainLoop()
    {
        m_params.getNewFloatEvent("gain") @=> FloatEvent e;

        while (1)
        {
            e => now;

            _updatePatchParams();

            if (e.f != m_sawOsc.gain())
                now => m_lastGainUpdate;
        }
    }
    */

    spork ~ _gainEnvLoop();
    fun void _gainEnvLoop()
    {
        while (1)
        {
            2::second => now;

            if (now - m_lastGainUpdate > 1::second)
            {
                pause();
            }
        }
    }

    // master gain
    /*
    m_params.setFloat("masterGain", 1.);
    m_params.setFloatRange("masterGain", 0, .5);

    spork ~ _masterGainLoop();
    fun void _masterGainLoop()
    {
        m_params.getNewFloatEvent("masterGain") @=> FloatEvent e;

        while (1)
        {
            e => now;
            m_gain.gain(e.f);
        }
    }
    */

    // feedback gain
    m_params.setFloat("feedbackGain", 0);
    m_params.setFloatRange("feedbackGain", 0., .4);

    // reverb mix
    m_params.setFloat("reverbMix", .00);
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

//
//   DrumPad.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class DrumPad 
{

    //
    //  Sample banks
    // 

    [
        "data/kick.wav",
        "data/snare.wav"
    ] 
    @=> string m_hitSamples[];

    [
        "data/hihat.wav",
        "data/snare.wav"
    ] 
    @=> string m_beatSamples[];

    [
        "data/hihat-open.wav", 
        ""
    ] 
    @=> string m_mixBeatSamples[];


    //
    //  Parameters
    // 

    Parameters m_params;

    // ints
    m_params.setInt("beatNum", 0);
    m_params.setInt("hit", 0);
    m_params.setInt("sample_set", 0);

    // floats
    m_params.setFloat("gain", 1.);
    m_params.setFloat("freq", 0.);
    m_params.setFloat("openness", 0.);


    Event m_hitEvent;

    spork ~ _hitLoop();
    fun void _hitLoop()
    {
        while (1)
        {
            m_hitEvent => now;

            m_hitSamples[m_params.getInt("sample_set")] @=> string hitSample;

            if (m_params.getInt("hit"))
                XD.playSampleWithGain(hitSample, 1.);
        }
    }


    m_params.getNewIntEvent("beatNum") @=> Event m_beatEvent;

    spork ~ _beatLoop();
    fun void _beatLoop()
    {
        while (1)
        {
            m_beatEvent => now;

            m_params.getInt("beatNum") => int beatNum;
            m_params.getFloat("openness") => float openness;

            m_beatSamples[m_params.getInt("sample_set")] @=> string beatSample;
            m_mixBeatSamples[m_params.getInt("sample_set")] @=> string mixBeatSample;

            XD.playSampleWithGain(beatSample, 1. * (1. - openness));

            if (mixBeatSample != "")
                XD.playSampleWithGain(mixBeatSample, 1. * openness);
        }
    }


    //
    //  TrackPad
    // 

/*
    fun void setTrackPad(TrackPad trackPad)
    {
//        spork ~ __mouseClickLoop(trackPad.m_params);
    
        //spork ~ m_params.bindFloatShred("gain", trackPad.m_params, "pinch_distance");
    }

    fun void __mouseClickLoop(Parameters tpParams)
    {
        while (1)
        {
            if (tpParams.getNextInt("mouse_click"))
                XD.playSampleWithGain("data/kick.wav", m_params.getFloat("gain"));
        }        
    }


    // 
    //  OSC 
    //


    fun void setOscRecv(OscParamRecv oscRecv)
    {
        spork ~ __oscBeatLoop(oscRecv.m_params);
    
        //spork ~ oscRecv.m_params.logIntShred("beat");
        //spork ~ oscRecv.m_params.logIntShred("note");
        //spork ~ oscRecv.m_params.logFloatShred("gain");

    }

    fun void __oscBeatLoop(Parameters oscParams)
    {
        while (1)
        {
            oscParams.getNextInt("beatNum") => int beatNum;
            <<< beatNum >>>;
            m_params.getInt("sound") => int sound;

            if (sound == 0 )
            {
                m_params.getFloat("openness") => float openness;
                XD.playSampleWithGain("data/hihat.wav", 1. * (1. - openness));
                XD.playSampleWithGain("data/hihat-open.wav", 1. * openness);
            }
            else if (sound == 1)
            {
                m_params.getFloat("openness") => float openness;
                XD.playSampleWithGain("data/snare.wav", 1. * (1. - openness));
            }
        }
    }
    */
    
}

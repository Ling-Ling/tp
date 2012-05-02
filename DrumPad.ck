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


    m_params.getNewIntEvent("hit") @=> Event m_hitEvent;

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
}

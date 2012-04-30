//
//  DrumPad.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class DrumPad extends TrackPad
{
    0. => float m_frequency;
    0. => float m_openness;

    fun void _handleMouseClickDown()
    {
        XD.playSample("data/kick.wav");
    }

    fun void playNoteAtBeatWithGain(int note, int beat, float gain)
    {
        if (Std.fabs(Std.randf()) < m_frequency)
        {
            XD.playSampleWithGain("data/hihat.wav", 1. * (1. - m_openness));
            XD.playSampleWithGain("data/hihat-open.wav", 1. * m_openness);
        }
    }

    fun void _handleTouch(HidMsg msg)
    {
        msg.touchX => m_frequency;
        msg.touchY => m_openness;
    }
    
}

<<< "Loaded", "DrumPad.ck" >>>;

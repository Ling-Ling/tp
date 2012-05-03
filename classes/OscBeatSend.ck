//
//  OscBeatSend.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


public class OscBeatSend extends OscParamSend
{
    m_params.setInt("beatNum", 0);
    m_params.setInt("barLength", 8);
    m_params.setInt("ticksPerBeat", 4);
    m_params.setInt("bpm", 110);

    m_params.setFloat("swing", .2);

    fun void beatLoopShred()
    {
        this.setHost(MULTIPLEX_IP_ADDRESS, m_port);

        spork ~ sendIntShred("beatNum");

        while (1)
        {
            m_params.getInt("beatNum") => int beatNum;
            m_params.getInt("barLength") => int barLength;
            m_params.getInt("bpm") => int bpm;
            m_params.getInt("ticksPerBeat") => int ticksPerBeat;
            m_params.getFloat("swing") => float swing;

            // increment beat number
            m_params.setInt("beatNum", (beatNum + 1) % barLength);

            // calculate duration
            1::minute / (bpm * ticksPerBeat) => dur duration;

            // compensate for swing
            if (beatNum % 2 == 0)
                duration * (1 - (swing / 4.)) => duration;
            else
                duration / (1 - (swing / 4.)) => duration;

            // wait
            duration => now;
        }
    }
}

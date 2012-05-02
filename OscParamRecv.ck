//
//  OscParamRecv.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


public class OscParamRecv extends OscRecv
{
    Parameters m_params;

    fun static int oscRecvInt(OscEvent oscEvent)
    {
        int returnVal;
        oscEvent => now;

        while (oscEvent.nextMsg())
            oscEvent.getInt() => returnVal;

        return returnVal;
    }

    fun static float oscRecvFloat(OscEvent oscEvent)
    {
        float returnVal;
        oscEvent => now;

        while (oscEvent.nextMsg())
            oscEvent.getFloat() => returnVal;

        return returnVal;
    }

    fun void oscRecvIntLoop(OscEvent oscEvent, string key)
    {
        while (1)
            m_params.setInt(key, OscParamRecv.oscRecvInt(oscEvent));
    }

    fun void oscRecvFloatLoop(OscEvent oscEvent, string key)
    {
        while (1)
            m_params.setFloat(key, OscParamRecv.oscRecvFloat(oscEvent));
    }


    fun OscParamRecv initPort(int port)
    {
        port => this.port;
        this.listen();
        
        return this;
    }

    fun void listenForInt(string key)
    {
        spork ~ oscRecvIntLoop(this.event("/" + key, "i"), key);
    }
        
    fun void listenForFloat(string key)
    {
        spork ~ oscRecvFloatLoop(this.event("/" + key, "f"), key);
    }
}

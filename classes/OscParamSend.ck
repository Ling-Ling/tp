//
//  OscParamSend.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//



public class OscParamSend extends OscSend
{
    "224.0.0.1" @=> string MULTIPLEX_IP_ADDRESS;

    Parameters m_params;
    
    int m_port;

    fun OscParamSend initPort(int port)
    {
        port => m_port; 
        this.setHost(MULTIPLEX_IP_ADDRESS, m_port);
        return this;
    }
   
    fun void sendIntShred(string key)
    {
        m_params.getNewIntEvent(key) @=> Event event;

        while (1)
        {
            event => now;

            this.startMsg("/" + key, "i");
            this.addInt(m_params.getInt(key));
        }
    }

    fun void sendFloatShred(string key)
    {
        m_params.getNewFloatEvent(key) @=> Event event;

        while (1)
        {
            event => now;

            this.startMsg("/" + key, "f");
            this.addFloat(m_params.getFloat(key));
        }
    }
}


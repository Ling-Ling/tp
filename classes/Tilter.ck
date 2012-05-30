

public class Tilter
{
    

    Parameters m_params;

    Hid m_hid;
    HidMsg m_msg;

    fun Tilter initTilter()
    {
	if (!m_hid.openTiltSensor())
	    return NULL;
	
	spork ~ __tiltLoop();

	return this;        
    }

    fun void __tiltLoop()
    {
    	m_msg.x => int lastx;
    	m_msg.y => int lasty;
	100.0 => float threshold;

	while(1)
	{
	    <<<"tilt x ", m_msg.x, " tilt y ", m_msg.y>>>;
	    100::ms => now;
	    m_hid.read(9,0,m_msg);
	    if (m_msg.x + m_msg.y > threshold) {
	    	m_params.setInt("tilt", 1);
	    }
	    else {
		m_params.setInt("tilt", 0);
	    }
	}
    }
}

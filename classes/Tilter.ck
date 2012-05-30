

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
	    100::ms => now;
	    if (m_msg.x + m_msg.y > threshold) {
	    	m_params.setInt("tilt", 1);
	    }
	    else {
		m_params.setInt("tilt", 0);
	    }
	}
    }
}

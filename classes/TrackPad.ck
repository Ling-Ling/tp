//
//   TrackPad.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class TrackPad
{
    //
    //  static constants:
    //

    static int MAX_NUM_TRACKPADS;
    static int MAX_NUM_TOUCHES;


    fun static TrackPad[] getTPs()
    {
        // get command line trackpad numbers
        int TRACKPAD_NUM[me.args()];
        for (int i; i < me.args(); i++)
            Std.atoi(me.arg(i)) => TRACKPAD_NUM[i];

        TrackPad @ tps[Math.min(me.args(), TrackPad.MAX_NUM_TRACKPADS) $ int];

        for (0 => int i; i < tps.size(); i++)
        {
            TrackPad tp;
            tp.initTrackPad(TRACKPAD_NUM[i]) @=> tps[i];
            
            if (tp == NULL)
                <<< "[x_x] error initializing trackpad", i >>>;
        }

        return tps;
    }

    fun static void initTrackPads(TrackPad tps[])
    {
        // init as many trackpad touch handlers as possible
        for (0 => int i; i < tps.size(); i++)
        {
            if (tps[i] == NULL)
                // generic TrackPad for debugging
                TrackPad tp @=> tps[i];

            tps[i].initTrackPad(i);
            
            // failed init
            if (tps[i] == NULL)
                break;
        }

        <<< "[tp] initialized", TrackPad.n_trackPads, "trackpads" >>>;
    }


    //
    //  static variables:
    //
    
    static int n_trackPads;


    //
    //  instance variables:
    //

    // events
    Parameters m_params;


    int m_nTrackPad;
    Hid m_trackPad;
    HidMsg m_msgs[MAX_NUM_TOUCHES];
    
    float m_AreaBetweenThreeOrMoreTouches;
    int m_nTouches;
    time lastTouch; 

    /**  
     *  Main touch loop initializer
     *
     *  @param n track pad device index
     */
    fun TrackPad initTrackPad(int n) 
    {
        if (!m_trackPad.open(MAX_NUM_TOUCHES, n))
            return NULL;

        n => m_nTrackPad;

        TrackPad.n_trackPads++;

        spork ~ __trackPadTouchLoop();

        return this;
    }
    
    0.0 => float lastTouchSize;
    now => time firstTouch;
    now => lastTouch;
    false => int touchIsDown;

    /**  Main track pad touch loop */
    fun void __trackPadTouchLoop()
    {
        while (1)
        {
            m_trackPad => now;
            if (m_trackPad.recv(m_msgs[0]))
            {
                int n;
                m_msgs[0].which => int lastTouchNum;

                for (1 => n; n < MAX_NUM_TOUCHES; n++)
                {
                    m_params.setFloat("x", m_msgs[n - 1].touchX); 
                    m_params.setFloat("y", m_msgs[n - 1].touchY); 
                  
                    m_params.setFloat("size", m_msgs[n - 1].touchSize); 
                    
                    

                    m_params.setFloat("touch" + (n - 1) + "x", m_msgs[n - 1].touchX); 
                    m_params.setFloat("touch" + (n - 1) + "y", m_msgs[n - 1].touchY); 
                    m_params.setFloat("touch" + (n - 1) + "size", m_msgs[n - 1].touchSize); 

                    m_params.setFloat("deltaX", m_msgs[n-1].deltaX);

                    if (!m_trackPad.recv(m_msgs[n]) || m_msgs[n].which == lastTouchNum)
                        break;
                    else 
                        m_msgs[n].which => lastTouchNum;
                }
                <<<"touch y ", m_msgs[n-1].touchSize>>>;
                    
                if(m_msgs[0].touchSize == 0.0){
                    if (now - lastTouch < 50::ms) {
                        false => touchIsDown;
                        m_params.setFloat("tap", m_msgs[0].touchY);
                    }
                    else {
                        m_params.setFloat("tap", 0.);
                    }
                    m_params.setFloat("onTouch", 0.);
                    m_msgs[0].touchSize => lastTouchSize;
                }else{
                    now => lastTouch;
                    m_params.setFloat("tap", 0.);
                    if (lastTouchSize == 0.0) {
                        now => firstTouch;
                    }
                    if (now - firstTouch > 50::ms) {
                        m_params.setFloat("onTouch", m_msgs[0].touchY);
                        true => touchIsDown;
                    }
                    m_msgs[0].touchSize => lastTouchSize;
                }
                
                m_params.setInt("num_touches", n);
                //<<<"about to enter num touches">>>;
                //flick or tap if one touch
		if (n == 1) {
                    //<<<"one touch">>>;
                    if (m_msgs[0].deltaY > .2){
                        //<<<"in trackpad flicking">>>;
                        m_params.setFloat("flick_distance", m_msgs[0].deltaX);
                        //m_params.setFloat("tap", m_msgs[0].touchY);
			//lastTouch - 2::second => lastTouch;
		    }else{
                        //<<<"in trackpad tapping">>>; 
		        //m_params.setFloat("tap", m_msgs[0].touchY);
                    }
		}
                // pinch distance between first two touches
		if (n == 2)
                    m_params.setFloat("pinch_distance", Math.sqrt(Math.pow(m_msgs[0].touchX - m_msgs[1].touchX, 2) + Math.pow(m_msgs[0].touchY - m_msgs[1].touchY, 2)));
                else
                    m_params.setFloat("pinch_distance", 0.);
            }
        }
    }
}

// Initialize static variables 
5 => TrackPad.MAX_NUM_TRACKPADS;
7 => TrackPad.MAX_NUM_TOUCHES;

0 => TrackPad.n_trackPads;

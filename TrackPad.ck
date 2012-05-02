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


    fun static void initTrackPads(TrackPad tps[])
    {
        // init as many trackpad touch handlers as possible
        for (0 => int i; i < tps.size(); i++)
        {
            if (tps[i] == NULL)
                // generic TrackPad for debugging
                TrackPad tp @=> tps[i];

            tps[i].initTrackPad(i) @=> tps[i];
            
            // failed init
            if (tps[i] == NULL)
                break;
        }

        <<< "[tp] initialized", TrackPad.n_trackPads, "trackpads" >>>;

        // init mouse click handlers on all initialized trackpads
        for (0 => int i; i < TrackPad.n_trackPads; i++)
        {
            if (tps[i].initMouse() == NULL)
                <<< "[tp] error initializing mouse on trackpad ", i >>>;
            else 
                <<< "[tp] initialized mouse on trackpad", i >>>;
        }
    }


    //
    //  static variables:
    //
    
    // this counter is currently essential to openning the correct mouse device for click events, due to the arbitrary mapping
    // TODO: find a better workaround
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
    
    Hid m_mouse;
    

    //
    //  virtual methods:
    //

    fun void playNoteAtBeatWithGain(int note, int beat, float gain)
    {
        //<<< note, beat, gain >>>;
    }

    fun void _handleTouch(HidMsg msg) 
    {
        if (m_nTouches == 5 && msg == m_msgs[4])
            <<< "[tp] trackpad", m_nTrackPad >>>;
        /*
        <<< "(", msg.touchX, msg.touchY, ")", msg.touchSize >>>;
        */
    }


    //
    //  public methods:
    //

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

    /**  
     *  Mouse click loop initializer
     */
    fun TrackPad initMouse()
    {
        if (!m_mouse.openMouse(2))
            return NULL;

        spork ~ __mouseClickLoop();

        return this;
    }

    /**  Main mouse click loop */
    fun void __mouseClickLoop()
    {
        while (1)
        {
            HidMsg msg;
            m_mouse => now;

            while (m_mouse.recv(msg))
            {
                if (msg.isButtonDown())
                    m_params.setInt("mouse_click", 1);

                else if (msg.isButtonUp())
                    m_params.setInt("mouse_click", 0);
            }
        }
    }

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

                    if (!m_trackPad.recv(m_msgs[n]) || m_msgs[n].which == lastTouchNum)
                        break;
                    else 
                        m_msgs[n].which => lastTouchNum;
                }

                m_params.setInt("num_touches", n);
                
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

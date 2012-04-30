//
//  TrackPad.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


public class TrackPad
{
    //
    // static constants:
    //

    static int MAX_NUM_TRACKPADS;
    static int MAX_NUM_TOUCHES;


    //
    // static variables:
    //
    
    // TrackPad counter is currently essential to openning the correct mouse device for click events. 
    // TODO: find a better workaround
    0 => static int n_trackPads;


    //
    // instance variables:
    //

    int m_nTrackPad;
    Hid m_trackPad;
    HidMsg m_msgs[MAX_NUM_TOUCHES];
    
    float m_distanceBetweenTwoTouches;
    float m_AreaBetweenThreeOrMoreTouches;
    int m_nTouches;
    
    Hid m_mouse;
    

    //
    // public/private virtual methods:
    //

    fun void playNoteAtBeatWithGain(int note, int beat, float gain)
    {
        //<<< note, beat, gain >>>;
    }

    fun void _handleTouch(HidMsg msg) 
    {
        /*
        <<< "(", msg.touchX, msg.touchY, ")", msg.touchSize >>>;
        */
    }

    fun void _handleDistanceBetweenTwoTouches()
    {
        /*
        if (m_distanceBetweenTwoTouches > 0)
            <<< "TrackPad", m_nTrackPad, m_distanceBetweenTwoTouches, "between two touches" >>>;
        */
    }

    fun void _handleMouseClickDown()
    {
        /*
        <<< "TrackPad", m_nTrackPad, "click down" >>>;
        */
    }

    fun void _handleMouseClickUp()
    {
        /*
        <<< "TrackPad", m_nTrackPad, "click up" >>>;
        */
    }


    //
    // public methods:
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
     *  ALL available TrackPads must be opened via initTrackPad before calling initMouse 
     */
    fun TrackPad initMouse()
    {
        if (!m_mouse.openMouse(__mouseDeviceIndex()))
            return NULL;

        spork ~ __mouseClickLoop();

        return this;
    }


    //
    // protected methods:
    //

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
                    _handleMouseClickDown();

                else if (msg.isButtonUp())
                    _handleMouseClickUp();
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
                m_msgs[0].which => int lastTouchNum;

                // calc number of active touches
                for (1 => m_nTouches; m_nTouches < MAX_NUM_TOUCHES; m_nTouches++)
                    if (!m_trackPad.recv(m_msgs[m_nTouches]) || m_msgs[m_nTouches].which == lastTouchNum)
                        break;
                    else 
                        m_msgs[m_nTouches].which => lastTouchNum;
                
                // calc dist between two touches
                if (m_nTouches == 2)
                    Math.sqrt(Math.pow(m_msgs[0].touchX - m_msgs[1].touchX, 2) + Math.pow(m_msgs[0].touchY - m_msgs[1].touchY, 2)) => m_distanceBetweenTwoTouches;
                else
                    0 => m_distanceBetweenTwoTouches;
                
                // calc area of the convex polygon containing three or more touches
                if (m_nTouches > 3)
                    __grahamScan();
                
                
                // handle all events
                
                _handleDistanceBetweenTwoTouches();
                
                for (0 => int i; i < m_nTouches; i++)
                    _handleTouch(m_msgs[i]);
            }
        }
    }
    
    fun int __mouseDeviceIndex()
    {
        // WIP: seemingly arbitrary mapping between track pad and mouse device indices
        // Alternatively, could have user click each track pad in order to setup/init
        [[2, 0], 
         [3, 1, 0],
         [4, 2, 1, 0]
        ] @=> int trackPadToMouseDeviceIndexMapping[][];

        return trackPadToMouseDeviceIndexMapping[n_trackPads - 1][m_nTrackPad]; 
    }

    /** 
     *  Graham scan implementation calculates the area of the convex hull containing three or more touches
     *  see http://en.wikipedia.org/wiki/Graham_scan
     */ 
    fun float __grahamScan()
    {
        // TODO
    }
    
    /** 
     *  Graham scan helper method
     *  Three points are a counter-clockwise turn if ccw > 0, clockwise if
     *  ccw < 0, and collinear if ccw = 0 because ccw is a determinant that
     *  gives the signed area of the triangle formed by p1, p2 and p3.
     */
    fun float __ccw(HidMsg p1, HidMsg p2, HidMsg p3)
    {
        return (p2.touchX - p1.touchX) * (p3.touchY - p1.touchY) - (p2.touchY - p1.touchY) * (p3.touchX - p1.touchX);
    }
}

// Initialize static variables 
5 => TrackPad.MAX_NUM_TRACKPADS;
7 => TrackPad.MAX_NUM_TOUCHES;

<<< "Loaded", "TrackPad.ck" >>>;

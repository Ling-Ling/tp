//
//  OscScaleSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


public class OscScaleAndBeatSend extends OscParamSend
{
    ParamIntPattern m_notePattern;
    ParamIntPattern m_modePattern;
    ["a","b","c", "d","e","f","g","h","i","j","k","l","m",
    "n","o","p","q","r","s","t","u","v","w","x","y","z"]
    @=>string alphabet[];
        
    0 => int m_nFreq;

    fun void freqLoopShred(int nFreq)
    {
        nFreq => m_nFreq;

        for (0 => int i; i < nFreq; i++)
            spork ~ sendIntShred("freq" + alphabet[i]);
        
        while (1)
            1::day => now;
    }

    fun void _sendFreqs()
    {
        //change back for this to be dynamic
        //m_modePattern.m_params.getInt("value") => int mode;
        //m_notePattern.m_params.getInt("value") => int base;

        //first scale type
        0 => int mode;
        //start note
        53 => int base;

        int frequency[m_nFreq];
        XD.createScale(base, mode, frequency.size()) @=> frequency;

       for (0 => int i; i < frequency.size(); i++){
           m_params.setInt("freq" + alphabet[i], frequency[i]);
       }
       //<<<"sent",frequency.size(), "frequencies">>>;
    }

    //remove this when chord change is controlled
    spork ~ _repeaterLoop();
    fun void _repeaterLoop()
    {  
        while (1)
        {
            1::second => now;
            _sendFreqs();
        }
    }
    //
    
    spork ~ _noteLoop();
    fun void _noteLoop()
    {
        m_notePattern.m_params.getNewIntEvent("value") @=> IntEvent e;

        while (1)
        {
            e => now;
            _sendFreqs();
        }
    }

    spork ~ _modeLoop();
    fun void _modeLoop()
    {
        m_modePattern.m_params.getNewIntEvent("value") @=> IntEvent e;

        while (1)
        {
            e => now;
            _sendFreqs();
        }
    }
    
    
    ///////////////////
    ////   Beats   ////
    ///////////////////

    0 => int curBeat;
    false => int shouldSendBeats;
    450 => int milliBeats;
    
    
    fun void handleKeyboard(){
        // the device number to open
        0 => int deviceNum;
        
        // instantiate a HidIn object
        HidIn hi;
        // structure to hold HID messages
        HidMsg msg;
        
        // open keyboard
        if( !hi.openKeyboard( deviceNum ) ) me.exit();
        // successful! print name of device
        <<< "keyboard '", hi.name(), "' ready" >>>;
        
        // infinite event loop
        while( true )
        {
            // wait on event
            hi => now;
            
            // get one or more messages
            while( hi.recv( msg ) )
            {
                // check for action type
                if( msg.isButtonDown() )
                {
                    msg.which => int char;
                 <<<char>>>;
                 if(char == 44) //space
                     !shouldSendBeats => shouldSendBeats;
                 else if(char == 21) //r
                     0 => curBeat;
             }
            }
        }
    }
    
    fun void sendBeats(){
        spork ~ sendIntShred("beat");
        spork ~ sendIntShred("duration");
        spork ~ _beatLoop();
    }
    
    fun void _beatLoop()
    {  
        while (1)
        {
            milliBeats::ms => now;
            <<<"beat ", curBeat>>>;
            m_params.setInt("beat",curBeat);
            m_params.setInt("duration",milliBeats);
            if(shouldSendBeats)
                curBeat++;
        }
    }

}

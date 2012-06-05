//
//  OscScaleSend.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


public class OscScaleAndBeatSend extends OscParamSend
{
    int frequencySets[][];
    int frequencyChangeLocations[];
    0 => int curFrequencySet;
    
    0 => int curBeat;
    false => int shouldSendBeats;
    450 => int milliBeats;
    
    ["a","b","c", "d","e","f","g","h","i","j","k","l","m",
    "n","o","p","q","r","s","t","u","v","w","x","y","z"]
    @=>string alphabet[];

    ///////////////////
    ////   Freqs   ////
    ///////////////////
    
    OscParamSend freqSender;
    
    fun void scaleSendingPort(int port){
        freqSender.initPort(port);
    }
    
    fun void setFrequencySets(int fsets[][]){
        fsets @=> frequencySets;
    }
    
    fun void setFrequencyChangeLocations(int flocs[]){
        flocs @=> frequencyChangeLocations;
    }

    fun void freqLoopShred(int nFreq)
    {

        for (0 => int i; i < nFreq; i++)
            spork ~ freqSender.sendIntShred("freq" + alphabet[i]);
        
        while (1)
            1::day => now;
    }

    fun void _sendFreqs()
    {
        false => int shouldSend;
        for (0 => int i; i < frequencyChangeLocations.size(); i++){
            if(curBeat == frequencyChangeLocations[i]){
                i => curFrequencySet;
                true => shouldSend;
            }
        }

       if(shouldSend){
          for (0 => int i; i < frequencySets[curFrequencySet].size(); i++){
               freqSender.m_params.setInt("freq" + alphabet[i], frequencySets[curFrequencySet][i]);
           }
       }
    }

    spork ~ _repeaterLoop();
    fun void _repeaterLoop()
    {  
        while (1)
        {
            milliBeats::ms => now;
            _sendFreqs();
        }
    }
    
    ///////////////////
    ////   Beats   ////
    ///////////////////
    OscParamSend beatSender;
    
    fun void beatSendingPort(int port){
        beatSender.initPort(port);
    }
    
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
                 if(char == 44) //space
                     !shouldSendBeats => shouldSendBeats;
                 else if(char == 21) //r
                     0 => curBeat;
             }
            }
        }
    }
    
    fun void sendBeats(){
        spork ~ beatSender.sendIntShred("beat");
        spork ~ beatSender.sendIntShred("duration");
        spork ~ _beatLoop();
    }
    
    fun void _beatLoop()
    {  
        while (1)
        {
            milliBeats::ms => now;
            <<<"beat ", curBeat>>>;
            beatSender.m_params.setInt("beat",curBeat);
            beatSender.m_params.setInt("duration",milliBeats);
            if(shouldSendBeats)
                curBeat++;
        }
    }

}

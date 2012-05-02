OscSend sender;
sender.setHost("224.0.0.1", 8080);

//major
[4, 3, 5] @=> int major[];
[3, 4, 5] @=> int minor[];
[3, 3, 6] @=> int dim[];
[4, 3, 4, 1] @=> int major7[];
[4, 3, 3, 2] @=> int dom[];
[3, 4, 3, 2] @=> int minor7[];
[3, 3, 4, 2] @=> int hdim[];
[3, 3, 3, 3] @=> int fdim[];

"c" => string noteChar;

["major","minor","minor","major","major","major","minor","dim","major"] @=> string modeProgression[];
["c", "e", "a", "g", "c", "f", "d", "b", "c"] @=> string noteProgression[];
0 => int posInProgression;

//I iii vi V I IV ii vii I
0 => int wait;
0 => int numWaves;
0 => int base;
"major" => string mode;

float frequency[20];

int octave;

spork ~ handleKB();

for(0 => int i; i < 1; i++){
    spork ~ trackPadGenerator(i);
}

//begin function definitions
fun void trackPadGenerator(int i){
    FMVoices s => JCRev r => dac;
    0.0 => s.gain;
    .05 => r.mix;
    
    Hid trackPad;
    trackPad.open(7, i);
    handleMultiTouch(trackPad, s, i);
}

fun void handleMultiTouch(Hid trackPad, FMVoices s, int i){
    while(true){
        trackPad => now;
        //here: adjust the frequency
        if (numWaves > i){
            <<<i>>>;
            frequency[i] => s.freq;
            <<<frequency[i]>>>;
        }
        HidMsg msg;
        HidMsg msg1;
        HidMsg msg2;
        
        while(true)
        {
            //<<< msg.which, msg.touchX, msg.touchY, msg.touchSize >>>;
            if(msg1.which == 0){
                if(!trackPad.recv(msg1))
                    break;
            }else{
                trackPad.recv(msg2);
                break;
            }
        }
        
        if(msg1.which > 0 && msg2.which > 0){
            //<<< distance(msg1,msg2) >>>;
            //(distance(msg1,msg2) * 4) $ int => s.phonemeNum;
            distance(msg1,msg2) => float dist;
            if(dist > 1.0){
                1.0 => s.gain;
                1.0 => s.vowel;
            }else if(dist < .0){
                .0 => s.gain;
                .0 => s.vowel;
            }else{
                dist =>s.gain;
                dist => s.vowel;
            }
            
        }else{
            .0 => s.gain;
            .0 => s.vowel;
        }
    }
}

fun float distance(HidMsg a, HidMsg b){
    return Math.sqrt(sq(a.touchX - b.touchX) + sq(a.touchY - b.touchY));
}

fun float sq(float x){
    return x * x;
}

fun void handleKB()
{
    Hid hi;
    HidMsg msg;
    hi.openKeyboard(0);
    
    while (true) {
        hi => now;
        while (hi.recv(msg))
        {
            if (msg.ascii == 90 && wait <= 0) {
                posInProgression++;
                2 => wait;
            }
            wait--;
            /*
            if (msg.ascii == 90) "major" => mode;
            if (msg.ascii == 88) "minor" => mode;
            if (msg.ascii == 67) "dim" => mode;
            if (msg.ascii == 86) "hdim" => mode;
            if (msg.ascii == 77) mode + "7" => mode;
            
            //note pitches
            if (msg.ascii == 65) 48 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 87) 49 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 83) 59 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 69) 51 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 68) 52 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 70) 53 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 84) 54 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 71) 55 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 89) 56 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 72) 57 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 85) 58 => base;//frequency[channel][numWaves[channel]-1];
            if (msg.ascii == 74) 59 => base;//frequency[channel][numWaves[channel]-1];
         
            */
            
            modeProgression[posInProgression%9] => mode;
            noteProgression[posInProgression%9] => noteChar;
                       
            if (noteChar == "c") 48 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "c#") 49 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "d") 50 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "d#") 51 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "e") 52 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "f") 53 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "f#") 54 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "g") 55 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "g#") 56 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "a") 57 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "a#") 58 => base;//frequency[channel][numWaves[channel]-1];
            if (noteChar == "b") 59 => base;//frequency[channel][numWaves[channel]-1];
            
            if (base != 0){
                0 => numWaves;
                for (0 => int i; i < 8; i++)
                {
                    if (mode == "major") {
                        Std.mtof(base) => frequency[numWaves];
                        base + major[i%3] => base;
                    }
                    if (mode == "minor") {
                        Std.mtof(base) => frequency[numWaves];
                        base + minor[i%3] => base;
                    }
                    if (mode == "dim") {
                        Std.mtof(base) => frequency[numWaves];
                        base + dim[i%3] => base;
                    }
                    if (mode == "major7") {
                        Std.mtof(base) => frequency[numWaves];
                        base + major7[i%3] => base;
                    }
                    if (mode == "major77") {
                        Std.mtof(base) => frequency[numWaves];
                        base + dom[i%3] => base;
                    }
                    if (mode == "min7") {
                        Std.mtof(base) => frequency[numWaves];
                        base + minor7[i%3] => base;
                    }
                    if (mode == "dim7") {
                        Std.mtof(base) => frequency[numWaves];
                        base + hdim[i%3] => base;
                    }
                    if (mode == "dim77") {
                        Std.mtof(base) => frequency[numWaves];
                        base + fdim[i%3];
                    }
                     numWaves++;
                }
            }
            /*
            if (msg.ascii == 90) {
                0 => sha.preset;
            } if (msg.ascii == 88) {
                1 => sha.preset;
            } if (msg.ascii == 67) {
                22 => sha.preset;
            }
           */
            0 => base;
        }
    }
}


while (true) {
    
    for(0 => int j; j < 6; j++){
        //<<< j, frequency[j], posInProgression >>>;
    }
    sender.startMsg("/note", "n");
    sender.addString(noteProgression[posInProgression]);
    sender.startMsg("/mode", "m");
    sender.addString(modeProgression[posInProgression]);
    1000::ms => now;
}
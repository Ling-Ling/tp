//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

32 => int BAR_LENGTH;


TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

Mouse.initMice(tps.size()) @=> Mouse mice[];



//
//  OSC slave
//

OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);

// receive beat
oscRecv.listenForFloat("gain");
oscRecv.listenForInt("beatNum");
oscRecv.m_params.setIntRange("beatNum", 0, BAR_LENGTH);

//receive freqs
oscRecv.listenForInt("freq1");
oscRecv.listenForInt("freq2");


// 
//  discrete samples
//

for (0 => int i; i < mice.size(); i++)
{
    string files[];

    Sample sample;

    if (i == 0)
        ["data/clap.wav", "data/cowbell.wav", "data/cymbal.wav"] @=> files;
    else if (i == 1)
        ["data/lowtom.wav", "data/lowtomac.wav"] @=> files;
    else if (i == 2)
        ["data/snare.wav", "data/snare2.wav", "data/snareac.wav", "data/snare-chili.wav", "data/snare-hop.wav", "data/snare3.wav"] @=> files;
    else if (i == 3)
        ["data/kick.wav", "data/kick2.wav", "data/kickac.wav", "data/subbass.wav"] @=> files;
    else if (i == 4)
        ["data/hightom.wav"] @=> files;

    files @=> sample.m_files;

    
    spork ~ mice[i].m_params.logIntShred("mouse_click");

    spork ~ sample.m_params.bindIntShred("hit", mice[i].m_params, "mouse_click");
    spork ~ sample.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");

    spork ~ sample.m_params.bindFloatShred("gain", oscRecv.m_params, "gain");
}


//
//  drums
//

for (0 => int i; i < tps.size(); i++)
{
    DrumPad dp;

    if (i == 0)
    {
        [ // pattern 0
         [1, 0, 0, 0, 1, 0, 0, 0, 
          1, 0, 0, 0, 1, 0, 0, 0, 
          1, 0, 0, 0, 1, 0, 0, 0, 
          1, 0, 0, 0, 1, 0, 0, 0],

          // pattern 1
         [1, 0, 0, 0, 1, 0, 1, 0, 
          1, 0, 0, 0, 1, 0, 1, 1, 
          1, 0, 0, 0, 1, 0, 1, 0, 
          1, 0, 0, 0, 1, 0, 1, 1],

          // pattern 2
         [1, 1, 1, 1, 1, 1, 1, 1,
          1, 1, 1, 1, 1, 1, 1, 1,
          1, 1, 1, 1, 1, 1, 1, 1,
          1, 1, 1, 1, 1, 1, 1, 1]

        ] @=> dp.m_patterns;

        ["data/closehat.wav"] @=> dp.m_files;
        ["data/hihat-open.wav"] @=> dp.m_mixFiles;
    }
    else if (i == 1)
    {
        [ // pattern 0
         [0, 0, 0, 0, 0, 0, 0, 0,
          1, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          1, 0, 0, 0, 0, 0, 0, 0],

          // pattern 1
         [0, 0, 0, 0, 0, 0, 0, 0,
          1, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          1, 0, 0, 0, 0, 0, 0, 0]

        ] @=> dp.m_patterns;

        ["data/snare.wav", "data/snareac.wav"] @=> dp.m_files;
        ["data/snare-chili.wav", "data/snare-hop.wav"] @=> dp.m_mixFiles;
    }

    spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");

//    dp.m_params.setFloatRange("openness", 0, .5);
    spork ~ dp.m_params.bindFloatShred("openness", tps[i].m_params, "y");

    dp.m_params.setIntRange("pattern", 0, dp.m_patterns.size());
    spork ~ dp.m_params.bindIntToFloatShred("pattern", tps[i].m_params, "x");

    spork ~ dp.m_params.bindFloatShred("gain", oscRecv.m_params, "gain");
}


//
//  pinchers
//

PincherPad pp;
PincherPad pp2;
spork ~ pp.m_params.bindFloatShred("distance", tps[0].m_params, "pinch_distance");

spork ~ pp.m_params.bindIntShred("freq1", oscRecv.m_params, "freq1");
spork ~ pp.m_params.logIntShred("freq");


// 24h
1::day => now;

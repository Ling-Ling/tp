//
//  main.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

Mouse @ mice[tps.size()];
Mouse.initMice(mice);


//
//  OSC master
//

OscBeatSend oscBeatSend;
oscBeatSend.initPort(OSC_PORT);
// send beat 
spork ~ oscBeatSend.beatLoopShred();

OscFreqSend oscFreqSend;
oscFreqSend.initPort(OSC_PORT);
// send freq
spork ~ oscFreqSend.freqLoopShred();


//
//  OSC slave
//

OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);

// receive beat
oscRecv.listenForInt("beatNum");
oscRecv.m_params.setIntRange("beatNum", 0, 8);

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
        ["data/lowtom.wav", "data/lowtomac.wav", "data/hightom.wav"] @=> files;
    else if (i == 2)
        ["data/snare.wav", "data/snare2.wav", "data/snareac.wav", "data/snare-chili.wav", "data/snare-hop.wav", "data/snare3.wav"] @=> files;
    else if (i == 3)
        ["data/kick.wav", "data/kick2.wav", "data/kickac.wav", "data/subbass.wav"] @=> files;

    files @=> sample.m_files;

    spork ~ sample.m_params.bindIntShred("hit", mice[i].m_params, "mouse_click");
    spork ~ sample.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");
}


//
//  drums
//

DrumPad dp;
"data/hihat.wav" => dp.m_file;
"data/hihat-open.wav" => dp.m_mixFile;

spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");
spork ~ dp.m_params.bindFloatShred("openness", tps[0].m_params, "y");


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

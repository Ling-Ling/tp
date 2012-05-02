//
//  beat.ck
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

Sample s[6];

"data/kick.wav" => s[0].m_file;
spork ~ s[0].m_params.bindIntShred("hit", mice[1].m_params, "mouse_click");
spork ~ s[0].m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");


//
//  drums
//

DrumPad dp;
"data/hihat.wav" => dp.m_file;
"data/hihat-open.wav" => dp.m_mixFile;

spork ~ dp.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");
spork ~ dp.m_params.bindFloatShred("openness", tps[0].m_params, "y");


// 24h
1::day => now;

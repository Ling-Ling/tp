//
//  click.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;

// mice
Mouse.initMice(5) @=> Mouse mice[];

// osc beat slave
OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);
oscRecv.listenForInt("beatNum");
oscRecv.listenForFloat("gain");

for (0 => int i; i < mice.size(); i++)
{
    string files[];

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

    Sample sample;
    files @=> sample.m_files;

    spork ~ sample.m_params.bindIntShred("hit", mice[i].m_params, "mouse_click");
    spork ~ sample.m_params.bindIntShred("beatNum", oscRecv.m_params, "beatNum");

    spork ~ sample.m_params.bindFloatShred("gain", oscRecv.m_params, "gain");
}


// 24h
1::day => now;

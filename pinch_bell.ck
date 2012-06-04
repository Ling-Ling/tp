//
//  pinch.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//

0 => int curTP;

me.arg( 0 ) => string startFreq;
<<<startFreq>>>;
8000 => int OSC_PORT;

// trackpads
TrackPad @ tps[TrackPad.MAX_NUM_TRACKPADS];
TrackPad.initTrackPads(tps);

// osc slave
OscParamRecv oscRecv;
oscRecv.initPort(OSC_PORT);
oscRecv.listenForInt("pinchGain");

Tilter til;
til.initTilter();

    PincherPad pp;

    // map trackpad pinch distance
    spork ~ pp.m_params.bindFloatShred("pinch_dist", tps[curTP].m_params, "pinch_distance");

    // map tilt distance
    spork ~ pp.m_params.bindIntShred("tilt_dist", til.m_params, "tilt"); 
    
    // map trackpad flick distance
    spork ~ pp.m_params.bindFloatShred("flick_dist", tps[curTP].m_params, "flick_distance");

    // check if trackpad tapped
    spork ~ pp.m_params.bindFloatShred("doesTap", tps[curTP].m_params, "onTouch");

    // watch for touch release
    spork ~ pp.m_params.bindIntShred("onRelease", tps[curTP].m_params, "onRelease");

    // map OSC freq
    oscRecv.listenForInt("freq" + startFreq);
    spork ~ pp.m_params.bindIntShred("freq", oscRecv.m_params, "freq" + startFreq);

    // map OSC gain
    spork ~ pp.m_params.bindIntShred("gain", oscRecv.m_params, "pinchGain");


// 24h
1::day => now;
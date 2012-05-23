//
//  master_bell.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


8000 => int OSC_PORT;
16 => int nPlayers;

//
//  Bell master
//


// mode progression
[
XD.MODE("major"),

XD.MODE("minor"),
XD.MODE("minor"),
XD.MODE("major"),
XD.MODE("major"),
XD.MODE("major"),
XD.MODE("minor"),
XD.MODE("dim"),
XD.MODE("major")

]
@=> int modeProgression[];

// note progresssion
[
XD.KEY("c"),
XD.KEY("a"),
XD.KEY("f"),
XD.KEY("g"),
XD.KEY("c"),
XD.KEY("e"),
XD.KEY("d"),
XD.KEY("b"),
XD.KEY("c")
] 
@=> int noteProgression[];

// osc pincher frequency patterns master
OscScaleSend oscScaleSend;
oscScaleSend.initPort(OSC_PORT);
oscScaleSend.m_modePattern.initWithPattern(modeProgression);
oscScaleSend.m_notePattern.initWithPattern(noteProgression);
spork ~ oscScaleSend.freqLoopShred(nPlayers);


// 24h
1::day => now;


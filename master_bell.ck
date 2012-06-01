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
OscScaleAndBeatSend oscSend;
oscSend.initPort(OSC_PORT);
oscSend.m_modePattern.initWithPattern(modeProgression);
oscSend.m_notePattern.initWithPattern(noteProgression);
spork ~ oscSend.freqLoopShred(nPlayers);
oscSend.sendBeats();
spork ~ oscSend.handleKeyboard();

1::day => now;

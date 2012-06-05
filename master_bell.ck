//
//  master_bell.ck
//
// Jonathan Tilley
// Stanford Laptop Orchestra (SLOrk)
//


//
//  Bell master
//


8000 => int OSC_PORT;
16 => int nPlayers;

// note progression
[
 [52, 53, 55, 57, 59, 61, 62, 64, 65, 67, 69, 71, 73, 74, 76, 77],
[55, 57, 59, 61, 62, 64, 65, 67, 69, 71, 73, 74, 76, 77, 79, 81],
 [43, 50, 67, 69, 71, 73, 74, 76, 77, 79, 81, 83, 85, 86, 88, 89]
]
@=> int frequencySets[][];

// timing
[
0,
209,
477
] 
@=> int frequencyChangeLocations[];

// osc pincher frequency patterns master
OscScaleAndBeatSend oscSend;
oscSend.beatSendingPort(OSC_PORT);
oscSend.scaleSendingPort(OSC_PORT + 1);
oscSend.setFrequencySets(frequencySets);
oscSend.setFrequencyChangeLocations(frequencyChangeLocations);

spork ~ oscSend.freqLoopShred(nPlayers);
oscSend.sendBeats();
spork ~ oscSend.handleKeyboard();

1::day => now;

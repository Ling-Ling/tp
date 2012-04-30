//
//  main.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


TrackPad tps[TrackPad.MAX_NUM_TRACKPADS];

// init as many trackpads as possible
for (0 => int i; i < tps.size(); i++)
{
    if (i == 1)
    {
        // drumpad
        DrumPad dp;
        dp.initTrackPad(i) @=> tps[i];
    }
    else
    {
        // generic trackpad
        tps[i].initTrackPad(i);
    }
    
    // failed init
    if (tps[i] == NULL)
        break;
}

<<< "[tp] successfully initialized", TrackPad.n_trackPads, "trackpads" >>>;


// init mouse click handlers on all initialized trackpads
for (0 => int i; i < TrackPad.n_trackPads; i++)
    if (tps[i].initMouse() == NULL)
        <<< "[tp] error initializing mouse on trackpad ", i >>>;
    else 
        <<< "[tp] successfully initialized mouse on trackpad", i >>>;


/*
// infinite loop
while (1)
    1::week => now;
*/

0 => int beat;
8 => int bar_length;

// play loop
while (1)
{
    100::ms => now;

    for (0 => int i; i < TrackPad.n_trackPads; i++)
        tps[i].playNoteAtBeatWithGain(0, beat++ % bar_length, .5);
}



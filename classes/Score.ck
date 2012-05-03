


Score _score;

public class Score
{
    fun static Score score()
    {
        return _score;
    }

    static ParamIntPattern @ modePattern;

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
    @=> int _modeProgression[];

    ParamIntPattern _modePattern;
    _modePattern.initWithPattern(_modeProgression);
    _modePattern @=> Score.modePattern;


    static ParamIntPattern @ notePattern;

    [
     XD.KEY("c#"),
     XD.KEY("f"),
     XD.KEY("b"),
     XD.KEY("g#"),
     XD.KEY("c#"),
     XD.KEY("f#"),
     XD.KEY("d#"),
     XD.KEY("b"),
     XD.KEY("c#")
    ] 
    @=> int _noteProgression[];

    ParamIntPattern _notePattern;
    _notePattern.initWithPattern(_noteProgression);
    _notePattern @=> Score.notePattern;


    static ParamIntPattern @ bassNotes;

    [
     XD.KEY("c#"),
     XD.KEY("e"),
     XD.KEY("f#"),
     XD.KEY("a")
    ] 
    @=> int _bassNotes[];

    ParamIntPattern __bassNotes;
    __bassNotes.initWithPattern(_bassNotes);
    __bassNotes @=> Score.bassNotes;

    // high hats
    [[0, 0, 0, 0, 0, 0, 1, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 1, 0, 0],
     [0, 0, 0, 0, 0, 0, 1, 0,
      0, 0, 1, 0, 0, 0, 0, 0,
      0, 0, 0, 1, 0, 0, 0, 1],
     [0, 0, 1, 0, 1, 0, 1, 0,
      0, 0, 1, 0, 1, 0, 1, 0,
      0, 1, 0, 1, 0, 1, 0, 1],
     [1, 0, 1, 0, 1, 0, 1, 0,
      1, 0, 1, 0, 1, 0, 1, 0,
      0, 1, 0, 1, 0, 1, 1, 1]]
     @=> int _hhDrumBeats[][];

    static ParamIntPatterns @ hhDrumBeats;
    ParamIntPatterns __hhDrumBeats;
    __hhDrumBeats.initWithPatterns(_hhDrumBeats) @=> hhDrumBeats;

    // toms
    [[0, 0, 0, 1, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 1, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 1, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 1, 0, 0,
      0, 0, 0, 1, 0, 0, 0, 0]]
    @=> int _tomDrumBeats[][];

    static ParamIntPatterns @ tomDrumBeats;
    ParamIntPatterns __tomDrumBeats;
    __tomDrumBeats.initWithPatterns(_tomDrumBeats) @=> tomDrumBeats;

    // cowbell
    [[0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 1, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 1, 0, 1, 0, 0]]
    @=> int _cowbellDrumBeats[][];

    static ParamIntPatterns @ cowbellDrumBeats;
    ParamIntPatterns __cowbellDrumBeats;
    __cowbellDrumBeats.initWithPatterns(_cowbellDrumBeats) @=> cowbellDrumBeats;


    1::day => now;
}

//
//  Parameters.ck
//
// Ilias Karim
// Stanford Laptop Orchestra (SLOrk)
//


/**
 *  
 */
public class Parameters
{   
    /**  ... */
    StringEvent m_event;


    //
    //  floats
    //

    float m_fValues[0];
    FloatEvent fEvents[0][0] @=> FloatEvent @ m_fEvents[][];
    float m_fMins[0];
    float m_fMaxs[0];

    fun void setFloat(string key, float f)
    {
        f => m_fValues[key];

        getFloatEvents(key) @=> FloatEvent events[];
        for (0 => int i; i < events.size(); i++)
        {
            f => events[i].f;
            events[i].signal();
        }

        key @=> m_event.s;
        m_event.signal();
    }

    fun void setNormalFloat(string key, float f)
    {
        if (m_fMins[key] == m_fMaxs[key])
        {
            setFloat(key, f);
            return;
        }

        setFloat(key, f * m_fMaxs[key] + m_fMins[key]);
    }

    fun float getFloat(string key)
    {
        return m_fValues[key];
    }

    fun void setFloatRange(string key, float min, float max)
    {
        if (max <= min) 
        {
            <<< "Error settings range", min, max >>>;
            return;
        }

        min @=> m_fMins[key];
        max @=> m_fMaxs[key];

        if (getFloat(key) < min)
            setFloat(key, min);

        else if (getFloat(key) > max)
            setFloat(key, max);
    }

    fun float getNormalizedFloat(string key)
    {
        if (m_fMins[key] == m_fMaxs[key])
        {
            0. => m_fMins[key];
            1. => m_fMaxs[key];
        }

        m_fMins[key] => float min;
        m_fMaxs[key] => float max;

        return (getFloat(key) - min) * max + min;
    }

    fun FloatEvent[] getFloatEvents(string key)
    {
        if (m_fEvents[key] == NULL)
            FloatEvent events[0] @=> m_fEvents[key];

        return m_fEvents[key];
    }

    fun void _addFloatEvent(string key, FloatEvent event)
    {
        getFloatEvents(key) @=> FloatEvent events[];

        FloatEvent @ newEvents[events.size() + 1];

        for (0 => int i; i < events.size(); i++)
            events[i] @=> newEvents[i];

        event @=> newEvents[newEvents.size() - 1];

        newEvents @=> m_fEvents[key];
    }

    fun FloatEvent getNewFloatEvent(string key)
    {
        FloatEvent event;

        _addFloatEvent(key, event);

        return event;
    }

    fun void logFloatShred(string key)
    {
        getNewFloatEvent(key) @=> FloatEvent event;

        while (1)
        {
            event => now;
            <<< key + ":", event.f >>>;
        }
    }

    fun void bindFloatShred(string key, Parameters params, string otherKey)
    {
        params.getNewFloatEvent(otherKey) @=> FloatEvent event;

        while (1)
        {
            event => now;

            params.getNormalizedFloat(otherKey) => float f;

            setNormalFloat(key, f);
        }
    }

    fun void bindFloatToIntShred(string key, Parameters params, string otherKey)
    {
        params.getNewIntEvent(otherKey) @=> IntEvent event;

        while (1)
        {
            event => now;

            params.m_iMins[otherKey] => int min;
            params.m_iMaxs[otherKey] => int max;

            float f;

            if (min == max)
                params.getInt(otherKey) $ float => f;

            else 
                ((event.i - min) $ float) / max => f;

            setNormalFloat(key, f);
        }
    }


    // 
    //  ints
    //

    int m_iValues[0];
    IntEvent iEvents[0][0] @=> IntEvent @ m_iEvents[][];
    int m_iMins[0];
    int m_iMaxs[0];

    fun void setInt(string key, int i)
    {
        if (m_iMins[key] != m_iMaxs[key])
        {
            i - m_iMins[key] => i;
            i % m_iMaxs[key] => i;
            i + m_iMins[key] => i;
        }

        // set int value
        i => m_iValues[key];

        key @=> m_event.s;
        m_event.signal();

        if (m_iEvents[key] == NULL)
            return;

        // signal all events
        m_iEvents[key] @=> IntEvent events[];

        for (0 => int j; j < events.size(); j++)
        {
            i => events[j].i;
            events[j].signal();
        }

    }

    fun int getInt(string key)
    {
        return m_iValues[key];
    }

    fun void setIntRange(string key, int min, int max)
    {
        if (max <= min) 
        {
            <<< "Error settings range", min, max >>>;
            return;
        }

        min @=> m_iMins[key];
        max @=> m_iMaxs[key];

        if (getInt(key) < min)
            setInt(key, min);

        else if (getInt(key) > max)
            setInt(key, max);
    }
    
    fun void _addFloatEvent(string key, FloatEvent event)
    {
        getFloatEvents(key) @=> FloatEvent events[];

        FloatEvent @ newEvents[events.size() + 1];

        for (0 => int i; i < events.size(); i++)
            events[i] @=> newEvents[i];

        event @=> newEvents[newEvents.size() - 1];

        newEvents @=> m_fEvents[key];
    }


    fun void _addIntEvent(string key, IntEvent event)
    {
        if (m_iEvents[key] == NULL)
            IntEvent events[0] @=> m_iEvents[key];

        m_iEvents[key] @=> IntEvent events[];

        IntEvent @ newEvents[events.size() + 1];

        for (0 => int i; i < events.size(); i++)
            events[i] @=> newEvents[i];

        event @=> newEvents[newEvents.size() - 1];

        newEvents @=> m_iEvents[key];
    }

    fun IntEvent getNewIntEvent(string key)
    {
        IntEvent event;

        _addIntEvent(key, event);

        return event;
    }
    
    fun void logIntShred(string key)
    {
        getNewIntEvent(key) @=> IntEvent event;

        while (1)
        {
            event => now;
            <<< key + ":", event.i >>>;
        }
    }

    fun void bindIntShred(string key, Parameters params, string otherKey)
    {
        params.getNewIntEvent(otherKey) @=> IntEvent event;

        while (1)
        {
            event => now;
            event.i => int i;

            if (params.m_iMins[otherKey] != params.m_iMaxs[otherKey] 
                &&
                m_iMins[key] != m_iMaxs[key])
            {
                ((((event.i - params.m_iMins[otherKey]) $ float) / params.m_iMaxs[otherKey]) * m_iMaxs[key]) $ int + m_iMins[key] => i;
            }
            setInt(key, i);
        }
    }

    fun void bindIntToFloatShred(string key, Parameters params, string otherKey)
    {
        params.getNewFloatEvent(otherKey) @=> FloatEvent event;

        while (1)
        {
            event => now;

            if (m_iMins[key] != m_iMaxs[key])
            {
                params.getNormalizedFloat(otherKey) => float f;
                setInt(key, (f * m_iMaxs[key]) $ int + m_iMins[key]);

                //<<< key, f, (f * m_iMaxs[key]) $ int + m_iMins[key] >>>;
            }
            else
            {
                setInt(key, event.f $ int);
            }
        }
    }


    // TODO: abstract this 

/*
    fun void bindMidiNoteIntToPattern(string key, int [])
    {
    }


    // TODO: abstract this 

    fun void bindMidiNoteIntToPattern(string key, ParamTuplePattern pattern)
    {
        spork ~ _noteLoop(key, pattern);

        spork ~ _modeLoop(key, pattern);
    }

    fun void _sendFreqs(string key, ParamTuplePattern pattern)
    {
        pattern.m_params.getInt("value0") => int mode;
        pattern.m_params.getInt("value1") => int base;

        // TODO: abstract this
        int frequency[20]; // TODO: remove constant
        XD.createChord(base, mode, frequency.size()) @=> frequency;

        for (0 => int i; i < frequency.size(); i++)
           m_params.setInt("freq" + i, frequency[i]);
    }

    fun void _noteLoop(string key, ParamTuplePattern pattern)
    {
        pattern.m_params.getNewIntEvent("value0") @=> IntEvent e;

        while (1)
        {
            e => now;
            _sendFreqs(key, pattern);
        }
    }
;
    fun void _modeLoop(string key, ParamTuplePattern pattern))
    {
        pattern.m_params.getNewIntEvent("value1") @=> IntEvent e;

        while (1)
        {
            e => now;
            _sendFreqs(key, pattern);
        }
    }
*/
}

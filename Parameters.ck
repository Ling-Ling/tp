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
    //
    //  floats
    //

    float m_fValues[0];
    Event fEvents[0][0] @=> Event @ m_fEvents[][];
    float m_fMins[0];
    float m_fMaxs[0];

    fun void setFloat(string key, float f)
    {
        f => m_fValues[key];

        getFloatEvents(key) @=> Event events[];
        for (0 => int i; i < events.size(); i++)
            events[i].signal();
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

    fun Event[] getFloatEvents(string key)
    {
        if (m_fEvents[key] == NULL)
            Event events[0] @=> m_fEvents[key];

        return m_fEvents[key];
    }

    fun void _addFloatEvent(string key, Event event)
    {
        getFloatEvents(key) @=> Event events[];

        Event @ newEvents[events.size() + 1];

        for (0 => int i; i < events.size(); i++)
            events[i] @=> newEvents[i];

        event @=> newEvents[newEvents.size() - 1];

        newEvents @=> m_fEvents[key];
    }

    fun Event getNewFloatEvent(string key)
    {
        Event event;

        _addFloatEvent(key, event);

        return event;
    }

    fun void logFloatShred(string key)
    {
        getNewFloatEvent(key) @=> Event event;

        while (1)
        {
            event => now;
            <<< key + ":", getFloat(key) >>>;
        }
    }

    fun void bindFloatShred(string key, Parameters params, string otherKey)
    {
        params.getNewFloatEvent(otherKey) @=> Event event;

        while (1)
        {
            event => now;

            params.getNormalizedFloat(otherKey) => float f;

            setNormalFloat(key, f);
        }
    }

    fun void bindFloatToIntShred(string key, Parameters params, string otherKey)
    {
        params.getNewIntEvent(otherKey) @=> Event event;

        while (1)
        {
            event => now;

            params.m_iMins[otherKey] => int min;
            params.m_iMaxs[otherKey] => int max;

            float f;

            if (min == max)
                params.getInt(otherKey) $ float => f;

            else 
                ((params.getInt(otherKey) - min) $ float) / max => f;

            setNormalFloat(key, f);
        }
    }


    // 
    //  ints
    //

    int m_iValues[0];
    Event iEvents[0][0] @=> Event @ m_iEvents[][];
    int m_iMins[0];
    int m_iMaxs[0];

    fun void setInt(string key, int i)
    {
        i => m_iValues[key];

        // signal all events
        getIntEvents(key) @=> Event events[];
        for (0 => int i; i < events.size(); i++)
            events[i].signal();
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

    fun Event[] getIntEvents(string key)
    {
        if (m_iEvents[key] == NULL)
            Event events[0] @=> m_iEvents[key];

        return m_iEvents[key];
    }
    
    fun void _addIntEvent(string key, Event event)
    {
        getIntEvents(key) @=> Event events[];

        Event @ newEvents[events.size() + 1];

        for (0 => int i; i < events.size(); i++)
            events[i] @=> newEvents[i];

        event @=> newEvents[newEvents.size() - 1];

        newEvents @=> m_iEvents[key];
    }

    fun Event getNewIntEvent(string key)
    {
        Event event;

        _addIntEvent(key, event);

        return event;
    }
    
    fun void logIntShred(string key)
    {
        getNewIntEvent(key) @=> Event event;

        while (1)
        {
            event => now;
            <<< key + ":", getInt(key) >>>;
        }
    }

    fun void bindIntShred(string key, Parameters params, string otherKey)
    {
        params.getNewIntEvent(otherKey) @=> Event event;

        while (1)
        {
            event => now;

            params.getInt(otherKey) => int i;

            if (params.m_iMins[otherKey] != params.m_iMaxs[otherKey] 
                &&
                m_iMins[key] != m_iMaxs[key])
            {
                ((((i - params.m_iMins[otherKey]) $ float) / params.m_iMaxs[otherKey]) * m_iMaxs[key]) $ int + m_iMins[key] => i;
            }

            setInt(key, i);
        }
    }

    fun void bindIntToFloatShred(string key, Parameters params, string otherKey)
    {
        params.getNewFloatEvent(otherKey) @=> Event event;

        while (1)
        {
            event => now;

            if (m_iMins[key] != m_iMaxs[key])
            {
                params.getNormalizedFloat(otherKey) => float f;
                setInt(key, (f * m_iMaxs[key]) $ int + m_iMins[key]);
            }
            else
            {
                setInt(key, params.getFloat(otherKey) $ int);
            }
        }
    }
}

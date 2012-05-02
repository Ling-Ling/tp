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

    fun void setFloat(string key, float f)
    {
        f => m_fValues[key];

        getFloatEvents(key) @=> Event events[];
        for (0 => int i; i < events.size(); i++)
            events[i].signal();
    }

    fun float getFloat(string key)
    {
        return m_fValues[key];
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
            setFloat(key, params.getFloat(otherKey));
        }
    }


    // 
    //  ints
    //

    int m_iValues[0];
    Event iEvents[0][0] @=> Event @ m_iEvents[][];

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
            setInt(key, params.getInt(otherKey));
        }
    }
}

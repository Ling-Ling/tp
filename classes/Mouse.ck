

public class Mouse
{
    Parameters m_params;

    fun static Mouse[] initMice(int n)
    {
        Mouse @ mice[n];

        for (0 => int i; i < n; i++)
        {
            if (mice[i] == NULL)
                Mouse mouse @=> mice[i];

            if (mice[i].initMouse(i) != NULL)
                <<< "[tp]", "initialized mouse", i >>>;
            else 
                <<< "[tp]", "could not open mouse", i >>>;
        }

        return mice;
    }

    static int n_mice;

    Hid m_mouse;
    int m_mouseNum;

    fun Mouse initMouse(int n)
    {
        if (!m_mouse.openMouse(n))
            return NULL;

        n => m_mouseNum;

        Mouse.n_mice++;

        spork ~ _mouseClickLoop();

        return this;
    }

    fun void _mouseClickLoop()
    {
        while (1)
        {
            HidMsg msg;
            m_mouse => now;

            while (m_mouse.recv(msg))
            {
                if (msg.isButtonDown())
                    m_params.setInt("mouse_click", 1);

                else if (msg.isButtonUp())
                    m_params.setInt("mouse_click", 0);
            }
        }
    }
}

0 => Mouse.n_mice;

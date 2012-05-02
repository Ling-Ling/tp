

public class Mouse
{
    Parameters m_params;

    fun static void initMice(Mouse mice[])
    {
        for (0 => int i; i < mice.size(); i++)
        {
            if (mice[i] == NULL)
                Mouse mouse @=> mice[i];

            mice[i].initMouse(i);
        }
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

//
//  test.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


//
// random test code
//

fun static float debugMiceIndices()
{
    for (0 => int i; i < MAX_NUM_TRACKPADS; i++)
        spork ~ __debugMouseLoop(i);
}

fun static void __debugMouseLoop(int i)
{
    Hid hi;
    HidMsg msg;
    if (!hi.openMouse(i))
        return;

    while (1)
    {
        hi => now;
        while (hi.recv(msg))
            if (msg.isButtonDown())
                <<< "Mouse", i, "click down" >>>;
            else if (msg.isButtonUp())
                <<< "Mouse", i, "click up" >>>;
    }
}


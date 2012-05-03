//
//  test.ck
//
//  Ilias Karim
//  Stanford Laptop Orchestra (SLOrk)
//


ParamIntPattern pattern;


spork ~ pattern.m_params.logIntShred("value");


pattern.init([10, 9]);


while (1)
{
    1::second => now;
    
    pattern.increment();
}

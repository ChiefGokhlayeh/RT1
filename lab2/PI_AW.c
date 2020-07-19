#define S_FUNCTION_NAME PI_AW
#define NO_PARAMETERS 5
#define S_FUNCTION_LEVEL 2
#include "simstruc.h"

typedef double SIGNAL;
typedef const double PARAM;

void S_FUNCTION_NAME(SIGNAL e, SIGNAL *u, int init, SimStruct *S);
#include "Sblock.h"

void S_FUNCTION_NAME(SIGNAL e, SIGNAL *u, int init, SimStruct *S)
{
    static SIGNAL   uik_1, up, ui;
    PARAM           kp = 1, T = 1, Tn = 0.1, ui_max = 1.5, ui_min = -1.5;
    
    if (init)
    {
        *u = uik_1;
    }
    else
    {
        up = kp * e;
        ui = uik_1 + kp*T/Tn*e;
        if (ui > ui_max) ui = ui_max;
        if (ui < ui_max) ui = ui_min;
        
        *u = up + ui;

        uik_1 = ui;
    }
}

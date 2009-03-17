/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file colour.c
 *
 * @brief Predefined colours for use with NAEV.
 */


#include "colour.h"


/*
 * default colours
 */
/* grey */
glColour cWhite      = { .r=1.00, .g=1.00, .b=1.00, .a=1. }; /**< White */
glColour cGrey90     = { .r=0.90, .g=0.90, .b=0.90, .a=1. }; /**< Grey 90% */
glColour cGrey80     = { .r=0.80, .g=0.80, .b=0.80, .a=1. }; /**< Grey 80% */
glColour cGrey70     = { .r=0.70, .g=0.70, .b=0.70, .a=1. }; /**< Grey 70% */
glColour cGrey60     = { .r=0.60, .g=0.60, .b=0.60, .a=1. }; /**< Grey 60% */
glColour cGrey50     = { .r=0.50, .g=0.50, .b=0.50, .a=1. }; /**< Grey 50% */
glColour cGrey40     = { .r=0.40, .g=0.40, .b=0.40, .a=1. }; /**< Grey 40% */
glColour cGrey30     = { .r=0.30, .g=0.30, .b=0.30, .a=1. }; /**< Grey 30% */
glColour cGrey20     = { .r=0.20, .g=0.20, .b=0.20, .a=1. }; /**< Grey 20% */
glColour cGrey10     = { .r=0.10, .g=0.10, .b=0.10, .a=1. }; /**< Grey 10% */
glColour cBlack      = { .r=0.00, .g=0.00, .b=0.00, .a=1. }; /**< Black */

glColour cGreen      = { .r=0.20, .g=0.80, .b=0.20, .a=1. }; /**< Green */
glColour cDarkRed    = { .r=0.60, .g=0.10, .b=0.10, .a=1. }; /**< Dark Red */
glColour cRed        = { .r=0.80, .g=0.20, .b=0.20, .a=1. }; /**< Red */
glColour cOrange     = { .r=0.90, .g=0.70, .b=0.10, .a=1. }; /**< Orange */
glColour cYellow     = { .r=0.80, .g=0.80, .b=0.00, .a=1. }; /**< Yellow */
glColour cDarkBlue   = { .r=0.10, .g=0.10, .b=0.60, .a=1. }; /**< Dark Blue */
glColour cBlue       = { .r=0.20, .g=0.20, .b=0.80, .a=1. }; /**< Blue */
glColour cLightBlue  = { .r=0.30, .g=0.30, .b=0.80, .a=1. }; /**< Light Blue */
glColour cPurple     = { .r=0.90, .g=0.10, .b=0.90, .a=1. }; /**< Purple */


/*
 * game specific
 */
glColour cConsole       =  { .r = 0.1, .g = 0.9, .b = 0.1, .a = 1.  }; /**< Console colour */
glColour cDConsole      =  { .r = 0.0, .g = 0.7, .b = 0.0, .a = 1.  }; /**< Dark Console colour */
/* toolkit */
glColour cHilight       =  { .r = 0.1, .g = 0.9, .b = 0.1, .a = 0.3 }; /**< Hilight colour */
/* objects */
glColour cInert         =  { .r = 0.6, .g = 0.6, .b = 0.6, .a = 1.  }; /**< Inert object colour */
glColour cNeutral       =  { .r = 0.9, .g = 1.0, .b = 0.3, .a = 1.  }; /**< Neutral object colour */
glColour cFriend        =  { .r = 0.0, .g = 0.8, .b = 0.0, .a = 1.  }; /**< Friend object colour */
glColour cHostile       =  { .r = 0.9, .g = 0.2, .b = 0.2, .a = 1.  }; /**< Hostile object colour */
/* radar */
glColour cRadar_player  =  { .r = 0.4, .g = 0.8, .b = 0.4, .a = 1.  }; /**< Player colour on radar. */
glColour cRadar_tPilot  =  { .r = 0.8, .g = 0.5, .b = 0.0, .a = 1.  }; /**< Targetted object colour on radar. */
glColour cRadar_tPlanet =  { .r = 0.4, .g = 0.0, .b = 0.8, .a = 1.  }; /**< Targetted planet colour. */
glColour cRadar_weap    =  { .r = 0.8, .g = 0.2, .b = 0.2, .a = 1.  }; /**< Weapon colour on radar. */
/* health */
glColour cShield        =  { .r = 0.2, .g = 0.2, .b = 0.8, .a = 1.  }; /**< Shield bar colour. */
glColour cArmour        =  { .r = 0.5, .g = 0.5, .b = 0.5, .a = 1.  }; /**< Armour bar colour. */
glColour cEnergy        =  { .r = 0.2, .g = 0.8, .b = 0.2, .a = 1.  }; /**< Energy bar colour. */
glColour cFuel          =  { .r = 0.9, .g = 0.1, .b = 0.4, .a = 1.  }; /**< Fuel bar colour. */


/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file dev_sysedit.c
 *
 * @brief Handles the star system editor.
 */

#include "dev_sysedit.h"

#include "naev.h"

#include "SDL.h"

#include "space.h"
#include "toolkit.h"
#include "opengl.h"
#include "map.h"
#include "dev_planet.h"
#include "dev_system.h"
#include "unidiff.h"
#include "dialogue.h"
#include "tk/toolkit_priv.h"


#define BUTTON_WIDTH    80 /**< Map button width. */
#define BUTTON_HEIGHT   30 /**< Map button height. */


#define SYSEDIT_EDIT_WIDTH       400 /**< System editor width. */
#define SYSEDIT_EDIT_HEIGHT      300 /**< System editor height. */


#define SYSEDIT_DRAG_THRESHOLD   300   /**< Drag threshold. */
#define SYSEDIT_MOVE_THRESHOLD   10    /**< Movement threshold. */


/*
 * Selection types.
 */
#define SELECT_NONE        0 /**< No selection. */
#define SELECT_PLANET      1 /**< Selection is a planet. */
#define SELECT_JUMPPOINT   2 /**< Selection is a jump point. */


/**
 * @brief Selection generic for stuff in a system.
 */
typedef struct Select_s {
   int type; /**< Type of selection. */
   union {
      int planet;
      int jump;
   } u; /**< Data itself. */
} Select_t;
static Select_t *sysedit_select  = NULL; /**< Current system selection. */
static int sysedit_nselect       = 0; /**< Number of selections in current system. */
static int sysedit_mselect       = 0; /**< Memory allocated for selections. */
static Select_t sysedit_tsel;         /**< Temporary selection. */
static int  sysedit_tadd         = 0; /**< Add to selection. */


static StarSystem *sysedit_sys = NULL; /**< Currently opened system. */
static unsigned int sysedit_wid = 0; /**< Sysedit wid. */
static double sysedit_xpos    = 0.; /**< Viewport X position. */
static double sysedit_ypos    = 0.; /**< Viewport Y position. */
static double sysedit_zoom    = 1.; /**< Viewport zoom level. */
static int sysedit_moved      = 0;  /**< Space moved since mouse down. */
static unsigned int sysedit_dragTime = 0; /**< Tick last started to drag. */
static int sysedit_drag       = 0;  /**< Dragging viewport around. */
static int sysedit_dragSel    = 0;  /**< Dragging system around. */


/*
 * Universe editor Prototypes.
 */
/* Custom system editor widget. */
static void sysedit_buttonZoom( unsigned int wid, char* str );
static void sysedit_render( double bx, double by, double w, double h, void *data );
static void sysedit_renderSprite( glTexture *gfx, double bx, double by, double x, double y,
      int sx, int sy, glColour *c, int selected, const char *caption );
static void sysedit_renderOverlay( double bx, double by, double bw, double bh, void* data );
static void sysedit_mouse( unsigned int wid, SDL_Event* event, double mx, double my,
      double w, double h, void *data );
/* Button functions. */
static void sysedit_close( unsigned int wid, char *wgt );
static void sysedit_save( unsigned int wid_unused, char *unused );
static void sysedit_btnNew( unsigned int wid_unused, char *unused );
static void sysedit_btnRename( unsigned int wid_unused, char *unused );
static void sysedit_btnRemove( unsigned int wid_unused, char *unused );
static void sysedit_btnReset( unsigned int wid_unused, char *unused );
static void sysedit_btnGFX( unsigned int wid_unused, char *unused );
/* Keybindings handling. */
static int sysedit_keys( unsigned int wid, SDLKey key, SDLMod mod );
/* Selection. */
static int sysedit_selectCmp( Select_t *a, Select_t *b );
static void sysedit_deselect (void);
static void sysedit_selectAdd( Select_t *sel );
static void sysedit_selectRm( Select_t *sel );


/**
 * @brief Opens the system editor interface.
 */
void sysedit_open( StarSystem *sys )
{
   unsigned int wid;

   /* Reconstructs the jumps - just in case. */
   systems_reconstructJumps();

   /* Reset some variables. */
   sysedit_sys    = sys;
   sysedit_drag   = 0;
   sysedit_zoom   = 0.5;
   sysedit_xpos   = 0.;
   sysedit_ypos   = 0.;

   /* Create the window. */
   wid = window_create( "Star System Editor", -1, -1, -1, -1 );
   window_handleKeys( wid, sysedit_keys );
   sysedit_wid = wid;

   /* Close button. */
   window_addButton( wid, -20, 20, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnClose", "Close", sysedit_close );

   /* Save button. */
   window_addButton( wid, -20, 20+(BUTTON_HEIGHT+20)*1, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnSave", "Save", sysedit_save );

   /* Reset. */
   window_addButton( wid, -20, 20+(BUTTON_HEIGHT+20)*3, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnReset", "Reset", sysedit_btnReset );

   /* GFX. */
   window_addButton( wid, -20, 20+(BUTTON_HEIGHT+20)*7, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnGFX", "GFX", sysedit_btnGFX );

   /* Remove. */
   window_addButton( wid, -20, 20+(BUTTON_HEIGHT+20)*4, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnRemove", "Remove", sysedit_btnRemove );

   /* Rename. */
   window_addButton( wid, -20, 20+(BUTTON_HEIGHT+20)*5, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnRename", "Rename", sysedit_btnRename );

   /* New system. */
   window_addButton( wid, -20, 20+(BUTTON_HEIGHT+20)*6, BUTTON_WIDTH, BUTTON_HEIGHT,
         "btnNew", "New Planet", sysedit_btnNew );

   /* Zoom buttons */
   window_addButton( wid, 40, 20, 30, 30, "btnZoomIn", "+", sysedit_buttonZoom );
   window_addButton( wid, 80, 20, 30, 30, "btnZoomOut", "-", sysedit_buttonZoom );

   /* Selected text. */
   window_addText( wid, 140, 10, SCREEN_W - 80 - 30 - 30 - BUTTON_WIDTH - 20, 30, 0,
         "txtSelected", &gl_smallFont, &cBlack, NULL );

   /* Actual viewport. */
   window_addCust( wid, 20, -40, SCREEN_W - 150, SCREEN_H - 100,
         "cstSysEdit", 1, sysedit_render, sysedit_mouse, NULL );
   window_custSetOverlay( wid, "cstSysEdit", sysedit_renderOverlay );

   /* Deselect everything. */
   sysedit_deselect();
}


/**
 * @brief Handles keybindings.
 */
static int sysedit_keys( unsigned int wid, SDLKey key, SDLMod mod )
{
   (void) wid;
   (void) mod;

   switch (key) {

      default:
         return 0;
   }
}


/**
 * @brief Closes the system editor widget.
 */
static void sysedit_close( unsigned int wid, char *wgt )
{
   /* Reconstruct jumps. */
   systems_reconstructJumps();

   /* Close the window. */
   window_close( wid, wgt );
}


/**
 * @brief Saves the systems.
 */
static void sysedit_save( unsigned int wid_unused, char *unused )
{
   (void) wid_unused;
   (void) unused;

   dsys_saveAll();
   dpl_saveAll();
}

/**
 * @brief Enters the editor in new system mode.
 */
static void sysedit_btnNew( unsigned int wid_unused, char *unused )
{
   (void) wid_unused;
   (void) unused;
   Planet *p, *b;
   char *name;

   /* Get new name. */
   name = dialogue_inputRaw( "New Planet Creation", 1, 32, "What do you want to name the new planet?" );
   if (name == NULL)
      return;

   /* Check for collision. */
   if (planet_exists( name )) {
      dialogue_alert( "Planet by the name of \er'%s'\e0 already exists in the \er'%s'\e0 system",
            name, planet_getSystem( name ) );
      free(name);
      sysedit_btnNew( 0, NULL );
      return;
   }

   /* Create the new planet. */
   p        = planet_new();
   p->name  = name;

   /* Base planet data off another. */
   b                    = planet_get( space_getRndPlanet() );
   p->gfx_space         = gl_dupTexture( b->gfx_space );
   p->gfx_spacePath     = strdup( b->gfx_spacePath );
   p->gfx_exterior      = strdup( b->gfx_exterior );
   p->gfx_exteriorPath  = strdup( b->gfx_exteriorPath );

   /* Add new planet. */
   system_addPlanet( sysedit_sys, name );
}


static void sysedit_btnRename( unsigned int wid_unused, char *unused )
{
   (void) wid_unused;
   (void) unused;
   int i;
   char *name;
   Select_t *sel;
   Planet *p;
   for (i=0; i<sysedit_nselect; i++) {
      sel = &sysedit_select[i];
      if (sel->type == SELECT_PLANET) {
         p = sysedit_sys[i].planets[ sel->u.planet ];

         /* Get new name. */
         name = dialogue_input( "New Planet Creation", 1, 32,
               "What do you want to rename the planet \er%s\e0?", p->name );
         if (name == NULL)
            continue;

         /* Check for collision. */
         if (planet_exists( name )) {
            dialogue_alert( "Planet by the name of \er'%s'\e0 already exists in the \er'%s'\e0 system",
                  name, planet_getSystem( name ) );
            free(name);
            continue;
         }

         /* Rename. */
         free(p->name);
         p->name = name;
      }
   }
}

static void sysedit_btnGFX( unsigned int wid_unused, char *unused )
{
   (void) wid_unused;
   (void) unused;
   int i;
   Select_t *sel;
   Planet *p, *b;
   for (i=0; i<sysedit_nselect; i++) {
      sel = &sysedit_select[i];
      if (sel->type == SELECT_PLANET) {
         p = sysedit_sys[i].planets[ sel->u.planet ];
        
         free(p->gfx_space);

         /* Base planet data off another. */
         b                    = planet_get( space_getRndPlanet() );
         p->gfx_space         = gl_dupTexture( b->gfx_space );
         p->gfx_spacePath     = strdup( b->gfx_spacePath );
      }
   }
}


static void sysedit_btnRemove( unsigned int wid_unused, char *unused )
{
   (void) wid_unused;
   (void) unused;
   Select_t *sel;
   int i;
   for (i=0; i<sysedit_nselect; i++) {
      sel = &sysedit_select[i];
      if (sel->type == SELECT_PLANET)
         system_rmPlanet( sysedit_sys, sysedit_sys->planets[ sel->u.planet ]->name );
   }
}


static void sysedit_btnReset( unsigned int wid_unused, char *unused )
{
   (void) wid_unused;
   (void) unused;
   Select_t *sel;
   int i;
   for (i=0; i<sysedit_nselect; i++) {
      sel = &sysedit_select[i];
      if (sel->type == SELECT_JUMPPOINT)
         sysedit_sys[i].jumps[ sel->u.jump ].flags |= JP_AUTOPOS;
   }

   /* Must reconstruct jumps. */
   systems_reconstructJumps();
}


/**
 * @brief System editor custom widget rendering.
 */
static void sysedit_render( double bx, double by, double w, double h, void *data )
{
   (void) data;
   int i, j;
   StarSystem *sys;
   Planet *p;
   JumpPoint *jp;
   double x,y;
   glColour *c;
   int selected;
   Select_t sel;

   /* Comfort++. */
   sys = sysedit_sys;

   /* Background */
   gl_renderRect( bx, by, w, h, &cBlack );

   /* Coordinate translation. */
   x = round((bx - sysedit_xpos + w/2) * 1.);
   y = round((by - sysedit_ypos + h/2) * 1.);

   /* Render planets. */
   for (i=0; i<sys->nplanets; i++) {
      p              = sys->planets[i];

      /* Check if selected. */
      sel.type       = SELECT_PLANET;
      sel.u.planet   = i;
      selected       = 0;
      for (j=0; j<sysedit_nselect; j++) {
         if (sysedit_selectCmp( &sel, &sysedit_select[j] )) {
            selected = 1;
            break;
         }
      }

      /* Render. */
      sysedit_renderSprite( p->gfx_space, x, y, p->pos.x, p->pos.y, 0, 0, NULL, selected, p->name );
   }

   /* Render jump points. */
   for (i=0; i<sys->njumps; i++) {
      jp    = &sys->jumps[i];

      /* Choose colour. */
      if (jp->flags & JP_AUTOPOS)
         c = &cGreen;
      else
         c = NULL;

      /* Check if selected. */
      sel.type       = SELECT_JUMPPOINT;
      sel.u.planet   = i;
      selected       = 0;
      for (j=0; j<sysedit_nselect; j++) {
         if (sysedit_selectCmp( &sel, &sysedit_select[j] )) {
            selected = 1;
            break;
         }
      }

      /* Render. */
      sysedit_renderSprite( jumppoint_gfx, x, y, jp->pos.x, jp->pos.y, jp->sx, jp->sy, c, selected, jp->target->name );
   }
}


/**
 * @brief Renders a sprite for the custom widget.
 */
static void sysedit_renderSprite( glTexture *gfx, double bx, double by, double x, double y,
      int sx, int sy, glColour *c, int selected, const char *caption )
{
   double tx, ty, z;
   glColour cc, *col;

   /* Comfort. */
   z  = sysedit_zoom;

   /* Translate coords. */
   tx = bx + (x - gfx->sw/2.)*z + SCREEN_W/2.;
   ty = by + (y - gfx->sh/2.)*z + SCREEN_H/2.;

   /* Selection graphic. */
   if (selected) {
      cc.r = cFontBlue.r;
      cc.g = cFontBlue.g;
      cc.b = cFontBlue.b;
      cc.a = 0.5;
      gl_drawCircle( bx + x*z, by + y*z, gfx->sw*z*1.1, &cc, 1 );
   }

   /* Blit the planet. */
   gl_blitScaleSprite( gfx, tx, ty, sx, sy, gfx->sw*z, gfx->sh*z, c );

   /* Display caption. */
   if (caption != NULL) {
      if (selected)
         col = &cRed;
      else
         col = c;
      gl_printMidRaw( &gl_smallFont, gfx->sw*z+100,
            tx - 50, ty - gl_smallFont.h - 5, col, caption );
   }
}


/**
 * @brief Renders the overlay.
 */
static void sysedit_renderOverlay( double bx, double by, double bw, double bh, void* data )
{
   (void) bx;
   (void) by;
   (void) bw;
   (void) bh;
   (void) data;
}

/**
 * @brief System editor custom widget mouse handling.
 */
static void sysedit_mouse( unsigned int wid, SDL_Event* event, double mx, double my,
      double w, double h, void *data )
{
   (void) wid;
   (void) data;
   int i, j;
   double x,y, t;
   SDLMod mod;
   StarSystem *sys;
   Planet *p;
   JumpPoint *jp;
   Select_t sel;

   /* Comfort. */
   sys = sysedit_sys;

   /* Handle modifiers. */
   mod = SDL_GetModState();

   switch (event->type) {
      
      case SDL_MOUSEBUTTONDOWN:
         /* Must be in bounds. */
         if ((mx < 0.) || (mx > w) || (my < 0.) || (my > h))
            return;

         /* Zooming */
         if (event->button.button == SDL_BUTTON_WHEELUP)
            sysedit_buttonZoom( 0, "btnZoomIn" );
         else if (event->button.button == SDL_BUTTON_WHEELDOWN)
            sysedit_buttonZoom( 0, "btnZoomOut" );

         /* selecting star system */
         else {
            mx -= w/2 - sysedit_xpos;
            my -= h/2 - sysedit_ypos;


            /* Check planets. */
            for (i=0; i<sys->nplanets; i++) {
               p = sys->planets[i];

               /* Position. */
               x = p->pos.x * sysedit_zoom;
               y = p->pos.y * sysedit_zoom;

               /* Set selection. */
               sel.type       = SELECT_PLANET;
               sel.u.planet   = i;

               /* Threshold. */
               t  = p->gfx_space->sw * p->gfx_space->sh / 4.; /* Radius^2 */
               t *= pow2(sysedit_zoom);

               /* Can select. */
               if ((pow2(mx-x)+pow2(my-y)) < t) {

                  /* Check if already selected. */
                  for (j=0; j<sysedit_nselect; j++) {
                     if (sysedit_selectCmp( &sel, &sysedit_select[j] )) {
                        sysedit_dragSel   = 1;
                        memcpy( &sysedit_tsel, &sel, sizeof(Select_t) );

                        /* Check modifier. */
                        if (mod & (KMOD_LCTRL | KMOD_RCTRL))
                           sysedit_tadd      = 0;
                        else
                           sysedit_tadd      = -1;
                        sysedit_dragTime  = SDL_GetTicks();
                        sysedit_moved     = 0;
                        return;
                     }
                  }

                  /* Add the system if not selected. */
                  if (mod & (KMOD_LCTRL | KMOD_RCTRL))
                     sysedit_selectAdd( &sel );
                  else {
                     sysedit_deselect();
                     sysedit_selectAdd( &sel );
                  }
                  sysedit_tsel.type = SELECT_NONE;

                  /* Start dragging anyway. */
                  sysedit_dragSel   = 1;
                  sysedit_dragTime  = SDL_GetTicks();
                  sysedit_moved     = 0;
                  return;
               }
            }

            /* Check jump points. */
            for (i=0; i<sys->njumps; i++) {
               jp = &sys->jumps[i];
               p = sys->planets[i];

               /* Position. */
               x = jp->pos.x * sysedit_zoom;
               y = jp->pos.y * sysedit_zoom;

               /* Set selection. */
               sel.type       = SELECT_JUMPPOINT;
               sel.u.planet   = i;

               /* Threshold. */
               t  = jumppoint_gfx->sw * jumppoint_gfx->sh / 4.; /* Radius^2 */
               t *= pow2(sysedit_zoom);

               /* Can select. */
               if ((pow2(mx-x)+pow2(my-y)) < t) {

                  /* Check if already selected. */
                  for (j=0; j<sysedit_nselect; j++) {
                     if (sysedit_selectCmp( &sel, &sysedit_select[j] )) {
                        sysedit_dragSel   = 1;
                        memcpy( &sysedit_tsel, &sel, sizeof(Select_t) );

                        /* Check modifier. */
                        if (mod & (KMOD_LCTRL | KMOD_RCTRL))
                           sysedit_tadd      = 0;
                        else
                           sysedit_tadd      = -1;
                        sysedit_dragTime  = SDL_GetTicks();
                        sysedit_moved     = 0;
                        return;
                     }
                  }

                  /* Add the system if not selected. */
                  if (mod & (KMOD_LCTRL | KMOD_RCTRL))
                     sysedit_selectAdd( &sel );
                  else {
                     sysedit_deselect();
                     sysedit_selectAdd( &sel );
                  }
                  sysedit_tsel.type = SELECT_NONE;

                  /* Start dragging anyway. */
                  sysedit_dragSel   = 1;
                  sysedit_dragTime  = SDL_GetTicks();
                  sysedit_moved     = 0;
                  return;
               }
            }

            /* Start dragging. */
            if (!(mod & (KMOD_LCTRL | KMOD_RCTRL))) {
               sysedit_drag      = 1;
               sysedit_dragTime  = SDL_GetTicks();
               sysedit_moved     = 0;
               sysedit_tsel.type = SELECT_NONE;
            }
            return;
         }
         break;

      case SDL_MOUSEBUTTONUP:
         if (sysedit_drag) {
            if ((SDL_GetTicks() - sysedit_dragTime < SYSEDIT_DRAG_THRESHOLD) && (sysedit_moved < SYSEDIT_MOVE_THRESHOLD)) {
               if (sysedit_tsel.type == SELECT_NONE)
                  sysedit_deselect();
               else
                  sysedit_selectAdd( &sysedit_tsel );
            }
            sysedit_drag      = 0;
         }
         if (sysedit_dragSel) {
            if ((SDL_GetTicks() - sysedit_dragTime < SYSEDIT_DRAG_THRESHOLD) &&
                  (sysedit_moved < SYSEDIT_MOVE_THRESHOLD) && (sysedit_tsel.type != SELECT_NONE)) {
               if (sysedit_tadd == 0)
                  sysedit_selectRm( &sysedit_tsel );
               else {
                  sysedit_deselect();
                  sysedit_selectAdd( &sysedit_tsel );
               }
            }
            sysedit_dragSel   = 0;
         }
         break;

      case SDL_MOUSEMOTION:
         /* Handle dragging. */
         if (sysedit_drag) {
            /* axis is inverted */
            sysedit_xpos -= event->motion.xrel;
            sysedit_ypos += event->motion.yrel;

            /* Update mousemovement. */
            sysedit_moved += ABS( event->motion.xrel ) + ABS( event->motion.yrel );
         }
         /* Dragging selection around. */
         else if (sysedit_dragSel && (sysedit_nselect > 0)) {
            if ((sysedit_moved > SYSEDIT_MOVE_THRESHOLD) || (SDL_GetTicks() - sysedit_dragTime > SYSEDIT_DRAG_THRESHOLD)) {
               for (i=0; i<sysedit_nselect; i++) {

                  /* Planets. */
                  if (sysedit_select[i].type == SELECT_PLANET) {
                     p = sys->planets[ sysedit_select[i].u.planet ];
                     p->pos.x += ((double)event->motion.xrel) / sysedit_zoom;
                     p->pos.y -= ((double)event->motion.yrel) / sysedit_zoom;
                  }
                  /* Jump point. */
                  else if (sysedit_select[i].type == SELECT_JUMPPOINT) {
                     jp         = &sys->jumps[ sysedit_select[i].u.jump ];
                     jp->flags &= ~(JP_AUTOPOS);
                     jp->pos.x += ((double)event->motion.xrel) / sysedit_zoom;
                     jp->pos.y -= ((double)event->motion.yrel) / sysedit_zoom;
                  }
               }
            }

            /* Update mousemovement. */
            sysedit_moved += ABS( event->motion.xrel ) + ABS( event->motion.yrel );
         }
         break;
   }
}


/**
 * @brief Handles the button zoom clicks.
 *
 *    @param wid Unused.
 *    @param str Name of the button creating the event.
 */
static void sysedit_buttonZoom( unsigned int wid, char* str )
{
   (void) wid;

   /* Transform coords to normal. */
   sysedit_xpos /= sysedit_zoom;
   sysedit_ypos /= sysedit_zoom;

   /* Apply zoom. */
   if (strcmp(str,"btnZoomIn")==0) {
      sysedit_zoom *= 1.2;
      sysedit_zoom = MIN(1., sysedit_zoom);
   }
   else if (strcmp(str,"btnZoomOut")==0) {
      sysedit_zoom *= 0.8;
      sysedit_zoom = MAX(0.10, sysedit_zoom);
   }

   /* Transform coords back. */
   sysedit_xpos *= sysedit_zoom;
   sysedit_ypos *= sysedit_zoom;
}


/**
 * @brief Deselects everything.
 */
static void sysedit_deselect (void)
{
   if (sysedit_nselect > 0)
      free( sysedit_select );
   sysedit_select    = NULL;
   sysedit_nselect   = 0;
   sysedit_mselect   = 0;
}


/**
 * @brief Adds a system to the selection.
 */
static void sysedit_selectAdd( Select_t *sel )
{
   /* Allocate if needed. */
   if (sysedit_mselect < sysedit_nselect+1) {
      if (sysedit_mselect == 0)
         sysedit_mselect = 1;
      sysedit_mselect  *= 2;
      sysedit_select    = realloc( sysedit_select,
            sizeof(Select_t) * sysedit_mselect );
   }

   /* Add system. */
   memcpy( &sysedit_select[ sysedit_nselect ], sel, sizeof(Select_t) );
   sysedit_nselect++;

}


/**
 * @brief Removes a system from the selection.
 */
static void sysedit_selectRm( Select_t *sel )
{
   int i;
   for (i=0; i<sysedit_nselect; i++) {
      if (sysedit_selectCmp( &sysedit_select[i], sel )) {
         sysedit_nselect--;
         memmove( &sysedit_select[i], &sysedit_select[i+1],
               sizeof(Select_t) * (sysedit_nselect - i) );
         return;
      }
   }
   WARN("Trying to unselect item that is not in selection!");
}


/**
 * @brief Compares two selections to see if they are the same.
 *
 *    @return 1 if both selections are the same.
 */
static int sysedit_selectCmp( Select_t *a, Select_t *b )
{
   return (memcmp(a, b, sizeof(Select_t)) == 0);
}


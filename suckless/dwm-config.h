/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const char col_bar_bg[]     = "#220022";
static const char col_bar_fg[]     = "#eeeeee";
static const char col_bar_sel_bg[] = "#cc0077";
static const char col_bar_sel_fg[] = "#ffff00";

static const char col_border[]     = "#220022";
static const char col_border_sel[] = "#cc0077";

static const char col_dmenu_bg[]     = "#220022";
static const char col_dmenu_fg[]     = "#eeeeee";
static const char col_dmenu_sel_bg[] = "#cc0077";
static const char col_dmenu_sel_fg[] = "#000000";

static const char normbordercolor[] = "#220022";
static const char normbgcolor[]     = "#220022";
static const char normfgcolor[]     = "#eeeeee";
static const char selbordercolor[]  = "#cc0077";
static const char selbgcolor[]      = "#cc0077";
static const char selfgcolor[]      = "#ffff00";

static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 1;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Inconsolata:size=10" };
static const char dmenufont[]       = "Inconsolata:size=24";

static const char *colors[][3]      = {
	/*               fg               bg               border   */
	[SchemeNorm] = { col_bar_fg,      col_bar_bg,      col_border      },
	[SchemeSel]  = { col_bar_sel_fg,  col_bar_sel_bg,  col_border_sel  },
};

/* tagging */
static const char *tags[] = { "1. tty", "2. chrome", "3. slack", "4. opera", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class            instance        title                   tags mask   isfloating   monitor */
	{ "Gimp",          NULL,            NULL,                   0,          1,           -1 },
	{ NULL,            NULL,            "Picture in Picture",   0,          1,           -1 },
	{ "Google-chrome", "google-chrome", NULL,                   1 << 1,     0,           -1 },
	{ "Slack",         "slack",         NULL,                   1 << 2,     0,           -1 },
	{ "Opera",         "Opera",         NULL,                   1 << 3,     0,           -1 },
	{ "zoom",          "zoom",          "Zoom Cloud Meetings",  1 << 4,     1,           -1 },
	{ "zoom",          "zoom",          "Zoom Meeting",         1 << 5,     0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]      = {
  "dmenu_run",
  // prompt
  "-p", "run:",
  "-i",
  // render at the bottom of the screen
  "-b",
  // use this font
  "-fn", dmenufont,
  // normal background and foreground colors (not selected)
  "-nb", col_dmenu_bg, "-nf", col_dmenu_fg,
  // selected background and foreground colors
  "-sb", col_dmenu_sel_bg, "-sf", col_dmenu_sel_fg,
  // end of the list
  NULL
};
static const char *termcmd[]       = { "st", "-e", "tmux", NULL };
static const char *slockcmd[]      = { "slock", NULL };
static const char *powercmd[]      = { "power-menu", NULL };
static const char *brightupcmd[]   = { "brightnessctl", "-d", "intel_backlight", "set", "+10%" };
static const char *brightdowncmd[] = { "brightnessctl", "-d", "intel_backlight", "set", "-10%" };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_t,      spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          {.v = slockcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_p,      setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_p,      togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      spawn,          {.v = powercmd} },
	{ MODKEY|ShiftMask,             XK_c,      quit,           {0} },

	{ 0,   XF86XK_MonBrightnessUp,             spawn,          {.v = brightupcmd} },
	{ 0,   XF86XK_MonBrightnessDown,           spawn,          {.v = brightdowncmd} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};


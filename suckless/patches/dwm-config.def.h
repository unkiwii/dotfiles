diff --git a/config.def.h b/config.def.h
index 9efa774..4c61813 100644
--- a/config.def.h
+++ b/config.def.h
@@ -1,34 +1,64 @@
 /* See LICENSE file for copyright and license details. */
 
+#include <X11/XF86keysym.h>
+
+/* /1* purple-pink skin *1/ */
+/* #define COLOR_BG "#220022" */
+/* #define COLOR_FG "#eeeeee" */
+/* #define COLOR_SEL_BG "#cc0077" */
+/* #define COLOR_SEL_FG "#ffff00" */
+/* #define COLOR_SEL_FG2 "#000000" */
+
+/* grey-orange skin */
+#define COLOR_BG "#222222"
+#define COLOR_FG "#eeeeee"
+#define COLOR_SEL_BG "#cc7700"
+#define COLOR_SEL_FG "#000000"
+#define COLOR_SEL_FG2 "#000000"
+
+static const char col_bar_bg[]     = COLOR_BG;
+static const char col_bar_fg[]     = COLOR_FG;
+static const char col_bar_sel_bg[] = COLOR_SEL_BG;
+static const char col_bar_sel_fg[] = COLOR_SEL_FG;
+
+static const char col_border[]     = COLOR_BG;
+static const char col_border_sel[] = COLOR_SEL_BG;
+
+static const char col_dmenu_bg[]     = COLOR_BG;
+static const char col_dmenu_fg[]     = COLOR_FG;
+static const char col_dmenu_sel_bg[] = COLOR_SEL_BG;
+static const char col_dmenu_sel_fg[] = COLOR_SEL_FG2;
+
 /* appearance */
-static const unsigned int borderpx  = 1;        /* border pixel of windows */
-static const unsigned int snap      = 32;       /* snap pixel */
+static const unsigned int borderpx  = 2;        /* border pixel of windows */
+static const unsigned int snap      = 1;        /* snap pixel */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
-static const char *fonts[]          = { "monospace:size=10" };
-static const char dmenufont[]       = "monospace:size=10";
-static const char col_gray1[]       = "#222222";
-static const char col_gray2[]       = "#444444";
-static const char col_gray3[]       = "#bbbbbb";
-static const char col_gray4[]       = "#eeeeee";
-static const char col_cyan[]        = "#005577";
+static const char *fonts[]          = { "InconsolataForPowerline Nerd Font:size=10" };
+static const char dmenufont[]       = "InconsolataForPowerline Nerd Font:size=24";
+
 static const char *colors[][3]      = {
-	/*               fg         bg         border   */
-	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
-	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
+	/*               fg               bg               border   */
+	[SchemeNorm] = { col_bar_fg,      col_bar_bg,      col_border      },
+	[SchemeSel]  = { col_bar_sel_fg,  col_bar_sel_bg,  col_border_sel  },
 };
 
 /* tagging */
-static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
+static const char *tags[] = { "1. tty", "2. www", "3. slack", "4. fun", "5", "6", "7", "8", "9" };
 
 static const Rule rules[] = {
 	/* xprop(1):
 	 *	WM_CLASS(STRING) = instance, class
 	 *	WM_NAME(STRING) = title
 	 */
-	/* class      instance    title       tags mask     isfloating   monitor */
-	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
-	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
+	/* class            instance        title                   tags mask   isfloating   monitor */
+	{ "Gimp",          NULL,            NULL,                   0,          1,           -1 },
+	{ NULL,            NULL,            "Picture in Picture",   0,          1,           -1 },
+	{ "Google-chrome", "google-chrome", NULL,                   1 << 1,     0,           -1 },
+	{ "Slack",         "slack",         NULL,                   1 << 2,     0,           -1 },
+	{ "Firefox",       NULL,            NULL,                   1 << 3,     0,           -1 },
+	{ "zoom",          "zoom",          "Zoom Cloud Meetings",  1 << 8,     1,           -1 },
+	{ "zoom",          "zoom",          "Zoom Meeting",         1 << 5,     0,           -1 },
 };
 
 /* layout(s) */
@@ -45,7 +75,7 @@ static const Layout layouts[] = {
 };
 
 /* key definitions */
-#define MODKEY Mod1Mask
+#define MODKEY Mod4Mask
 #define TAGKEYS(KEY,TAG) \
 	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
@@ -57,28 +87,31 @@ static const Layout layouts[] = {
 
 /* commands */
 static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
-static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
-static const char *termcmd[]  = { "st", NULL };
+static const char *dmenucmd[]      = { "dmenu_run", "-p", "run:", "-i", "-b", "-m", dmenumon, "-fn", dmenufont, "-nb", col_dmenu_bg, "-nf", col_dmenu_fg, "-sb", col_dmenu_sel_bg, "-sf", col_dmenu_sel_fg, NULL };
+static const char *termcmd[]       = { "st", "-e", "tmux", NULL };
+static const char *slockcmd[]      = { "slock", NULL };
+static const char *powercmd[]      = { "power-menu", NULL };
 
 static const Key keys[] = {
 	/* modifier                     key        function        argument */
-	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
-	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
+	{ MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
+	{ MODKEY|ShiftMask,             XK_t,      spawn,          {.v = termcmd } },
+	{ MODKEY|ShiftMask,             XK_l,      spawn,          {.v = slockcmd } },
 	{ MODKEY,                       XK_b,      togglebar,      {0} },
 	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
 	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
-	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
-	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
+	{ MODKEY|ShiftMask,             XK_j,      incnmaster,     {.i = +1 } },
+	{ MODKEY|ShiftMask,             XK_k,      incnmaster,     {.i = -1 } },
 	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
 	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
 	{ MODKEY,                       XK_Return, zoom,           {0} },
 	{ MODKEY,                       XK_Tab,    view,           {0} },
-	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
+	{ MODKEY,                       XK_q,      killclient,     {0} },
 	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
 	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
 	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
-	{ MODKEY,                       XK_space,  setlayout,      {0} },
-	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
+	{ MODKEY,                       XK_p,      setlayout,      {0} },
+	{ MODKEY|ShiftMask,             XK_p,      togglefloating, {0} },
 	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
 	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
 	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
@@ -94,7 +127,8 @@ static const Key keys[] = {
 	TAGKEYS(                        XK_7,                      6)
 	TAGKEYS(                        XK_8,                      7)
 	TAGKEYS(                        XK_9,                      8)
-	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
+	{ MODKEY|ShiftMask,             XK_q,      spawn,          {.v = powercmd} },
+	{ MODKEY|ShiftMask,             XK_c,      quit,           {0} },
 };
 
 /* button definitions */

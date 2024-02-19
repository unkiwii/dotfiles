diff --git a/config.def.h b/config.def.h
index 061ad66..21269ac 100644
--- a/config.def.h
+++ b/config.def.h
@@ -1,38 +1,74 @@
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
+static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
+static const unsigned int systrayonleft = 1;    /* 0: systray in the right corner, >0: systray on left of status text */
+static const unsigned int systrayspacing = 2;   /* systray spacing */
+static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
+static const int showsystray        = 1;        /* 0 means no systray */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
-static const char *fonts[]          = { "monospace:size=10" };
-static const char dmenufont[]       = "monospace:size=10";
-static const char col_gray1[]       = "#222222";
-static const char col_gray2[]       = "#444444";
-static const char col_gray3[]       = "#bbbbbb";
-static const char col_gray4[]       = "#eeeeee";
-static const char col_cyan[]        = "#005577";
+static const char *fonts[]          = { "Inconsolata Nerd Font Mono:size=10" };
+static const char dmenufont[]       = "Inconsolata Nerd Font Mono:size=24";
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
+	{ "Firefox-esr",   "Toolkit",       "Picture-in-Picture",   0,          1,           -1 },
+	{ "Google-chrome", "google-chrome", NULL,                   1 << 1,     0,           -1 },
+	{ "Slack",         "slack",         NULL,                   1 << 2,     0,           -1 },
+	{ "Firefox",       NULL,            NULL,                   1 << 3,     0,           -1 },
+	{ "zoom",          "zoom",          "Zoom Meeting",         1 << 6,     0,           -1 },
+	{ "zoom",          "zoom",          "Zoom Cloud Meetings",  1 << 7,     1,           -1 },
+	{ "st-256color",   "st-256color",   "clock",                1 << 8,     0,           -1 },
 };
 
 /* layout(s) */
-static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
+static const float mfact     = 0.5;  /* factor of master area size [0.05..0.95] */
 static const int nmaster     = 1;    /* number of clients in master area */
 static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
 static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
@@ -45,7 +81,7 @@ static const Layout layouts[] = {
 };
 
 /* key definitions */
-#define MODKEY Mod1Mask
+#define MODKEY Mod4Mask
 #define TAGKEYS(KEY,TAG) \
 	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
@@ -56,28 +92,39 @@ static const Layout layouts[] = {
 #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
 
 /* commands */
-static const char *dmenucmd[] = { "dmenu_run", "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
-static const char *termcmd[]  = { "st", NULL };
+static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
+static const char *dmenucmd[]      = { "dmenu_run", "-p", "run:", "-i", "-b", "-m", dmenumon, "-fn", dmenufont, "-nb", col_dmenu_bg, "-nf", col_dmenu_fg, "-sb", col_dmenu_sel_bg, "-sf", col_dmenu_sel_fg, NULL };
+static const char *termcmd[]       = { "st", "-e", "tmux", NULL };
+static const char *slockcmd[]      = { "slock", NULL };
+static const char *powercmd[]      = { "power-menu", NULL };
+static const char *upvol[]         = { "/usr/bin/wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+",    NULL };
+static const char *downvol[]       = { "/usr/bin/wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-",    NULL };
+static const char *mutevol[]       = { "/usr/bin/wpctl", "set-mute",   "@DEFAULT_AUDIO_SINK@", "toggle", NULL };
+static const char *upbright[]      = { "/usr/bin/brightnessctl", "set", "10%+", NULL };
+static const char *downbright[]    = { "/usr/bin/brightnessctl", "set", "10%-", NULL };
+static const char *screenshot[]    = { "scrot", NULL };
+static const char *screenshotsel[] = { "scrot", "-s", NULL };
 
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
@@ -93,7 +140,19 @@ static const Key keys[] = {
 	TAGKEYS(                        XK_7,                      6)
 	TAGKEYS(                        XK_8,                      7)
 	TAGKEYS(                        XK_9,                      8)
-	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
+	{ MODKEY|ShiftMask,             XK_q,      spawn,          {.v = powercmd} },
+	{ MODKEY|ShiftMask,             XK_c,      quit,           {0} },
+
+	/* Print whole screen or select region, with 0 is just the key directly */
+	{ 0,      XK_Print, spawn, {.v = screenshot    } },
+	{ MODKEY, XK_Print, spawn, {.v = screenshotsel } },
+
+	/* With 0 as modifier, you are able to use the keys directly. */
+	{ 0, XF86XK_AudioRaiseVolume,  spawn, {.v = upvol      } },
+	{ 0, XF86XK_AudioLowerVolume,  spawn, {.v = downvol    } },
+	{ 0, XF86XK_AudioMute,         spawn, {.v = mutevol    } },
+	{ 0, XF86XK_MonBrightnessUp,   spawn, {.v = upbright   } },
+	{ 0, XF86XK_MonBrightnessDown, spawn, {.v = downbright } },
 };
 
 /* button definitions */
diff --git a/dwm.c b/dwm.c
index e5efb6a..97f579b 100644
--- a/dwm.c
+++ b/dwm.c
@@ -57,12 +57,27 @@
 #define TAGMASK                 ((1 << LENGTH(tags)) - 1)
 #define TEXTW(X)                (drw_fontset_getwidth(drw, (X)) + lrpad)
 
+#define SYSTEM_TRAY_REQUEST_DOCK    0
+/* XEMBED messages */
+#define XEMBED_EMBEDDED_NOTIFY      0
+#define XEMBED_WINDOW_ACTIVATE      1
+#define XEMBED_FOCUS_IN             4
+#define XEMBED_MODALITY_ON         10
+#define XEMBED_MAPPED              (1 << 0)
+#define XEMBED_WINDOW_ACTIVATE      1
+#define XEMBED_WINDOW_DEACTIVATE    2
+#define VERSION_MAJOR               0
+#define VERSION_MINOR               0
+#define XEMBED_EMBEDDED_VERSION (VERSION_MAJOR << 16) | VERSION_MINOR
+
 /* enums */
 enum { CurNormal, CurResize, CurMove, CurLast }; /* cursor */
 enum { SchemeNorm, SchemeSel }; /* color schemes */
 enum { NetSupported, NetWMName, NetWMState, NetWMCheck,
+       NetSystemTray, NetSystemTrayOP, NetSystemTrayOrientation, NetSystemTrayOrientationHorz,
        NetWMFullscreen, NetActiveWindow, NetWMWindowType,
        NetWMWindowTypeDialog, NetClientList, NetLast }; /* EWMH atoms */
+enum { Manager, Xembed, XembedInfo, XLast }; /* Xembed atoms */
 enum { WMProtocols, WMDelete, WMState, WMTakeFocus, WMLast }; /* default atoms */
 enum { ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle,
        ClkClientWin, ClkRootWin, ClkLast }; /* clicks */
@@ -141,6 +156,12 @@ typedef struct {
 	int monitor;
 } Rule;
 
+typedef struct Systray   Systray;
+struct Systray {
+	Window win;
+	Client *icons;
+};
+
 /* function declarations */
 static void applyrules(Client *c);
 static int applysizehints(Client *c, int *x, int *y, int *w, int *h, int interact);
@@ -172,6 +193,7 @@ static void focusstack(const Arg *arg);
 static Atom getatomprop(Client *c, Atom prop);
 static int getrootptr(int *x, int *y);
 static long getstate(Window w);
+static unsigned int getsystraywidth();
 static int gettextprop(Window w, Atom atom, char *text, unsigned int size);
 static void grabbuttons(Client *c, int focused);
 static void grabkeys(void);
@@ -189,13 +211,16 @@ static void pop(Client *c);
 static void propertynotify(XEvent *e);
 static void quit(const Arg *arg);
 static Monitor *recttomon(int x, int y, int w, int h);
+static void removesystrayicon(Client *i);
 static void resize(Client *c, int x, int y, int w, int h, int interact);
+static void resizebarwin(Monitor *m);
 static void resizeclient(Client *c, int x, int y, int w, int h);
 static void resizemouse(const Arg *arg);
+static void resizerequest(XEvent *e);
 static void restack(Monitor *m);
 static void run(void);
 static void scan(void);
-static int sendevent(Client *c, Atom proto);
+static int sendevent(Window w, Atom proto, int m, long d0, long d1, long d2, long d3, long d4);
 static void sendmon(Client *c, Monitor *m);
 static void setclientstate(Client *c, long state);
 static void setfocus(Client *c);
@@ -207,6 +232,7 @@ static void seturgent(Client *c, int urg);
 static void showhide(Client *c);
 static void sigchld(int unused);
 static void spawn(const Arg *arg);
+static Monitor *systraytomon(Monitor *m);
 static void tag(const Arg *arg);
 static void tagmon(const Arg *arg);
 static void tile(Monitor *m);
@@ -224,18 +250,23 @@ static int updategeom(void);
 static void updatenumlockmask(void);
 static void updatesizehints(Client *c);
 static void updatestatus(void);
+static void updatesystray(void);
+static void updatesystrayicongeom(Client *i, int w, int h);
+static void updatesystrayiconstate(Client *i, XPropertyEvent *ev);
 static void updatetitle(Client *c);
 static void updatewindowtype(Client *c);
 static void updatewmhints(Client *c);
 static void view(const Arg *arg);
 static Client *wintoclient(Window w);
 static Monitor *wintomon(Window w);
+static Client *wintosystrayicon(Window w);
 static int xerror(Display *dpy, XErrorEvent *ee);
 static int xerrordummy(Display *dpy, XErrorEvent *ee);
 static int xerrorstart(Display *dpy, XErrorEvent *ee);
 static void zoom(const Arg *arg);
 
 /* variables */
+static Systray *systray = NULL;
 static const char broken[] = "broken";
 static char stext[256];
 static int screen;
@@ -258,9 +289,10 @@ static void (*handler[LASTEvent]) (XEvent *) = {
 	[MapRequest] = maprequest,
 	[MotionNotify] = motionnotify,
 	[PropertyNotify] = propertynotify,
+	[ResizeRequest] = resizerequest,
 	[UnmapNotify] = unmapnotify
 };
-static Atom wmatom[WMLast], netatom[NetLast];
+static Atom wmatom[WMLast], netatom[NetLast], xatom[XLast];
 static int running = 1;
 static Cur *cursor[CurLast];
 static Clr **scheme;
@@ -442,7 +474,7 @@ buttonpress(XEvent *e)
 			arg.ui = 1 << i;
 		} else if (ev->x < x + TEXTW(selmon->ltsymbol))
 			click = ClkLtSymbol;
-		else if (ev->x > selmon->ww - (int)TEXTW(stext))
+		else if (ev->x > selmon->ww - (int)TEXTW(stext) - getsystraywidth())
 			click = ClkStatusText;
 		else
 			click = ClkWinTitle;
@@ -485,6 +517,13 @@ cleanup(void)
 	XUngrabKey(dpy, AnyKey, AnyModifier, root);
 	while (mons)
 		cleanupmon(mons);
+
+	if (showsystray) {
+		XUnmapWindow(dpy, systray->win);
+		XDestroyWindow(dpy, systray->win);
+		free(systray);
+	}
+
 	for (i = 0; i < CurLast; i++)
 		drw_cur_free(drw, cursor[i]);
 	for (i = 0; i < LENGTH(colors); i++)
@@ -516,9 +555,58 @@ cleanupmon(Monitor *mon)
 void
 clientmessage(XEvent *e)
 {
+	XWindowAttributes wa;
+	XSetWindowAttributes swa;
 	XClientMessageEvent *cme = &e->xclient;
 	Client *c = wintoclient(cme->window);
 
+	if (showsystray && cme->window == systray->win && cme->message_type == netatom[NetSystemTrayOP]) {
+		/* add systray icons */
+		if (cme->data.l[1] == SYSTEM_TRAY_REQUEST_DOCK) {
+			if (!(c = (Client *)calloc(1, sizeof(Client))))
+				die("fatal: could not malloc() %u bytes\n", sizeof(Client));
+			if (!(c->win = cme->data.l[2])) {
+				free(c);
+				return;
+			}
+			c->mon = selmon;
+			c->next = systray->icons;
+			systray->icons = c;
+			if (!XGetWindowAttributes(dpy, c->win, &wa)) {
+				/* use sane defaults */
+				wa.width = bh;
+				wa.height = bh;
+				wa.border_width = 0;
+			}
+			c->x = c->oldx = c->y = c->oldy = 0;
+			c->w = c->oldw = wa.width;
+			c->h = c->oldh = wa.height;
+			c->oldbw = wa.border_width;
+			c->bw = 0;
+			c->isfloating = True;
+			/* reuse tags field as mapped status */
+			c->tags = 1;
+			updatesizehints(c);
+			updatesystrayicongeom(c, wa.width, wa.height);
+			XAddToSaveSet(dpy, c->win);
+			XSelectInput(dpy, c->win, StructureNotifyMask | PropertyChangeMask | ResizeRedirectMask);
+			XReparentWindow(dpy, c->win, systray->win, 0, 0);
+			/* use parents background color */
+			swa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
+			XChangeWindowAttributes(dpy, c->win, CWBackPixel, &swa);
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_EMBEDDED_NOTIFY, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			/* FIXME not sure if I have to send these events, too */
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_FOCUS_IN, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_WINDOW_ACTIVATE, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			sendevent(c->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_MODALITY_ON, 0 , systray->win, XEMBED_EMBEDDED_VERSION);
+			XSync(dpy, False);
+			resizebarwin(selmon);
+			updatesystray();
+			setclientstate(c, NormalState);
+		}
+		return;
+	}
+
 	if (!c)
 		return;
 	if (cme->message_type == netatom[NetWMState]) {
@@ -571,7 +659,7 @@ configurenotify(XEvent *e)
 				for (c = m->clients; c; c = c->next)
 					if (c->isfullscreen)
 						resizeclient(c, m->mx, m->my, m->mw, m->mh);
-				XMoveResizeWindow(dpy, m->barwin, m->wx, m->by, m->ww, bh);
+				resizebarwin(m);
 			}
 			focus(NULL);
 			arrange(NULL);
@@ -656,6 +744,11 @@ destroynotify(XEvent *e)
 
 	if ((c = wintoclient(ev->window)))
 		unmanage(c, 1);
+	else if ((c = wintosystrayicon(ev->window))) {
+		removesystrayicon(c);
+		resizebarwin(selmon);
+		updatesystray();
+	}
 }
 
 void
@@ -699,7 +792,7 @@ dirtomon(int dir)
 void
 drawbar(Monitor *m)
 {
-	int x, w, tw = 0;
+	int x, w, tw = 0, stw = 0;
 	int boxs = drw->fonts->h / 9;
 	int boxw = drw->fonts->h / 6 + 2;
 	unsigned int i, occ = 0, urg = 0;
@@ -708,13 +801,17 @@ drawbar(Monitor *m)
 	if (!m->showbar)
 		return;
 
+	if(showsystray && m == systraytomon(m) && !systrayonleft)
+		stw = getsystraywidth();
+
 	/* draw status first so it can be overdrawn by tags later */
 	if (m == selmon) { /* status is only drawn on selected monitor */
 		drw_setscheme(drw, scheme[SchemeNorm]);
-		tw = TEXTW(stext) - lrpad + 2; /* 2px right padding */
-		drw_text(drw, m->ww - tw, 0, tw, bh, 0, stext, 0);
+		tw = TEXTW(stext) - lrpad / 2 + 2; /* 2px extra right padding */
+		drw_text(drw, m->ww - tw - stw, 0, tw, bh, lrpad / 2 - 2, stext, 0);
 	}
 
+	resizebarwin(m);
 	for (c = m->clients; c; c = c->next) {
 		occ |= c->tags;
 		if (c->isurgent)
@@ -735,7 +832,7 @@ drawbar(Monitor *m)
 	drw_setscheme(drw, scheme[SchemeNorm]);
 	x = drw_text(drw, x, 0, w, bh, lrpad / 2, m->ltsymbol, 0);
 
-	if ((w = m->ww - tw - x) > bh) {
+	if ((w = m->ww - tw - stw - x) > bh) {
 		if (m->sel) {
 			drw_setscheme(drw, scheme[m == selmon ? SchemeSel : SchemeNorm]);
 			drw_text(drw, x, 0, w, bh, lrpad / 2, m->sel->name, 0);
@@ -746,7 +843,7 @@ drawbar(Monitor *m)
 			drw_rect(drw, x, 0, w, bh, 1, 1);
 		}
 	}
-	drw_map(drw, m->barwin, 0, 0, m->ww, bh);
+	drw_map(drw, m->barwin, 0, 0, m->ww - stw, bh);
 }
 
 void
@@ -783,8 +880,11 @@ expose(XEvent *e)
 	Monitor *m;
 	XExposeEvent *ev = &e->xexpose;
 
-	if (ev->count == 0 && (m = wintomon(ev->window)))
+	if (ev->count == 0 && (m = wintomon(ev->window))) {
 		drawbar(m);
+		if (m == selmon)
+			updatesystray();
+	}
 }
 
 void
@@ -870,14 +970,32 @@ getatomprop(Client *c, Atom prop)
 	unsigned char *p = NULL;
 	Atom da, atom = None;
 
-	if (XGetWindowProperty(dpy, c->win, prop, 0L, sizeof atom, False, XA_ATOM,
+	/* FIXME getatomprop should return the number of items and a pointer to
+	 * the stored data instead of this workaround */
+	Atom req = XA_ATOM;
+	if (prop == xatom[XembedInfo])
+		req = xatom[XembedInfo];
+
+	if (XGetWindowProperty(dpy, c->win, prop, 0L, sizeof atom, False, req,
 		&da, &di, &dl, &dl, &p) == Success && p) {
 		atom = *(Atom *)p;
+		if (da == xatom[XembedInfo] && dl == 2)
+			atom = ((Atom *)p)[1];
 		XFree(p);
 	}
 	return atom;
 }
 
+unsigned int
+getsystraywidth()
+{
+	unsigned int w = 0;
+	Client *i;
+	if(showsystray)
+		for(i = systray->icons; i; w += i->w + systrayspacing, i = i->next) ;
+	return w ? w + systrayspacing : 1;
+}
+
 int
 getrootptr(int *x, int *y)
 {
@@ -1008,7 +1126,8 @@ killclient(const Arg *arg)
 {
 	if (!selmon->sel)
 		return;
-	if (!sendevent(selmon->sel, wmatom[WMDelete])) {
+
+	if (!sendevent(selmon->sel->win, wmatom[WMDelete], NoEventMask, wmatom[WMDelete], CurrentTime, 0 , 0, 0)) {
 		XGrabServer(dpy);
 		XSetErrorHandler(xerrordummy);
 		XSetCloseDownMode(dpy, DestroyAll);
@@ -1095,6 +1214,13 @@ maprequest(XEvent *e)
 	static XWindowAttributes wa;
 	XMapRequestEvent *ev = &e->xmaprequest;
 
+	Client *i;
+	if ((i = wintosystrayicon(ev->window))) {
+		sendevent(i->win, netatom[Xembed], StructureNotifyMask, CurrentTime, XEMBED_WINDOW_ACTIVATE, 0, systray->win, XEMBED_EMBEDDED_VERSION);
+		resizebarwin(selmon);
+		updatesystray();
+	}
+
 	if (!XGetWindowAttributes(dpy, ev->window, &wa) || wa.override_redirect)
 		return;
 	if (!wintoclient(ev->window))
@@ -1216,6 +1342,17 @@ propertynotify(XEvent *e)
 	Window trans;
 	XPropertyEvent *ev = &e->xproperty;
 
+	if ((c = wintosystrayicon(ev->window))) {
+		if (ev->atom == XA_WM_NORMAL_HINTS) {
+			updatesizehints(c);
+			updatesystrayicongeom(c, c->w, c->h);
+		}
+		else
+			updatesystrayiconstate(c, ev);
+		resizebarwin(selmon);
+		updatesystray();
+	}
+
 	if ((ev->window == root) && (ev->atom == XA_WM_NAME))
 		updatestatus();
 	else if (ev->state == PropertyDelete)
@@ -1266,6 +1403,19 @@ recttomon(int x, int y, int w, int h)
 	return r;
 }
 
+void
+removesystrayicon(Client *i)
+{
+	Client **ii;
+
+	if (!showsystray || !i)
+		return;
+	for (ii = &systray->icons; *ii && *ii != i; ii = &(*ii)->next);
+	if (ii)
+		*ii = i->next;
+	free(i);
+}
+
 void
 resize(Client *c, int x, int y, int w, int h, int interact)
 {
@@ -1273,6 +1423,14 @@ resize(Client *c, int x, int y, int w, int h, int interact)
 		resizeclient(c, x, y, w, h);
 }
 
+void
+resizebarwin(Monitor *m) {
+	unsigned int w = m->ww;
+	if (showsystray && m == systraytomon(m) && !systrayonleft)
+		w -= getsystraywidth();
+	XMoveResizeWindow(dpy, m->barwin, m->wx, m->by, w, bh);
+}
+
 void
 resizeclient(Client *c, int x, int y, int w, int h)
 {
@@ -1288,6 +1446,19 @@ resizeclient(Client *c, int x, int y, int w, int h)
 	XSync(dpy, False);
 }
 
+void
+resizerequest(XEvent *e)
+{
+	XResizeRequestEvent *ev = &e->xresizerequest;
+	Client *i;
+
+	if ((i = wintosystrayicon(ev->window))) {
+		updatesystrayicongeom(i, ev->width, ev->height);
+		resizebarwin(selmon);
+		updatesystray();
+	}
+}
+
 void
 resizemouse(const Arg *arg)
 {
@@ -1434,26 +1605,37 @@ setclientstate(Client *c, long state)
 }
 
 int
-sendevent(Client *c, Atom proto)
+sendevent(Window w, Atom proto, int mask, long d0, long d1, long d2, long d3, long d4)
 {
 	int n;
-	Atom *protocols;
+	Atom *protocols, mt;
 	int exists = 0;
 	XEvent ev;
 
-	if (XGetWMProtocols(dpy, c->win, &protocols, &n)) {
-		while (!exists && n--)
-			exists = protocols[n] == proto;
-		XFree(protocols);
+	if (proto == wmatom[WMTakeFocus] || proto == wmatom[WMDelete]) {
+		mt = wmatom[WMProtocols];
+		if (XGetWMProtocols(dpy, w, &protocols, &n)) {
+			while (!exists && n--)
+				exists = protocols[n] == proto;
+			XFree(protocols);
+		}
 	}
+	else {
+		exists = True;
+		mt = proto;
+	}
+
 	if (exists) {
 		ev.type = ClientMessage;
-		ev.xclient.window = c->win;
-		ev.xclient.message_type = wmatom[WMProtocols];
+		ev.xclient.window = w;
+		ev.xclient.message_type = mt;
 		ev.xclient.format = 32;
-		ev.xclient.data.l[0] = proto;
-		ev.xclient.data.l[1] = CurrentTime;
-		XSendEvent(dpy, c->win, False, NoEventMask, &ev);
+		ev.xclient.data.l[0] = d0;
+		ev.xclient.data.l[1] = d1;
+		ev.xclient.data.l[2] = d2;
+		ev.xclient.data.l[3] = d3;
+		ev.xclient.data.l[4] = d4;
+		XSendEvent(dpy, w, False, mask, &ev);
 	}
 	return exists;
 }
@@ -1467,7 +1649,7 @@ setfocus(Client *c)
 			XA_WINDOW, 32, PropModeReplace,
 			(unsigned char *) &(c->win), 1);
 	}
-	sendevent(c, wmatom[WMTakeFocus]);
+	sendevent(c->win, wmatom[WMTakeFocus], NoEventMask, wmatom[WMTakeFocus], CurrentTime, 0, 0, 0);
 }
 
 void
@@ -1556,6 +1738,10 @@ setup(void)
 	wmatom[WMTakeFocus] = XInternAtom(dpy, "WM_TAKE_FOCUS", False);
 	netatom[NetActiveWindow] = XInternAtom(dpy, "_NET_ACTIVE_WINDOW", False);
 	netatom[NetSupported] = XInternAtom(dpy, "_NET_SUPPORTED", False);
+	netatom[NetSystemTray] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_S0", False);
+	netatom[NetSystemTrayOP] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_OPCODE", False);
+	netatom[NetSystemTrayOrientation] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_ORIENTATION", False);
+	netatom[NetSystemTrayOrientationHorz] = XInternAtom(dpy, "_NET_SYSTEM_TRAY_ORIENTATION_HORZ", False);
 	netatom[NetWMName] = XInternAtom(dpy, "_NET_WM_NAME", False);
 	netatom[NetWMState] = XInternAtom(dpy, "_NET_WM_STATE", False);
 	netatom[NetWMCheck] = XInternAtom(dpy, "_NET_SUPPORTING_WM_CHECK", False);
@@ -1563,6 +1749,9 @@ setup(void)
 	netatom[NetWMWindowType] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE", False);
 	netatom[NetWMWindowTypeDialog] = XInternAtom(dpy, "_NET_WM_WINDOW_TYPE_DIALOG", False);
 	netatom[NetClientList] = XInternAtom(dpy, "_NET_CLIENT_LIST", False);
+	xatom[Manager] = XInternAtom(dpy, "MANAGER", False);
+	xatom[Xembed] = XInternAtom(dpy, "_XEMBED", False);
+	xatom[XembedInfo] = XInternAtom(dpy, "_XEMBED_INFO", False);
 	/* init cursors */
 	cursor[CurNormal] = drw_cur_create(drw, XC_left_ptr);
 	cursor[CurResize] = drw_cur_create(drw, XC_sizing);
@@ -1571,6 +1760,8 @@ setup(void)
 	scheme = ecalloc(LENGTH(colors), sizeof(Clr *));
 	for (i = 0; i < LENGTH(colors); i++)
 		scheme[i] = drw_scm_create(drw, colors[i], 3);
+	/* init system tray */
+	updatesystray();
 	/* init bars */
 	updatebars();
 	updatestatus();
@@ -1699,7 +1890,18 @@ togglebar(const Arg *arg)
 {
 	selmon->showbar = !selmon->showbar;
 	updatebarpos(selmon);
-	XMoveResizeWindow(dpy, selmon->barwin, selmon->wx, selmon->by, selmon->ww, bh);
+	resizebarwin(selmon);
+	if (showsystray) {
+		XWindowChanges wc;
+		if (!selmon->showbar)
+			wc.y = -bh;
+		else if (selmon->showbar) {
+			wc.y = 0;
+			if (!selmon->topbar)
+				wc.y = selmon->mh - bh;
+		}
+		XConfigureWindow(dpy, systray->win, CWY, &wc);
+	}
 	arrange(selmon);
 }
 
@@ -1795,11 +1997,18 @@ unmapnotify(XEvent *e)
 		else
 			unmanage(c, 0);
 	}
+	else if ((c = wintosystrayicon(ev->window))) {
+		/* KLUDGE! sometimes icons occasionally unmap their windows, but do
+		 * _not_ destroy them. We map those windows back */
+		XMapRaised(dpy, c->win);
+		updatesystray();
+	}
 }
 
 void
 updatebars(void)
 {
+	unsigned int w;
 	Monitor *m;
 	XSetWindowAttributes wa = {
 		.override_redirect = True,
@@ -1810,10 +2019,15 @@ updatebars(void)
 	for (m = mons; m; m = m->next) {
 		if (m->barwin)
 			continue;
-		m->barwin = XCreateWindow(dpy, root, m->wx, m->by, m->ww, bh, 0, DefaultDepth(dpy, screen),
+		w = m->ww;
+		if (showsystray && m == systraytomon(m))
+			w -= getsystraywidth();
+		m->barwin = XCreateWindow(dpy, root, m->wx, m->by, w, bh, 0, DefaultDepth(dpy, screen),
 				CopyFromParent, DefaultVisual(dpy, screen),
 				CWOverrideRedirect|CWBackPixmap|CWEventMask, &wa);
 		XDefineCursor(dpy, m->barwin, cursor[CurNormal]->cursor);
+		if (showsystray && m == systraytomon(m))
+			XMapRaised(dpy, systray->win);
 		XMapRaised(dpy, m->barwin);
 		XSetClassHint(dpy, m->barwin, &ch);
 	}
@@ -1990,6 +2204,125 @@ updatestatus(void)
 	if (!gettextprop(root, XA_WM_NAME, stext, sizeof(stext)))
 		strcpy(stext, "dwm-"VERSION);
 	drawbar(selmon);
+	updatesystray();
+}
+
+
+void
+updatesystrayicongeom(Client *i, int w, int h)
+{
+	if (i) {
+		i->h = bh;
+		if (w == h)
+			i->w = bh;
+		else if (h == bh)
+			i->w = w;
+		else
+			i->w = (int) ((float)bh * ((float)w / (float)h));
+		applysizehints(i, &(i->x), &(i->y), &(i->w), &(i->h), False);
+		/* force icons into the systray dimensions if they don't want to */
+		if (i->h > bh) {
+			if (i->w == i->h)
+				i->w = bh;
+			else
+				i->w = (int) ((float)bh * ((float)i->w / (float)i->h));
+			i->h = bh;
+		}
+	}
+}
+
+void
+updatesystrayiconstate(Client *i, XPropertyEvent *ev)
+{
+	long flags;
+	int code = 0;
+
+	if (!showsystray || !i || ev->atom != xatom[XembedInfo] ||
+			!(flags = getatomprop(i, xatom[XembedInfo])))
+		return;
+
+	if (flags & XEMBED_MAPPED && !i->tags) {
+		i->tags = 1;
+		code = XEMBED_WINDOW_ACTIVATE;
+		XMapRaised(dpy, i->win);
+		setclientstate(i, NormalState);
+	}
+	else if (!(flags & XEMBED_MAPPED) && i->tags) {
+		i->tags = 0;
+		code = XEMBED_WINDOW_DEACTIVATE;
+		XUnmapWindow(dpy, i->win);
+		setclientstate(i, WithdrawnState);
+	}
+	else
+		return;
+	sendevent(i->win, xatom[Xembed], StructureNotifyMask, CurrentTime, code, 0,
+			systray->win, XEMBED_EMBEDDED_VERSION);
+}
+
+void
+updatesystray(void)
+{
+	XSetWindowAttributes wa;
+	XWindowChanges wc;
+	Client *i;
+	Monitor *m = systraytomon(NULL);
+	unsigned int x = m->mx + m->mw;
+	unsigned int sw = TEXTW(stext) - lrpad + systrayspacing;
+	unsigned int w = 1;
+
+	if (!showsystray)
+		return;
+	if (systrayonleft)
+		x -= sw + lrpad / 2;
+	if (!systray) {
+		/* init systray */
+		if (!(systray = (Systray *)calloc(1, sizeof(Systray))))
+			die("fatal: could not malloc() %u bytes\n", sizeof(Systray));
+		systray->win = XCreateSimpleWindow(dpy, root, x, m->by, w, bh, 0, 0, scheme[SchemeSel][ColBg].pixel);
+		wa.event_mask        = ButtonPressMask | ExposureMask;
+		wa.override_redirect = True;
+		wa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
+		XSelectInput(dpy, systray->win, SubstructureNotifyMask);
+		XChangeProperty(dpy, systray->win, netatom[NetSystemTrayOrientation], XA_CARDINAL, 32,
+				PropModeReplace, (unsigned char *)&netatom[NetSystemTrayOrientationHorz], 1);
+		XChangeWindowAttributes(dpy, systray->win, CWEventMask|CWOverrideRedirect|CWBackPixel, &wa);
+		XMapRaised(dpy, systray->win);
+		XSetSelectionOwner(dpy, netatom[NetSystemTray], systray->win, CurrentTime);
+		if (XGetSelectionOwner(dpy, netatom[NetSystemTray]) == systray->win) {
+			sendevent(root, xatom[Manager], StructureNotifyMask, CurrentTime, netatom[NetSystemTray], systray->win, 0, 0);
+			XSync(dpy, False);
+		}
+		else {
+			fprintf(stderr, "dwm: unable to obtain system tray.\n");
+			free(systray);
+			systray = NULL;
+			return;
+		}
+	}
+	for (w = 0, i = systray->icons; i; i = i->next) {
+		/* make sure the background color stays the same */
+		wa.background_pixel  = scheme[SchemeNorm][ColBg].pixel;
+		XChangeWindowAttributes(dpy, i->win, CWBackPixel, &wa);
+		XMapRaised(dpy, i->win);
+		w += systrayspacing;
+		i->x = w;
+		XMoveResizeWindow(dpy, i->win, i->x, 0, i->w, i->h);
+		w += i->w;
+		if (i->mon != m)
+			i->mon = m;
+	}
+	w = w ? w + systrayspacing : 1;
+	x -= w;
+	XMoveResizeWindow(dpy, systray->win, x, m->by, w, bh);
+	wc.x = x; wc.y = m->by; wc.width = w; wc.height = bh;
+	wc.stack_mode = Above; wc.sibling = m->barwin;
+	XConfigureWindow(dpy, systray->win, CWX|CWY|CWWidth|CWHeight|CWSibling|CWStackMode, &wc);
+	XMapWindow(dpy, systray->win);
+	XMapSubwindows(dpy, systray->win);
+	/* redraw background */
+	XSetForeground(dpy, drw->gc, scheme[SchemeNorm][ColBg].pixel);
+	XFillRectangle(dpy, systray->win, drw->gc, 0, 0, w, bh);
+	XSync(dpy, False);
 }
 
 void
@@ -2057,6 +2390,16 @@ wintoclient(Window w)
 	return NULL;
 }
 
+Client *
+wintosystrayicon(Window w) {
+	Client *i = NULL;
+
+	if (!showsystray || !w)
+		return i;
+	for (i = systray->icons; i && i->win != w; i = i->next) ;
+	return i;
+}
+
 Monitor *
 wintomon(Window w)
 {
@@ -2110,6 +2453,22 @@ xerrorstart(Display *dpy, XErrorEvent *ee)
 	return -1;
 }
 
+Monitor *
+systraytomon(Monitor *m) {
+	Monitor *t;
+	int i, n;
+	if(!systraypinning) {
+		if(!m)
+			return selmon;
+		return m == selmon ? m : NULL;
+	}
+	for(n = 1, t = mons; t && t->next; n++, t = t->next) ;
+	for(i = 1, t = mons; t && t->next && i < systraypinning; i++, t = t->next) ;
+	if(systraypinningfailfirst && n < systraypinning)
+		return mons;
+	return t;
+}
+
 void
 zoom(const Arg *arg)
 {

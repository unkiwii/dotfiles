diff --git a/config.def.h b/config.def.h
index 91ab8ca..3578a7e 100644
--- a/config.def.h
+++ b/config.def.h
@@ -5,8 +5,8 @@
  *
  * font: see http://freedesktop.org/software/fontconfig/fontconfig-user.html
  */
-static char *font = "Liberation Mono:pixelsize=12:antialias=true:autohint=true";
-static int borderpx = 2;
+static char *font = "GoMono Nerd Font Mono:pixelsize=19:antialias=true:autohint=true";
+static int borderpx = 0;
 
 /*
  * What program is execed by st depends of these precedence rules:
@@ -16,7 +16,7 @@ static int borderpx = 2;
  * 4: value of shell in /etc/passwd
  * 5: value of shell in config.h
  */
-static char *shell = "/bin/sh";
+static char *shell = "/usr/bin/zsh";
 char *utmp = NULL;
 /* scroll program: to enable use a string like "scroll" */
 char *scroll = NULL;
@@ -96,7 +96,7 @@ unsigned int tabspaces = 8;
 /* Terminal colors (16 first used in escape sequence) */
 static const char *colorname[] = {
 	/* 8 normal colors */
-	"black",
+	"#0c0c0c",
 	"red3",
 	"green3",
 	"yellow3",
@@ -129,8 +129,8 @@ static const char *colorname[] = {
  * Default colors (colorname index)
  * foreground, background, cursor, reverse cursor
  */
-unsigned int defaultfg = 258;
-unsigned int defaultbg = 259;
+unsigned int defaultfg = 7;
+unsigned int defaultbg = 0;
 unsigned int defaultcs = 256;
 static unsigned int defaultrcs = 257;
 

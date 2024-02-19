diff --git a/config.def.h b/config.def.h
index 60eb376..a34c874 100644
--- a/config.def.h
+++ b/config.def.h
@@ -1,6 +1,7 @@
 /* See LICENSE file for copyright and license details. */
 
 static char *fontfallbacks[] = {
+	"InconsolataForPowerline Nerd Font",
 	"dejavu sans",
 	"roboto",
 	"ubuntu",
@@ -9,15 +10,15 @@ static char *fontfallbacks[] = {
 #define FONTSZ(x) ((int)(10.0 * powf(1.1288, (x)))) /* x in [0, NUMFONTSCALES-1] */
 
 static const char *colors[] = {
-	"#000000", /* foreground color */
-	"#FFFFFF", /* background color */
+	"#eeeeee", /* foreground color */
+	"#222222", /* background color */
 };
 
 static const float linespacing = 1.4;
 
 /* how much screen estate is to be used at max for the content */
-static const float usablewidth = 0.75;
-static const float usableheight = 0.75;
+static const float usablewidth = 0.9;
+static const float usableheight = 0.9;
 
 static Mousekey mshortcuts[] = {
 	/* button         function        argument */

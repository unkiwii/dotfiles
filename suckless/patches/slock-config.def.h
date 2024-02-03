diff --git a/config.def.h b/config.def.h
index 9855e21..13c5d6c 100644
--- a/config.def.h
+++ b/config.def.h
@@ -3,9 +3,9 @@ static const char *user  = "nobody";
 static const char *group = "nogroup";
 
 static const char *colorname[NUMCOLS] = {
-	[INIT] =   "black",     /* after initialization */
-	[INPUT] =  "#005577",   /* during input */
-	[FAILED] = "#CC3333",   /* wrong password */
+	[INIT] =   "#0f0f0f",   /* after initialization */
+	[INPUT] =  "#cc8800",   /* during input */
+	[FAILED] = "#880000",   /* wrong password */
 };
 
 /* treat a cleared input like a wrong password (color) */

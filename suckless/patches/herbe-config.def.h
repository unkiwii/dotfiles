diff --git a/config.def.h b/config.def.h
index 86b7e76..c95c588 100644
--- a/config.def.h
+++ b/config.def.h
@@ -1,14 +1,14 @@
-static const char *background_color = "#3e3e3e";
-static const char *border_color = "#ececec";
-static const char *font_color = "#ececec";
-static const char *font_pattern = "monospace:size=10";
+static const char *background_color = "#440000";
+static const char *border_color = "#ff0000";
+static const char *font_color = "#cccccc";
+static const char *font_pattern = "InconsolataForPowerline Nerd Font:size=24";
 static const unsigned line_spacing = 5;
 static const unsigned int padding = 15;
 
 static const unsigned int width = 450;
 static const unsigned int border_size = 2;
-static const unsigned int pos_x = 30;
-static const unsigned int pos_y = 60;
+static const unsigned int pos_x = 20;
+static const unsigned int pos_y = 30;
 
 enum corners { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT };
 enum corners corner = TOP_RIGHT;

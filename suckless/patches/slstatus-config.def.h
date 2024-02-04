diff --git a/config.def.h b/config.def.h
index d805331..7ffcaee 100644
--- a/config.def.h
+++ b/config.def.h
@@ -4,7 +4,7 @@
 const unsigned int interval = 1000;
 
 /* text to show if no value can be retrieved */
-static const char unknown_str[] = "n/a";
+static const char unknown_str[] = "";
 
 /* maximum output string length */
 #define MAXLEN 2048
@@ -65,5 +65,12 @@ static const char unknown_str[] = "n/a";
  */
 static const struct arg args[] = {
 	/* function format          argument */
-	{ datetime, "%s",           "%F %T" },
+	{ temp,          "CPU: %s°C · ",  "/sys/class/thermal/thermal_zone0/temp" },
+	{ disk_perc,    "DISK: %s%% · ",  "/" },
+	{ ram_perc,      "RAM: %s%% · ",  NULL },
+	{ battery_state,   "BAT: [%s] ",  "BAT0" },
+	{ battery_perc,       "%s%% · ",  "BAT0" },
+	{ run_command,        "VOL: %s",  "wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/\\(.*MUTED.*\\)/[M] /' | sed '/^V/d'" },
+	{ run_command,        "%s%% · ",  "wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/\\(.*MUTED.*\\)/0/' | sed 's/Volume: //' | xargs echo '100 *' | bc | xargs printf '%0.f'" },
+	{ datetime,                "%s",  "%a %d/%m/%Y · %H:%M" },
 };

diff --git a/config.def.h b/config.def.h
index d805331..3ed7df6 100644
--- a/config.def.h
+++ b/config.def.h
@@ -65,5 +65,10 @@ static const char unknown_str[] = "n/a";
  */
 static const struct arg args[] = {
 	/* function format          argument */
-	{ datetime, "%s",           "%F %T" },
+	{ temp,          "CPU: %s°C · ",  "/sys/class/thermal/thermal_zone0/temp" },
+	{ disk_perc,    "DISK: %s%% · ",  "/" },
+	{ ram_perc,      "RAM: %s%% · ",  NULL },
+	{ battery_state,     "BAT: %s ",  "BAT0" },
+	{ battery_perc,       "%s%% · ",  "BAT0" },
+	{ datetime,                "%s",  "%a %d/%m/%Y · %H:%M" },
 };

/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "#0f0f0f",     /* after initialization */
	[INPUT] =  "#cc8800",   /* during input */
	[FAILED] = "#880000",   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

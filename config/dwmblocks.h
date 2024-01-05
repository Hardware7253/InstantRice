//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"Bat:", "cat /sys/class/power_supply/BAT0/capacity | sed 's/$/%/'", 30, 0},

	{"Vol:", "pamixer --get-volume | sed 's/$/%/'", 1, 0},

	{"Cpu:", "sensors | grep -i 'id' | awk 'NR==1{print $1,$2,$3,$4}' | cut -c  16- ", 15, 0},

	//{"Gpu:", "sensors | grep -i 'edge' | cut -b 15,16,17,18,19,20,21,22 | cut -c  2-", 15, 0},

	{"Mem:", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},

	{"", "date '+%b %d (%a) %T'",			         		5,		0},
};
//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

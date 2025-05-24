module wi3enrich;
import std::io;
import std::collections::map;
import std::os::env;

const int MIN_PATTERN_LENGTH = 3;
const int SUPPORTED_KEYWORDS = 38;

macro esc(String $string) {
	return "\e[" +++ $string +++ "m";
}

<*
	Turn a positive number into its string representation.
*>
macro String to_string(uint $num) {
	char[] $res;
	int $i = 0;
	$for ;$num != 0; :
		$res = { (char) ('0' + $num % 10) } +++ $res;
		$num = $num / 10;
		$i++;
	$endfor
	$res = $res +++ '\0';
	return (String) $res;
}

fn String wi_enrich(String msg) {
	String no_color_char = env::get_var("NO_COLOR") ?? "";
	bool no_color = no_color_char.len != 0;

	HashMap{String, String} patterns;
	patterns.temp_init_from_keys_and_values(
		{ "/", "BOLD", "DIM", "ITALIC", "UNDER", "STRIKE", "NUMBER" },
		{ esc("0"), esc("1"), esc("2"), esc("3"), esc("4"), esc("9"), esc("1;36") },
		SUPPORTED_KEYWORDS
	);
	// Generate the mappings for every colour
	String[] $colours = {
		"BLACK", "RED", "GREEN", "YELLOW", "BLUE", "MAGENTA", "CYAN", "WHITE"
	};
	$foreach $i, $colour : $colours:
		patterns[$colour] = esc(to_string(30 + $i));
		patterns["BRIGHT-" +++ $colour] = esc(to_string(90 + $i));
		patterns["ON " +++ $colour] = esc(to_string(40 + $i));
		patterns["ON BRIGHT-" +++ $colour] = esc(to_string(100 + $i));
	$endforeach

	patterns.@each(; String key, String val) {
		io::printfn("%s -> %s test\e[0m", key, val);
	};

	return msg;
}

fn int main(String[] args) {
	wi_enrich("test");
	io::printn("\e[96mHello, World!\e[0m");
	io::printfn("%sFormatted red\e[0m", esc("41"));
	return 0;
}

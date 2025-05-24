module wi::enrich;

import std::io;
import std::core::mem::allocator;

<*
	Wrap the passed argument in an ansi escape sequence.
	Does no type-checking, only uses `$stringify`.
*>
macro @esc(#num) {
	return "\e[" +++ $stringify(#num) +++ "m";
}

macro String @entry_to_escape(EnrichColour $entry) {
	return "\e[" +++ $entry.original +++ "m";
}

macro EnrichColour @generate_variants(String $original, ushort $code) {
	return {
		.original = $original,
		.code = $code,
		.bright = "BRIGHT-" +++ $original,
		.background = "ON " +++ $original,
		.bright_background = "ON BRIGHT-" +++ $original
	};
}

struct EnrichColour {
	String original;
	ushort code;
	String bright;
	String background;
	String bright_background;
}

enum EnrichColours : ushort (EnrichColour variants) {
	BLACK = @generate_variants("BLACK", 30),
	RED = @generate_variants("RED", 31),
	GREEN = @generate_variants("GREEN", 32),
	YELLOW = @generate_variants("YELLOW", 33),
	BLUE = @generate_variants("BLUE", 34),
	MAGENTA = @generate_variants("MAGENTA", 35),
	CYAN = @generate_variants("CYAN", 36),
	WHITE = @generate_variants("WHITE", 37),
	RESET = @generate_variants("RESET", 39),
}

fn int main() {
	$foreach $entry : EnrichColours.values:
		io::printfn(
			"%sHello, C3!%s",
			@entry_to_escape($entry),
			@entry_to_escape(EnrichColours.RESET)
		);
	$endforeach

	return 0;
}

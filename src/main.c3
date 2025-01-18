module wi3enrich;
import std::io;

const int MIN_PATTERN_LENGTH = 3;
const int SUPPORTED_KEYWORDS = 38;

struct PatternStruct {
	char[18] pattern;
	char[7] replacement;
	int pattern_length;
	int replacement_length;
}

fn char* wi_enrich(char* msg) {
	char* no_color_char = getenv;
}

fn int main(String[] args)
{
	io::printn("Hello, World!");
	return 0;
}

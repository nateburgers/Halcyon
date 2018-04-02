// hlcc.cc

#include <sstream>
#include <string>
#include <deque>

/// The set of tokens are
///
///   Natural     = \d+
///   LeftParen   = (
///   RightParen  = )
///   AddOperator = +

auto tokenize(std::streambuf *stream) -> std::deque<std::string>
{
    std::string pushBuffer;
    std::deque<std::string> tokens;

    char character = stream->sbumpc();

    auto advance = [&character, stream]() {
        character = stream->sbumpc();
    };

    auto push = [character, &pushBuffer]() {
        pushBuffer += character;
    };

    auto flush = [&pushBuffer, &tokens]() {
        if (pushBuffer.empty()) {
            return;
        }

        tokens.push_back(pushBuffer);
        pushBuffer.clear();
    };

    start: {
        switch(character) {
          case '(': {
          } break;

          case ')': {
          } break;

          case '+': {
          } break;

          case 0: {
              flush();
          } break;

          case ' ':
          case '\t':
          case '\n': {
          } break;

          default: {
              if (character >= '0' && character <= '9') {
                  push();

                  advance();
                  goto start;
              }

              goto reject;
          } break;
        }
    };

    reject: {
    };

    return tokens;
}

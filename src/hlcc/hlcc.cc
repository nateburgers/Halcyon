// hlcc.cc

#include <iostream>
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

    auto push = [&character, &pushBuffer]() {
        pushBuffer += character;
    };

    auto flush = [&pushBuffer, &tokens]() {
        if (pushBuffer.empty()) {
            return;
        }

        tokens.push_back(pushBuffer);
        pushBuffer.clear();
    };

  start:
    switch(character) {
      case '(':
        flush();
        push();

        advance();
        goto start;

      case ')':
        flush();
        push();

        advance();
        goto start;

      case '+':
        flush();
        push();

        advance();
        goto start;

      case -1:
        flush();
        goto accept;

      case ' ':
      case '\t':
      case '\n':
        flush();

        advance();
        goto start;

      default:
        if (character >= '0' && character <= '9') {
            flush();
            push();

            advance();
            goto naturalTail;
        }

        goto reject;
    }

  naturalTail:
    switch (character) {
      case '(':
        flush();
        push();

        advance();
        goto start;

      case ')':
        flush();
        push();

        advance();
        goto start;

      case '+':
        flush();
        push();

        advance();
        goto start;

      case -1:
        flush();
        goto accept;

      case ' ':
      case '\t':
      case '\n':
        flush();

        advance();
        goto start;

      default:
        if (character >= '0' && character <= '9') {
            push();

            advance();
            goto naturalTail;
        }

        goto reject;
    }

  reject:
    throw std::invalid_argument("could not parse");

  accept:
    return tokens;
}

auto main() -> int
{
    std::stringbuf buffer("(1234 + 1234)+ (1234 + 431 )");

    const auto tokens = tokenize(&buffer);

    for (const auto& token : tokens) {
        std::cout << token << std::endl;
    }

    return 0;
}





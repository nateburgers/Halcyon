// hlcc.cc

#include <deque>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <variant>

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

struct Expression;

struct AddExpression
{
    AddExpression() = delete;

    AddExpression(const Expression& lhs, const Expression& rhs)
            : d_lhs_up(std::make_unique<Expression>(lhs))
            , d_rhs_up(std::make_unique<Expression>(rhs))
    {
    }

    AddExpression(Expression&& lhs, Expression&& rhs)
            : d_lhs_up(std::make_unique<Expression>(std::move(lhs)))
            , d_rhs_up(std::make_unique<Expression>(std::move(rhs)))
    {
    }

    AddExpression(const AddExpression& other)
            : d_lhs_up(std::make_unique<Expression>(other.lhs()))
            , d_rhs_up(std::make_unique<Expression>(other.rhs()))
    {
    }

    AddExpression(AddExpression&& other) = default;

    ~AddExpression() = default;

    auto operator=(const AddExpression& other) -> AddExpression&
    {
        d_lhs_up = std::make_unique<Expression>(other.lhs());
        d_rhs_up = std::make_unique<Expression>(other.rhs());
        return *this;
    }

    auto operator=(AddExpression&& other) -> AddExpression& = default;

    void setLhs(const Expression& lhs)
    {
        d_lhs_up = std::make_unique<Expression>(lhs);
    }

    void setLhs(Expression&& lhs)
    {
        d_lhs_up = std::make_unique<Expression>(std::move(lhs));
    }

    void setRhs(const Expression& rhs)
    {
        d_rhs_up = std::make_unique<Expression>(rhs);
    }

    void setRhs(Expression&& rhs)
    {
        d_rhs_up = std::make_unique<Expression>(std::move(rhs));
    }

    auto lhs() const -> const Expression&
    {
        return *d_lhs_up;
    }

    auto rhs() const -> const Expression&
    {
        return *d_rhs_up;
    }

  private:
    std::unique_ptr<Expression> d_lhs_up;
    std::unique_ptr<Expression> d_rhs_up;
};

struct NaturalExpression
{
    NaturalExpression() = default;

    explicit NaturalExpression(std::uint64_t value)
            : d_value(value)
    {
    }

    NaturalExpression(const NaturalExpression& other) = default;

    NaturalExpression(NaturalExpression&& other) = default;

    ~NaturalExpression() = default;

    auto operator=(const NaturalExpression& other) ->
            NaturalExpression& = default;

    auto operator=(NaturalExpression&& other) ->
            NaturalExpression& = default;

    void setValue(std::uint64_t value)
    {
        d_value = value;
    }

    auto value() const -> std::uint64_t
    {
        return d_value;
    }

  private:
    std::uint64_t d_value;
};

struct Expression
{
     Expression() = delete;

     explicit Expression(const AddExpression& expression)
             : d_data(expression) {}

     explicit Expression(AddExpression&& expression)
             : d_data(std::move(expression)) {}

     explicit Expression(const NaturalExpression& expression)
             : d_data(expression) {}

     explicit Expression(NaturalExpression&& expression)
             : d_data(std::move(expression)) {}

     Expression(const Expression& other) = default;

     Expression(Expression&& other) = default;

     ~Expression() = default;

     auto operator=(const Expression& other) -> Expression& = default;

     auto operator=(Expression&& other) -> Expression& = default;

     auto add() const -> const AddExpression&
     {
         return std::get<AddExpression>(d_data);
     }

     auto natural() const -> const NaturalExpression&
     {
         return std::get<NaturalExpression>(d_data);
     }

     auto isAdd() const -> bool
     {
         return std::holds_alternative<AddExpression>(d_data);
     }

     auto isNatural() const -> bool
     {
         return std::holds_alternative<NaturalExpression>(d_data);
     }

     void setAdd(const AddExpression& expression)
     {
         d_data = expression;
     }

     void setAdd(AddExpression&& expression)
     {
         d_data = std::move(expression);
     }

     void setNatural(const NaturalExpression& expression)
     {
         d_data = expression;
     }

     void setNatural(NaturalExpression&& expression)
     {
         d_data = std::move(expression);
     }

  private:
    using Data = std::variant<AddExpression, NaturalExpression>;

    Data d_data;
};

/// Source Grammar
///
///   Expression = @Natural                            <NaturalExpression>
///              | Expression @AddOperator Expression  <AddExpression>
///
/// Left Factored Grammar
///
///   Expression' = @Natural ExpressionTail'
///
///   ExpressionTail' = @AddOperator Expression'
///                   | <empty>
///
/// "Catamorphic" Left Factored Grammar
///
///   Expression'(a) = @Natural ExpressionTail'(a)
///
///   ExpressionTail'(a) = @AddOperator a
///                      | <empty>
///
/// Along with the transform
///
///   T : Expression' -> Expression
///   T e = T (e[0],  e[1])
///
///   T : @Natural * ExpressionTail' -> Expression
///   T n (@AddOperator, e) = AddExpression (NaturalExpression n, e)
///   T n (<empty>)         = NaturalExpression n
///

auto parse(const std::deque<std::string>& tokens) -> Expression
{
    using Values = std::variant<AddExpression, NaturalExpression, Expression>;
    using Stack = std::deque<Values>;

    Stack stack;

  expression:
          // TODO(nate): add support for a parenthetical expression
    if (tokens.front() == "(") {
        goto reject;
    }
    if (tokens.front() == ")") {
        goto reject;
    }
    if (tokens.front() == "+") {
        goto reject;
    }
    else /* token is a digit */ {
        int digit = std::stoi(tokens.front());
        stack.emplace_back(NaturalExpression(digit));

        tokens.pop_front();
        goto expressionTail;
    }

  expressionTail:
    if (tokens.front() == "(") {
    }
    if (tokens.front() == ")") {
    }
    if (tokens.front() == "+") {
    }
    else /* token is a digit */ {
    }

  reject:

  accept:
    return stack.top();
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





/// @file hlcc_argument.hh
#pragma once

#include <hls_integer.h>

#include <cstdint.h>
namespace Halcyon {
namespace hls {

using Natural8 = std::uint8_t;
using Natural16 = std::uint16_t;
using Natural32 = std::uint32_t;
using Natural64 = std::uint64_t;
using Natural = std::uint64_t;

using Boolean = bool;

struct True
{
    constexpr Boolean value = true;
};

struct False
{
    constexpr Boolean value = false;
};

template <typename LHS_TYPE, typename RHS_TYPE>
TypeUtil_EqualImpl : False { };

template <typename TYPE>
TypeUtil_EqualImpl : True { };

namespace TypeUtil
{
    template <typename LHS_TYPE, typename RHS_TYPE>
    constexpr Boolean equal = TypeUtil_EqualImpl<LHS_TYPE, RHS_TYPE>::value;
};

template <typename... VALUE_TYPES>
union Union;

template <typename VALUE_TYPE, typename... VALUE_TYPES>
union Union<VALUE_TYPE, VALUE_TYPES...>
{
    // DATA
    VALUE_TYPE            d_firstValue;
    Union<VALUE_TYPES...> d_otherValues;

  public:
    // NOT IMPLEMENTED
    Union(const Union&) = delete;
    Union(Union&&) = delete;
    Union& operator=(const Union&) = delete;
    Union& operator=(Union&&) = delete;

    // CREATORS
    Union()
    : d_firstValue()
    {
    }

    explicit Union(const VALUE_TYPE& value);
    : d_firstValue(value)
    {
    }

    explicit Union(VALUE_TYPE&& value);
    : d_firstValue(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    explicit Union(const OTHER_VALUE_TYPE& value);
    : d_otherValues(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    explicit Union(OTHER_VALUE_TYPE&& value);
    : d_otherValues(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    destroy()
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            d_firstValue.~VALUE_TYPE();
        }
        else {
            d_otherValues.destroy<OTHER_VALUE_TYPE>();
        }
    }

    // MANIPULATORS
    Union& operator=(const VALUE_TYPE& value)
    {
        new (&d_firstValue) VALUE_TYPE(value);
    }

    Union& operator=(VALUE_TYPE&& value)
    {
        // TODO(nate): move semantics
        new (&d_firstValue) VALUE_TYPE(value);
    }

    template <typename OTHER_VALUE_TYPE>
    Union& operator=(const OTHER_VALUE_TYPE& value)
    {
        d_otherValues = value;
    }

    template <typename OTHER_VALUE_TYPE>
    Union& operator=(OTHER_VALUE_TYPE&& value)
    {
        // TODO(nate): move semantics
        d_otherValues = value;
    }

    template <typename OTHER_VALUE_TYPE, typename... CONSTRUCTION_PARAMETERS>
    void createInPlace(CONSTRUCTION_PARAMETERS&&... parameters)
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            new (&d_firstValue) VALUE_TYPE(parameters...);
        }
        else {
            d_otherValues.createInPlace<OTHER_VALUE_TYPE>(parameters...);
        }
    }

    template <typename OTHER_VALUE_TYPE>
    OTHER_VALUE_TYPE& the()
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            return d_firstValue;
        }
        else {
            return d_otherValues.the<OTHER_VALUE_TYPE>();
        }
    }

    // ACCESSORS
    template <typename OTHER_VALUE_TYPE>
    const OTHER_VALUE_TYPE& the() const;
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            return d_firstValue;
        }
        else {
            return d_otherValues.the<OTHER_VALUE_TYPE>();
        }
    }
};

template <typename VALUE_TYPE>
union Union<VALUE_TYPE>
{
};

}
}

namespace Halcyon {
namespace hlcc {

/// The 'Argument_Type' enum identifies the different addressing modes
/// available to arguments.
enum class Argument_Type : hls::Integer
{
    /// 'e_INTEGER64' specifies that an argument value is a 64-bit integer
    /// literal.
    e_INTEGER64,

    /// 'e_NATURAL64' specifies that an argument value is a 64-bit unsigned
    /// integer literal.
    e_NATURAL64,

    /// 'e_REGISTER' specifies that an argument value is the value stored in
    /// the register at the index specified by this literal.
    e_REGISTER,

    /// 'e_ADDRESS' specifies that an argument value is the value stored in
    /// the memory address at the index specified by this literal.
    e_ADDRESS,

    /// 'e_INDIRECT' specifies that an argument value is the value
    /// stored in the memory address at the index contained in the register
    /// at the index specified by this literal.
    e_INDIRECT
};

/// The 'Argument' class provides a value-semantic type that represents a
/// numeric literal and an addressing mode to disambiguate the meaning of the
/// literal.
class Argument
{
  public:
    // TYPES
    using Type = Argument_Type;

  private:
    // PRIVATE TYPES
    union Value {
        hls::Integer64 d_integer;
        hls::Natural64 d_natural;
    };

    // DATA
    Type  d_type;
    Value d_value;

  public:
    // CREATORS
    Argument();

    explicit Argument(hls::Integer integer);

    explicit Argument(hls::Natural natural);

    Argument(Type type, hls::Integer value);

    Argument(const Argument& original);

    Argument(Argument&& original);

    ~Argument() = default;

    // MANIPULATORS
    Argument& operator=(const Argument& original);

    Argument& operator=(const Argument&& original);

    void makeInteger(hls::Integer integer);

    void makeNatural(hls::Natural natural);

    void makeRegister(hls::Integer register);

    void makeAddress(hls::Integer address);

    void makeIndirect(hls::Integer register);

    // ACCESSORS
    Type type() const;

    hls::Boolean isInteger() const;

    hls::Boolean isNatural() const;

    hls::Boolean isRegister() const;

    hls::Boolean isAddress() const;

    hls::Boolean isIndirect() const;

    hls::Integer theInteger() const;

    hls::Natural theNatural() const;

    hls::Integer theRegister() const;

    hls::Integer theAddress() const;

    hls::Integer theIndirect() const;
};

// OPERATORS
hls::Boolean operator==(const Argument& lhs, const Argument& rhs);

hls::Boolean operator!=(const Argument& lhs, const Argument& rhs);

namespace ArgumentUtil
{
    Argument createInteger(hls::Integer integer);

    Argument createNatural(hls::Natural natural);

    Argument createRegister(hls::Integer register);

    Argument createAddress(hls::Integer address);

    Argument createIndirect(hls::Integer register);

};

// INLINE DEFINITIONS

inline
Argument::Argument()
    : d_type(Type::e_INTEGER64)
    , d_value{0}
{
}

inline
Argument::Argument(hls::Integer integer)
    : d_type(Type::e_INTEGER64)
    , d_value{integer}
{
}

inline
Argument::Argument(hls::Natural natural)
    : d_type(Type::e_NATURAL64)
    , d_value{natural}
{
}

inline
Argument::Argument(Type type, hls::Integer value)
    : d_type(type)
    , d_value{value}
{
}

inline
Argument::Argument(const Argument& original)
    : d_type(original.d_type)
    , d_value{}
{
    switch (original.d_type) {
      case Type::e_INTEGER64: {
      } break;

      case Type::e_NATURAL64: {
      } break;

      case Type::e_REGISTER: {
      } break;

      case Type::e_ADDRESS: {
      } break;

      case Type::e_INDIRECT: {
      } break;
    }
}

}
}

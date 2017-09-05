/// @file hls_union.hh
#pragma once

#include <hls_boolean.hh>
#include <hls_typeutil.hh>

// TODO(nate): remove
#include <new>

namespace Halcyon {
namespace hls {

template <typename... VALUE_TYPES>
union Union;

template <typename VALUE_TYPE, typename... VALUE_TYPES>
union Union<VALUE_TYPE, VALUE_TYPES...>
{
  private:
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
    constexpr Union()
    : d_firstValue()
    {
    }

    constexpr explicit Union(const VALUE_TYPE& value)
    : d_firstValue(value)
    {
    }

    constexpr explicit Union(VALUE_TYPE&& value)
    : d_firstValue(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    constexpr explicit Union(const OTHER_VALUE_TYPE& value)
    : d_otherValues(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    constexpr explicit Union(OTHER_VALUE_TYPE&& value)
    : d_otherValues(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    void destroy()
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            d_firstValue.~VALUE_TYPE();
        }
        else {
            d_otherValues.template destroy<OTHER_VALUE_TYPE>();
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
        return *this;
    }

    template <typename OTHER_VALUE_TYPE>
    Union& operator=(const OTHER_VALUE_TYPE& value)
    {
        d_otherValues = value;
        return *this;
    }

    template <typename OTHER_VALUE_TYPE>
    Union& operator=(OTHER_VALUE_TYPE&& value)
    {
        // TODO(nate): move semantics
        d_otherValues = value;
        return *this;
    }

    template <typename OTHER_VALUE_TYPE, typename... CONSTRUCTION_PARAMETERS>
    void createInPlace(CONSTRUCTION_PARAMETERS&&... parameters)
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            new (&d_firstValue) VALUE_TYPE(parameters...);
        }
        else {
            d_otherValues.template createInPlace<OTHER_VALUE_TYPE>(parameters...);
        }
    }

    template <typename OTHER_VALUE_TYPE>
    constexpr OTHER_VALUE_TYPE& the()
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            return d_firstValue;
        }
        else {
            return d_otherValues.template the<OTHER_VALUE_TYPE>();
        }
    }

    // ACCESSORS
    template <typename OTHER_VALUE_TYPE>
    constexpr const OTHER_VALUE_TYPE& the() const
    {
        if constexpr (TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>) {
            return d_firstValue;
        }
        else {
            return d_otherValues.template the<OTHER_VALUE_TYPE>();
        }
    }
};

template <typename VALUE_TYPE>
union Union<VALUE_TYPE>
{
  private:
    // DATA
    VALUE_TYPE d_value;

  public:
    // NOT IMPLEMENTED
    Union(const Union&) = delete;
    Union(Union&&) = delete;
    Union& operator=(const Union&) = delete;
    Union& operator=(Union&&) = delete;

    // CREATORS
    constexpr Union()
    : d_value()
    {
    }

    constexpr explicit Union(const VALUE_TYPE& value)
    : d_value(value)
    {
    }

    constexpr explicit Union(VALUE_TYPE&& value)
    : d_value(value)
    {
    }

    template <typename OTHER_VALUE_TYPE>
    void destroy()
    {
        static_assert(TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>);
        d_value.~VALUE_TYPE();
    }

    // MANIPULATORS
    Union& operator=(const VALUE_TYPE& value)
    {
        new (&d_value) VALUE_TYPE(value);
        return *this;
    }

    Union& operator=(VALUE_TYPE&& value)
    {
        new (&d_value) VALUE_TYPE(value);
        return *this;
    }

    template <typename OTHER_VALUE_TYPE, typename... CONSTRUCTION_PARAMETERS>
    void createInPlace(CONSTRUCTION_PARAMETERS&&... parameters)
    {
        static_assert(TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>);
        new (&d_value) VALUE_TYPE(parameters...);
    }

    template <typename OTHER_VALUE_TYPE>
    constexpr OTHER_VALUE_TYPE& the()
    {
        static_assert(TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>);
        return d_value;
    }

    // ACCESSORS
    template <typename OTHER_VALUE_TYPE>
    constexpr const OTHER_VALUE_TYPE& the() const
    {
        static_assert(TypeUtil::equal<VALUE_TYPE, OTHER_VALUE_TYPE>);
        return d_value;
    }
};

}
}

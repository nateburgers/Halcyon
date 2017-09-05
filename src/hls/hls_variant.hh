/// @file hls_variant.hh
#pragma once

#include <hls_boolean.hh>
#include <hls_integer.hh>
#include <hls_union.hh>

namespace Halcyon {
namespace hls {

template <typename VALUE_TYPE>
struct InPlace
{
    using Value = VALUE_TYPE;
};

template <typename VALUE_TYPE>
constexpr InPlace<VALUE_TYPE> inPlace;

template <typename... TYPES>
class TypeList;

template <typename TYPE, typename... TYPES>
class TypeList
{

};

template <typename TYPE>
class TypeList<TYPE>
{
    template <hls::Integer>
    struct TypeAtIndex_Impl;

    template <>
    struct TypeAtIndex_Impl<0>
    {
        using Type = TYPE;
    }

  public:
    static constexpr hls::Integer size = 1;

    template <typename OTHER_TYPE>
    static constexpr hls::Integer indexOf =
        TypeUtil::equal<TYPE, OTHER_TYPE> ? -1 : 0 ;

    template <hls::Integer INDEX>
    using TypeAtIndex = typename TypeAtIndex_Impl<INDEX>::Type;
}

template <typename... VALUE_TYPES>
class Variant
{
    // PRIVATE TYPES
    using TypeList = TypeList<VALUE_TYPES...>;

    // DATA
    hls::Integer          d_tag;
    Union<VALUE_TYPES...> d_union;

  public:
    // CREATORS
    constexpr Variant();

    constexpr Variant(const Variant& original);

    constexpr Variant(Variant&& original);

    template <typename VALUE_TYPE>
    constexpr Variant(const VALUE_TYPE& value);

    template <typename VALUE_TYPE>
    constexpr Variant(VALUE_TYPE&& value);

    template <typename VALUE_TYPE, typename... CONSTRUCTION_PARAMETERS>
    constexpr Variant(const InPlace<VALUE_TYPE>& placementTag,
                      CONSTRUCTION_PARAMETERS&&... parameters);

    ~Variant();

    // MANIPULATORS
    Variant& operator=(const Variant& original);

    Variant& operator=(Variant&& original);

    template <typename VALUE_TYPE>
    Variant& operator=(const VALUE_TYPE& value);

    template <typename VALUE_TYPE>
    Variant& operator=(VALUE_TYPE&& value);

    template <typename VALUE_TYPE, typename... CONSTRUCTION_PARAMETERS>
    void createInPlace(CONSTRUCTION_PARAMETERS&&...);

    template <typename VALUE_TYPE>
    VALUE_TYPE& the();

    // ACCESSORS
    template <typename VALUE_TYPE>
    hls::Boolean is() const;

    template <typename VALUE_TYPE>
    const VALUE_TYPE& the() const;
};

}
}

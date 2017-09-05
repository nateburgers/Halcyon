/// @file hls_typeutil.hh
#pragma once

#include <hls_boolean.hh>
#include <hls_false.hh>
#include <hls_true.hh>

namespace Halcyon {
namespace hls {

template <typename LHS_TYPE, typename RHS_TYPE>
struct TypeUtil_EqualImpl : public False
{
};

template <typename TYPE>
struct TypeUtil_EqualImpl<TYPE, TYPE> : public True
{
};

struct TypeUtil
{
    template <typename LHS_TYPE, typename RHS_TYPE>
    static constexpr Boolean equal =
        TypeUtil_EqualImpl<LHS_TYPE, RHS_TYPE>::value;
};

}
}

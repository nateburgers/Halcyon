// hls_allocator.hh                                                   -*-C++-*-
#pragma once

#include <experimental/memory_resource>

namespace Halcyon {
namespace hls {

namespace pmr = std::experimental::pmr;

template <typename ALLOCATED_TYPE>
using Allocator = pmr::polymorphic_allocator<ALLOCATED_TYPE>;

} // close package namespace
} // close compiler namespace

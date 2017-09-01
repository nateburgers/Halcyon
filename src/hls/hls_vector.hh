// hls_vector.hh                                                      -*-C++-*-
#pragma once

#include <experimental/vector>

namespace Halcyon {
namespace hls {

template <typename ELEMENT_TYPE>
using Vector = std::experimental::pmr::vector<ELEMENT_TYPE>;

} // close package namespace
} // close compiler namespace

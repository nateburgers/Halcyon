// hls_vector.hh                                                      -*-C++-*-
#pragma once

#include <hls_allocator.hh>
#include <hls_integer.hh>
#include <hls_size.hh>

#include <experimental/vector>
#include <initializer_list>
#include <iterator>

namespace Halcyon {
namespace hls {

template <typename VALUE_TYPE>
using InitializerList = std::initializer_list<VALUE_TYPE>;

template <typename VALUE_TYPE>
class Vector
{
  public:
    // TYPES
    using Value = VALUE_TYPE;
    using Allocator = hls::Allocator;
    using Size = hls::Size;
    using Difference = hls::Integer;
    using Reference = Value&;
    using ConstReference = const Value&;
    using Pointer = Value*;
    using ConstPointer = const Value*;
    using Iterator = Value*;
    using ConstIterator = Value*;
    using ReverseIterator = std::reverse_iterator<Iterator>;
    using ConstReverseIterator = std::reverse_iterator<ConstIterator>;

    // CREATORS
    explicit Vector(const hls::Allocator& allocator = hls::Allocator());

    Vector(hls::Size             count,
           const Value&          value,
           const hls::Allocator& allocator = hls::Allocator());

    Vector(hls::Size             count,
           const hls::Allocator& allocator = hls::Allocator());

    template <typename INPUT_ITERATOR>
    Vector(INPUT_ITERATOR        first,
           INPUT_ITERATOR        last,
           const hls::Allocator& allocator = hls::Allocator());

    Vector(const Vector&         original,
           const hls::Allocator& allocator = hls::Allocator());

    Vector(Vector&&              original,
           const hls::Allocator& allocator = hls::Allocator());

    Vector(hls::InitializerList<Value> initializer,
           const hls::Allocator&       allocator = hls::Allocator());

    ~Vector();

    // MANIPULATORS
    Vector& operator=(const Vector& original);

    Vector& operator=(Vector&& original);

    Value& operator[](hls::Size position);

    Value& first();

    Value& last();

    Value* data();

    Iterator begin();

    Iterator end();

    void assign(hls::Size count, const Value& value);

    template <typename INPUT_ITERATOR>
    void assign(INPUT_ITERATOR first, INPUT_ITERATOR last);

    void assign(hls::InitializerList<Value> initializer);

    void reserve(hls::Size);

    // ACCESSORS
    const Vector& operator[](hls::Size position) const;

    const Value& first() const;

    const Value& last() const;

    const Value* data() const;

    ConstIterator begin() const;

    ConstIterator end() const;

    bool empty() const;

    hls::Size size() const;

    hls::Size capacity() const;

    hls::Allocator allocator() const;

  private:
    // LOCAL ALIASES
    namespace pmr = std::experimental::pmr;

    // DATA
    pmr::vector<Value> d_vector;

};

template <typename ELEMENT_TYPE>
using Vector = std::experimental::pmr::vector<ELEMENT_TYPE>;

}
}

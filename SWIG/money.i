
/*
 Copyright (C) 2000-2004 StatPro Italia srl

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it under the
 terms of the QuantLib license.  You should have received a copy of the
 license along with this program; if not, please email quantlib-dev@lists.sf.net
 The license is also available online at http://quantlib.org/html/license.html

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

#ifndef quantlib_money_i
#define quantlib_money_i

%include currencies.i

%{
using QuantLib::Money;
%}

class Money {
    #if defined(SWIGRUBY)
    %rename("conversionType=") setConversionType;
    %rename("baseCurrency=")   setBaseCurrency;
    #elif defined(SWIGMZSCHEME) || defined(SWIGGUILE)
    %rename(">string")              __str__;
    %rename("conversion-type-set!") setConversionType;
    %rename("base-currency-set!")   setBaseCurrency;
    #endif
  public:
    Money(const Currency& currency, Decimal value);
    Money(Decimal value, const Currency& currency);
    const Currency& currency() const;
    Decimal value() const;
    Money rounded() const;

    #if defined(SWIGPYTHON) || defined(SWIGRUBY)
    Money operator+() const;
    Money operator-() const;
    %extend {
        Money operator+(const Money& m) { return *self+m; }
        Money operator-(const Money& m) { return *self-m; }
        Money operator*(Decimal x) { return *self*x; }
        Money operator/(Decimal x) { return *self/x; }
        Decimal operator/(const Money& m) { return *self/m; }
        #if defined(SWIGPYTHON)
        Money __rmul__(Decimal x) { return *self*x; }
        #endif
        int __cmp__(const Money& other) {
            if (*self < other)
                return -1;
            else if (*self == other)
                return 0;
            else
                return 1;
        }
        std::string __str__() {
            return QuantLib::MoneyFormatter::toString(*self);
        }
    }
    #endif

    enum ConversionType { None, BaseCurrency, Automated };
    %extend {
        static void setConversionType(ConversionType type) {
            Money::conversionType = type;
        }
        static void setBaseCurrency(const Currency& c) {
            Money::baseCurrency = c;
        }
    }
};

#if defined(SWIGMZSCHEME) || defined(SWIGGUILE)
%rename("Money+")  Money_plus;
%rename("Money-")  Money_minus;
%rename("Money*")  Money_times;
%rename("Money/")  Money_divided;
%rename("Money=?")  Money_equal;
%rename("Money<?")  Money_less;
%rename("Money<=?") Money_less_equal;
%rename("Money>?")  Money_greater;
%rename("Money>=?") Money_greater_equal;
%inline %{
    Money Money_plus(const Money& m1, const Money& m2) {
        return m1+m2;
    }
    Money Money_minus(const Money& m1, const Money& m2) {
        return m1-m2;
    }
    Money Money_times(const Money& m1, Decimal x) {
        return m1*x;
    }
    Money Money_times(Decimal x, const Money& m2) {
        return m2*x;
    }
    Money Money_divided(const Money& m1, Decimal x) {
        return m1/x;
    }
    Decimal Money_divided(const Money& m1, const Money& m2) {
        return m1/m2;
    }
    bool Money_equal(const Money& d1, const Money& d2) {
        return d1 == d2;
    }
    bool Money_less(const Money& d1, const Money& d2) {
        return d1 < d2;
    }
    bool Money_less_equal(const Money& d1, const Money& d2) {
        return d1 <= d2;
    }
    bool Money_greater(const Money& d1, const Money& d2) {
        return d1 > d2;
    }
    bool Money_greater_equal(const Money& d1, const Money& d2) {
        return d1 >= d2;
    }
%}
#endif


#endif
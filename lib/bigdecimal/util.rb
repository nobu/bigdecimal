# frozen_string_literal: false
#
# bigdecimal/util extends various native classes to provide the #to_d method,
# and provides BigDecimal#to_d and BigDecimal#to_digits.


# bigdecimal/util extends the native Integer class to provide the #to_d method.
#
# When you require 'bigdecimal/util' in your application, this method will
# be available on Integer objects.
class Integer < Numeric
  # call-seq:
  #     int.to_d  -> bigdecimal
  #
  # Convert +int+ to a BigDecimal and return it.
  #
  #     require 'bigdecimal'
  #     require 'bigdecimal/util'
  #
  #     42.to_d
  #     # => 0.42e2
  #
  def to_d
    BigDecimal(self)
  end
end

# bigdecimal/util extends the native Float class to provide the #to_d method.
#
# When you require 'bigdecimal/util' in your application, this method will be
# available on Float objects.
class Float < Numeric
  # call-seq:
  #     flt.to_d  -> bigdecimal
  #
  # Convert +flt+ to a BigDecimal and return it.
  #
  #     require 'bigdecimal'
  #     require 'bigdecimal/util'
  #
  #     0.5.to_d
  #     # => 0.5e0
  #
  def to_d(precision=nil)
    BigDecimal(self, precision || Float::DIG)
  end
end

# bigdecimal/util extends the native String class to provide the #to_d method.
#
# When you require 'bigdecimal/util' in your application, this method will be
# available on String objects.
class String
  # call-seq:
  #     string.to_d  -> bigdecimal
  #
  # Convert +string+ to a BigDecimal and return it.
  #
  #     require 'bigdecimal'
  #     require 'bigdecimal/util'
  #
  #     "0.5".to_d
  #     # => 0.5e0
  #
  def to_d
    begin
      BigDecimal(self)
    rescue ArgumentError
      BigDecimal(0)
    end
  end
end

# bigdecimal/util extends the BigDecimal class to provide the #to_digits and
# #to_d methods.
#
# When you require 'bigdecimal/util' in your application, these methods will be
# available on BigDecimal objects.
class BigDecimal < Numeric
  # call-seq:
  #     a.to_digits -> string
  #
  # Converts a BigDecimal to a String of the form "nnnnnn.mmm".
  # This method is deprecated; use BigDecimal#to_s("F") instead.
  #
  #     require 'bigdecimal'
  #     require 'bigdecimal/util'
  #
  #     d = BigDecimal.new("3.14")
  #     d.to_digits
  #     # => "3.14"
  def to_digits
    if self.nan? || self.infinite? || self.zero?
      self.to_s
    else
      i       = self.to_i.to_s
      _,f,_,z = self.frac.split
      i + "." + ("0"*(-z)) + f
    end
  end

  # call-seq:
  #     a.to_d -> bigdecimal
  #
  # Returns self.
  def to_d
    self
  end
end

# bigdecimal/util extends the native Rational class to provide the #to_d method.
#
# When you require 'bigdecimal/util' in your application, this method will be
# available on Rational objects.
class Rational < Numeric
  # call-seq:
  #   r.to_d(precision)   -> bigdecimal
  #
  # Converts a Rational to a BigDecimal.
  #
  # The required +precision+ parameter is used to determine the amount of
  # significant digits for the result. See BigDecimal::new for more information.
  #
  #   r = (22/7.0).to_r
  #   # => (7077085128725065/2251799813685248)
  #   r.to_d(3)
  #   # => 0.314e1
  def to_d(precision)
    BigDecimal(self, precision)
  end
end

require 'test/unit'
require 'zomg'

class ZOMGTest < Test::Unit::TestCase
  {
    'Digits'    => ['0123', 'asd'],
    'Oct_Digit' => ['0', 'a'],
    'Hex_Digit' => ['aA0', 'z'],
    'Int_Literal' => ['1023', '01'],
    'Oct_Literal' => ['0123', '10235'],
    'Hex_Literal' => ['0X1a2', '0xz230x223'],
    'Hex_Literal' => ['0X1a2', '0xz230x223'],
    'Esc_Sequence1' => ['\n', '\z'],
    'Esc_Sequence2' => ['\012', '\8'],
    'Esc_Sequence3' => ['\xa12', '\y123'],
    'Esc_Sequence' => ['\xa12', '\y123'],
    'Char' => ["\xa12", "\n"],
    'Char_Literal' => ["'a'", "asdf'a'"],
    'String_Literal' => ['"asdf\'asdf"', 'asdf"asdfdaf"'],
    'Float_Literal1' => ['123.123e-10', '123123'],
    'Float_Literal2' => ['123e-10', '123123'],
  }.each do |constant, list|
    define_method(:"test_#{constant.downcase}") do
      assert_match(ZOMG::IDL::Scanner.const_get(constant.to_sym), list[0])
      assert_no_match(ZOMG::IDL::Scanner.const_get(constant.to_sym), list[1])
    end
  end
end

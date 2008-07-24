require 'helper'

class ScannerTest < ZOMG::Test
  def setup
    @scanner = ZOMG::IDL::Scanner.new
  end

  def test_load_file
    @scanner.load_file(simple 'simple1.idl')
    tokens = []
    while token = @scanner.next_token
      tokens << token
    end
    assert tokens.length > 0
  end

  def test_instr
    assert_tokens([
                  [:T_IN, "in"],
                  [:T_STRING, "string"],
                  [:T_IDENTIFIER, "inStr"],
    ], "in string inStr")
  end

  def test_comment
    assert_tokens([[:T_COMMENT, "// boner"]], "// boner")
    assert_tokens([[:T_COMMENT, "/* boner */"]], "/* boner */")
  end

  def test_pragma
    assert_tokens([[:T_PRAGMA, "#pragma awesome\n"]], "#pragma awesome\n")
  end

  def test_preprocessor_directive
    assert_tokens([[:T_PREPROCESSOR, "#awesome\n"]], "#awesome\n")
  end

  def test_curlies
    assert_tokens([[:T_LEFT_CURLY_BRACKET, "{"]], "{")
    assert_tokens([[:T_RIGHT_CURLY_BRACKET, "}"]], "}")
    assert_tokens([
      [:T_LEFT_CURLY_BRACKET, "{"],
      [:T_RIGHT_CURLY_BRACKET, "}"]
    ], "{ }\n")
  end

  def test_squares
    assert_tokens([[:T_LEFT_SQUARE_BRACKET, "["]], "[")
    assert_tokens([[:T_RIGHT_SQUARE_BRACKET, "]"]], "]")
    assert_tokens([
      [:T_LEFT_SQUARE_BRACKET, "["],
      [:T_RIGHT_SQUARE_BRACKET, "]"]
    ], " [ ] \n")
  end

  def test_parens
    assert_tokens([[:T_LEFT_PARANTHESIS, "("]], "(")
    assert_tokens([[:T_RIGHT_PARANTHESIS, ")"]], ")")
    assert_tokens([
      [:T_LEFT_PARANTHESIS, "("],
      [:T_RIGHT_PARANTHESIS, ")"]
    ], " ( ) \n")
  end

  # Test literals
  {
    :const        => [:T_CONST, 'const'],
    :typedef      => [:T_TYPEDEF, 'typedef'],
    :float        => [:T_FLOAT, 'float'],
    :double       => [:T_DOUBLE, 'double'],
    :char         => [:T_CHAR, 'char'],
    :wchar        => [:T_WCHAR, 'wchar'],
    :fixed        => [:T_FIXED, 'fixed'],
    :boolean      => [:T_BOOLEAN, 'boolean'],
    :string       => [:T_STRING, 'string'],
    :wstring      => [:T_WSTRING, 'wstring'],
    :void         => [:T_VOID, 'void'],
    :unsigned     => [:T_UNSIGNED, 'unsigned'],
    :long         => [:T_LONG, 'long'],
    :short        => [:T_SHORT, 'short'],
    :struct       => [:T_STRUCT, 'struct'],
    :union        => [:T_UNION, 'union'],
    :switch       => [:T_SWITCH, 'switch'],
    :case         => [:T_CASE, 'case'],
    :default      => [:T_DEFAULT, 'default'],
    :enum         => [:T_ENUM, 'enum'],
    :in           => [:T_IN, 'in'],
    :out          => [:T_OUT, 'out'],
    :interface    => [:T_INTERFACE, 'interface'],
    :abstract     => [:T_ABSTRACT, 'abstract'],
    :valuetype    => [:T_VALUETYPE, 'valuetype'],
    :truncatable  => [:T_TRUNCATABLE, 'truncatable'],
    :supports     => [:T_SUPPORTS, 'supports'],
    :custom       => [:T_CUSTOM, 'custom'],
    :public       => [:T_PUBLIC, 'public'],
    :private      => [:T_PRIVATE, 'private'],
    :factory      => [:T_FACTORY, 'factory'],
    :native       => [:T_NATIVE, 'native'],
    :module       => [:T_MODULE, 'module'],
    :octet        => [:T_OCTET, 'octet'],
    :any          => [:T_ANY, 'any'],
    :sequence     => [:T_SEQUENCE, 'sequence'],
    :readonly     => [:T_READONLY, 'readonly'],
    :attribute    => [:T_ATTRIBUTE, 'attribute'],
    :exception    => [:T_EXCEPTION, 'exception'],
    :oneway       => [:T_ONEWAY, 'oneway'],
    :inout        => [:T_INOUT, 'inout'],
    :raises       => [:T_RAISES, 'raises'],
    :context      => [:T_CONTEXT, 'context'],
  }.each do |type, token|
    define_method(:"test_#{type}") do
      parse_text = token.length == 3 ? token.pop : token.last
      assert_tokens([token], parse_text)
      assert_tokens([
        [:T_LEFT_SQUARE_BRACKET, "["],
        token,
        [:T_RIGHT_SQUARE_BRACKET, "]"]
      ], " [\n#{parse_text}] \n")
      assert_tokens([
                    [:T_IN, "in"],
                    [:T_STRING, "string"],
                    [:T_IDENTIFIER, "#{parse_text}Str"],
      ], "in string #{parse_text}Str")
    end
  end

  {
    :minus        => [:T_MINUS_SIGN, '-'],
    :plus         => [:T_PLUS_SIGN, '+'],
    :shift_left   => [:T_SHIFTLEFT, '<<'],
    :shift_right  => [:T_SHIFTRIGHT, '>>'],
    :equal        => [:T_EQUAL, '='],
    :semicolon    => [:T_SEMICOLON, ';'],
    :comma        => [:T_COMMA, ','],
    :colon        => [:T_COLON, ':'],
    :asterisk     => [:T_ASTERISK, '*'],
    :solidus      => [:T_SOLIDUS, '/'],
    :percent      => [:T_PERCENT_SIGN, '%'],
    :tilde        => [:T_TILDE, '~'],
    :pipe         => [:T_VERTICAL_LIN, '|'],
    :caret        => [:T_CIRCUMFLEX, '^'],
    :ampersand    => [:T_AMPERSAND, '&'],
    :less_than    => [:T_LESS_THAN_SIGN, '<'],
    :greater_than => [:T_GREATER_THAN_SIGN, '>'],
    :FALSE        => [:T_FALSE, 'FALSE'],
    :TRUE         => [:T_TRUE, 'TRUE'],
    :ValueBase    => [:T_VALUEBASE, 'ValueBase'],
    :scope        => [:T_SCOPE, '::'],
    :object       => [:T_OBJECT, 'Object'],
    :principal    => [:T_PRINCIPAL, 'Principal'],
    :identifier   => [:T_IDENTIFIER, 'hello'],
    :float_lit_1  => [:T_FLOATING_PT_LITERAL, '123.2e10'],
    :float_lit_11 => [:T_FLOATING_PT_LITERAL, '123.2E10'],
    :float_lit_2  => [:T_FLOATING_PT_LITERAL, '123.0E-5', '123.E-5'],
    :float_lit_3  => [:T_FLOATING_PT_LITERAL, '123e10'],
    :float_lit_31 => [:T_FLOATING_PT_LITERAL, '123E+10'],
    :float_lit_4  => [:T_FLOATING_PT_LITERAL, '12.2'],
    :float_lit_5  => [:T_FLOATING_PT_LITERAL, '12.0', '12.'],
    :float_lit_6  => [:T_FLOATING_PT_LITERAL, '0.12e10', '.12e10'],
    :float_lit_61 => [:T_FLOATING_PT_LITERAL, '0.12e+10', '.12e+10'],
    :float_lit_7  => [:T_FLOATING_PT_LITERAL, '0.12', '.12'],
    :fixed_lit_1  => [:T_FIXED_PT_LITERAL, '123', '123d'],
    :fixed_lit_2  => [:T_FIXED_PT_LITERAL, '123', '123.d'],
    :fixed_lit_21 => [:T_FIXED_PT_LITERAL, '123', '123.D'],
    :fixed_lit_3  => [:T_FIXED_PT_LITERAL, '0.123', '.123d'],
    :fixed_lit_31 => [:T_FIXED_PT_LITERAL, '0.123', '.123D'],
    :fixed_lit_4  => [:T_FIXED_PT_LITERAL, '0.123', '0.123d'],
    :fixed_lit_41 => [:T_FIXED_PT_LITERAL, '0.123', '0.123D'],
    :hex_lit      => [:T_INTEGER_LITERAL, '0x23'],
    :hex_lit_1    => [:T_INTEGER_LITERAL, '0X23'],
    :oct_lit      => [:T_INTEGER_LITERAL, '023'],
    :int_lit      => [:T_INTEGER_LITERAL, '23'],
    :char_lit     => [:T_CHARACTER_LITERAL, "'a'"],
    :string_lit   => [:T_STRING_LITERAL, '"abc"'],
    :unknown      => [:T_UNKNOWN, '.'],
  }.each do |type, token|
    define_method(:"test_#{type}") do
      parse_text = token.length == 3 ? token.pop : token.last
      assert_tokens([token], parse_text)
      assert_tokens([
        [:T_LEFT_SQUARE_BRACKET, "["],
        token,
        [:T_RIGHT_SQUARE_BRACKET, "]"]
      ], " [\n#{parse_text}] \n")
    end
  end

  def assert_tokens(tokens, string)
    @scanner.scan_evaluate(string)
    tokens.each do |token|
      assert_equal(token, @scanner.next_token)
    end
  end
end

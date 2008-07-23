require 'test/unit'
require 'zomg'

class ScannerTest < Test::Unit::TestCase
  def setup
    @scanner = ZOMG::IDL::Scanner.new
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
    :FALSE        => [:T_FALSE, 'FALSE'],
    :TRUE         => [:T_TRUE, 'TRUE'],
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
    :ValueBase    => [:T_VALUEBASE, 'ValueBase'],
    :scope        => [:T_SCOPE, '::'],
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
    :object       => [:T_OBJECT, 'Object'],
    :principal    => [:T_PRINCIPAL, 'Principal'],
    :identifier   => [:T_IDENTIFIER, 'hello'],
    :float_lit_1  => [:T_FLOATING_PT_LITERAL, '123.2e10'],
    :float_lit_11 => [:T_FLOATING_PT_LITERAL, '123.E-10'],
    :float_lit_2  => [:T_FLOATING_PT_LITERAL, '123e10'],
    :float_lit_21 => [:T_FLOATING_PT_LITERAL, '123E+10'],
    :float_lit_3  => [:T_FLOATING_PT_LITERAL, '12.2'],
    :float_lit_4  => [:T_FLOATING_PT_LITERAL, '12.'],
    :float_lit_5  => [:T_FLOATING_PT_LITERAL, '.12e10'],
    :float_lit_51 => [:T_FLOATING_PT_LITERAL, '.12e+10'],
    :float_lit_6  => [:T_FLOATING_PT_LITERAL, '.12'],
  }.each do |type, token|
    define_method(:"test_#{type}") do
      assert_tokens([token], token.last)
      assert_tokens([
        [:T_LEFT_SQUARE_BRACKET, "["],
        token,
        [:T_RIGHT_SQUARE_BRACKET, "]"]
      ], " [\n#{token.last}] \n")
      end
  end

  def assert_tokens(tokens, string)
    @scanner.scan_evaluate(string)
    tokens.each do |token|
      assert_equal(token, @scanner.next_token)
    end
  end
end

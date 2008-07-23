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

  def test_colon
    assert_tokens([[:T_COLON, ":"]], ":")
    assert_tokens([
      [:T_LEFT_PARANTHESIS, "("],
      [:T_COLON, ":"],
      [:T_RIGHT_PARANTHESIS, ")"]
    ], " (:) \n")
  end

  def test_comma
    assert_tokens([[:T_COMMA, ","]], ",")
    assert_tokens([
      [:T_LEFT_PARANTHESIS, "("],
      [:T_COMMA, ","],
      [:T_RIGHT_PARANTHESIS, ")"]
    ], " (\n,) \n")
  end

  def assert_tokens(tokens, string)
    @scanner.scan_evaluate(string)
    tokens.each do |token|
      assert_equal(token, @scanner.next_token)
    end
  end
end

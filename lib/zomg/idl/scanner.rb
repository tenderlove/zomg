module ZOMG
  module IDL
    class Scanner
      # From http://www.omg.org/attachments/scanner.ll
      Digits          = /[0-9]+/
      Oct_Digit       = /[0-7]/
      Hex_Digit       = /[a-fA-F0-9]/
      Int_Literal     = /\A[1-9][0-9]*\Z/
      Oct_Literal     = /\A0#{Oct_Digit}*\Z/
      Hex_Literal     = /\A(0x|0X)#{Hex_Digit}*\Z/
      Esc_Sequence1   = /\\[ntvbrfa\\\?\'\"]/
      Esc_Sequence2   = /\\#{Oct_Digit}{1,3}/
      Esc_Sequence3   = /\\(x|X)#{Hex_Digit}{1,2}/
      Esc_Sequence    = /(#{Esc_Sequence1}|#{Esc_Sequence2}|#{Esc_Sequence3})/
      Char            = /([^\n\t\"\'\\]|#{Esc_Sequence})/
      Char_Literal    = /\A'(#{Char}|\")'\Z/
      String_Literal  = /\A"(#{Char}|\')*"\Z/
      Float_Literal1  = /\A#{Digits}\.#{Digits}?[eE][+-]?#{Digits}\Z/
      Float_Literal2  = /\A#{Digits}[eE][+-]?#{Digits}\Z/
    end
  end
end

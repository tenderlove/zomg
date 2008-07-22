module ZOMG
  module IDL
    class Parser
      Digits      = /[0-9]+/
      Oct_Digit   = /[0-7]/
      Hex_Digit   = /[a-fA-F0-9]/
      Int_Literal = /[1-9][0-9]*/
      Oct_Literal = /0#{Oct_Digit}/
    end
  end
end

module ZOMG
module IDL
class Scanner

macro
  Digits            [0-9]+
  Oct_Digit         [0-7]
  Hex_Digit         [a-fA-F0-9]
  Int_Literal       [1-9][0-9]*
  Oct_Literal       0{Oct_Digit}*
  Hex_Literal       0[xX]{Hex_Digit}*
  Comment           \/\*(.|[\r\n])*?\*\/
  Esc_Sequence1     \\\\\\\\\[ntvbrfa\\\\?\\\\'\"]
  Esc_Sequence2     \\\\\\\\\{Oct_Digit}{1,3}
  Esc_Sequence3     \\\\\\\\\[xX]{Hex_Digit}{1,2}
  Esc_Sequence      ({Esc_Sequence1}|{Esc_Sequence2}|{Esc_Sequence3})
  Char              ([^\n\t\"\'\\\]|{Esc_Sequence})
  Char_Literal      '({Char}|\")'
  String_Literal    "({Char}|')*"
  Float_Literal1    {Digits}\.{Digits}[eE][\+-]?{Digits}
  Float_Literal2    {Digits}\.[eE][\+-]?{Digits}
  Float_Literal3    {Digits}[eE][\+-]?{Digits}
  Float_Literal4    {Digits}\.{Digits}
  Float_Literal5    {Digits}\.
  Float_Literal6    \.{Digits}[eE][\+-]?{Digits}
  Float_Literal7    \.{Digits}
  Fixed_Literal1    {Digits}[dD]
  Fixed_Literal2    {Digits}\.[dD]
  Fixed_Literal3    \.{Digits}[dD]
  Fixed_Literal4    {Digits}\.{Digits}[dD]
  CORBA_Identifier  [a-zA-Z_][a-zA-Z0-9_]*
  IDENT             [a-zA-Z0-9_]

rule

# [:state]  pattern  [actions]
            [\s\n\r]
            {Comment}           { [:T_COMMENT, text] }
            \/\/[^\n]*          { [:T_COMMENT, text] }
            \#pragma[^\n]*\n    { [:T_PRAGMA, text] }
            \#[^\n]*\n          { [:T_PREPROCESSOR, text] }
            \{                  { [:T_LEFT_CURLY_BRACKET, text] }
            \}                  { [:T_RIGHT_CURLY_BRACKET, text] }
            \[                  { [:T_LEFT_SQUARE_BRACKET, text] }
            \]                  { [:T_RIGHT_SQUARE_BRACKET, text] }
            \(                  { [:T_LEFT_PARANTHESIS, text] }
            \)                  { [:T_RIGHT_PARANTHESIS, text] }
            \:\:                { [:T_SCOPE, text] }
            :                   { [:T_COLON, text] }
            ,                   { [:T_COMMA, text] }
            ;                   { [:T_SEMICOLON, text] }
            =                   { [:T_EQUAL, text] }
            >>                  { [:T_SHIFTRIGHT, text] }
            <<                  { [:T_SHIFTLEFT, text] }
            \+                  { [:T_PLUS_SIGN, text] }
            -                   { [:T_MINUS_SIGN,text] }
            \*                  { [:T_ASTERISK, text] }
            \/                  { [:T_SOLIDUS,text] }
            %                   { [:T_PERCENT_SIGN,text] }
            ~                   { [:T_TILDE,text] }
            \|                  { [:T_VERTICAL_LIN,text] };
            \^                  { [:T_CIRCUMFLEX,text] }
            &                   { [:T_AMPERSAND,text] }
            <                   { [:T_LESS_THAN_SIGN,text] }
            >                   { [:T_GREATER_THAN_SIGN, text] }
            const(?!{IDENT})      { [:T_CONST, text] }
            typedef(?!{IDENT})    { [:T_TYPEDEF, text] }
            float(?!{IDENT})      { [:T_FLOAT, text] }
            double(?!{IDENT})     { [:T_DOUBLE, text] }
            char(?!{IDENT})       { [:T_CHAR, text] }
            wchar(?!{IDENT})      { [:T_WCHAR, text] }
            fixed(?!{IDENT})      { [:T_FIXED, text] }
            boolean(?!{IDENT})    { [:T_BOOLEAN, text] }
            string(?!{IDENT})     { [:T_STRING, text] }
            wstring(?!{IDENT})    { [:T_WSTRING, text] }
            void(?!{IDENT})       { [:T_VOID, text] }
            unsigned(?!{IDENT})   { [:T_UNSIGNED, text] }
            long(?!{IDENT})       { [:T_LONG, text] }
            short(?!{IDENT})      { [:T_SHORT, text] }
            FALSE                 { [:T_FALSE, text] }
            TRUE                  { [:T_TRUE, text] }
            struct(?!{IDENT})     { [:T_STRUCT, text] }
            union(?!{IDENT})      { [:T_UNION, text] }
            switch(?!{IDENT})     { [:T_SWITCH, text] }
            case(?!{IDENT})       { [:T_CASE, text] }
            default(?!{IDENT})    { [:T_DEFAULT, text] }
            enum(?!{IDENT})       { [:T_ENUM, text] }
            interface(?!{IDENT})  { [:T_INTERFACE, text] }
            inout(?!{IDENT})      { [:T_INOUT, text] }
            in(?!{IDENT})         { [:T_IN, text] }
            out(?!{IDENT})          { [:T_OUT, text] }
            abstract(?!{IDENT})     { [:T_ABSTRACT, text] }
            valuetype(?!{IDENT})    { [:T_VALUETYPE, text] }
            truncatable(?!{IDENT})  { [:T_TRUNCATABLE, text] }
            supports(?!{IDENT})     { [:T_SUPPORTS, text] }
            custom(?!{IDENT})       { [:T_CUSTOM, text] }
            public(?!{IDENT})       { [:T_PUBLIC, text] }
            private(?!{IDENT})      { [:T_PRIVATE, text] }
            factory(?!{IDENT})      { [:T_FACTORY, text] }
            native(?!{IDENT})       { [:T_NATIVE, text] }
            ValueBase             { [:T_VALUEBASE, text] }

            module(?!{IDENT})     { [:T_MODULE, text] }
            octet(?!{IDENT})      { [:T_OCTET, text] }
            any(?!{IDENT})        { [:T_ANY, text] }
            sequence(?!{IDENT})   { [:T_SEQUENCE, text] }
            readonly(?!{IDENT})   { [:T_READONLY, text] }
            attribute(?!{IDENT})  { [:T_ATTRIBUTE, text] }
            exception(?!{IDENT})  { [:T_EXCEPTION, text] }
            oneway(?!{IDENT})     { [:T_ONEWAY, text] }
            raises(?!{IDENT})     { [:T_RAISES, text] }
            context(?!{IDENT})    { [:T_CONTEXT, text] }

            Object              { [:T_OBJECT, text] }
            Principal           { [:T_PRINCIPAL, text] }


            {CORBA_Identifier}  { [:T_IDENTIFIER, text] }
            {Float_Literal1}    { [:T_FLOATING_PT_LITERAL, text] }
            {Float_Literal2}    {
                                  text = text.split('.').join('.0')
                                  [:T_FLOATING_PT_LITERAL, text]
                                }
            {Float_Literal3}    { [:T_FLOATING_PT_LITERAL, text] }
            {Fixed_Literal4}    { [:T_FIXED_PT_LITERAL, text.gsub(/[Dd]/,'')] }
            {Float_Literal4}    { [:T_FLOATING_PT_LITERAL, text] }
            {Fixed_Literal2}    { [:T_FIXED_PT_LITERAL, text.gsub(/[.dD]/,'')] }
            {Float_Literal5}    { [:T_FLOATING_PT_LITERAL, "#{text}0"] }
            {Float_Literal6}    { [:T_FLOATING_PT_LITERAL, "0#{text}"] }
            {Fixed_Literal3}    {
                             [:T_FIXED_PT_LITERAL, "0#{text.gsub(/[dD]/, '')}"]
                                }
            {Float_Literal7}    { [:T_FLOATING_PT_LITERAL, "0#{text}"] }
            {Fixed_Literal1}    { [:T_FIXED_PT_LITERAL, text.gsub(/[dD]/,'')] }
            {Hex_Literal}       { [:T_INTEGER_LITERAL, text] }
            {Oct_Literal}       { [:T_INTEGER_LITERAL, text] }
            {Int_Literal}       { [:T_INTEGER_LITERAL, text] }
            {Char_Literal}      { [:T_CHARACTER_LITERAL, text] }
            {String_Literal}    { [:T_STRING_LITERAL, text] }
            [^\s\n\r]           { [:T_UNKNOWN, text] }
end
end
end

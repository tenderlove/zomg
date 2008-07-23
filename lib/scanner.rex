class Scanner

macro
  Digits            [0-9]+
  Oct_Digit         [0-7]
  Hex_Digit         [a-fA-F0-9]
  Int_Literal       [1-9][0-9]*
  Oct_Literal       0{Oct_Digit}*
  Hex_Literal       0[xX]{Hex_Digit}*
  Esc_Sequence1     \\\\\\\\\[ntvbrfa\\\\?\\\\'\"]
  Esc_Sequence2     \\\\\\\\\{Oct_Digit}{1,3}
  Esc_Sequence3     \\\\\\\\\[xX]{Hex_Digit}{1,2}
  Esc_Sequence      ({Esc_Sequence1}|{Esc_Sequence2}|{Esc_Sequence3})
  Char              ([^\n\t\"\'\\\]|{Esc_Sequence})
  Char_Literal      '({Char}|\")'
  String_Literal    "({Char}|')*"
  Float_Literal1    {Digits}\.{Digits}?[eE][\+-]?{Digits}  
  Float_Literal2    {Digits}[eE][\+-]?{Digits}
  Float_Literal3    {Digits}\.{Digits}
  Float_Literal4    {Digits}\.
  Float_Literal5    \.{Digits} 
  Float_Literal6    \.{Digits}[eE][\+-]?{Digits}  
  Fixed_Literal1    {Digits}[dD]
  Fixed_Literal2    {Digits}\.[dD]
  Fixed_Literal3    \.{Digits}[dD]
  Fixed_Literal4    {Digits}\.{Digits}[dD]
  CORBA_Identifier  [a-zA-Z_][a-zA-Z0-9_]*

rule

# [:state]  pattern  [actions]
            \s\n
            \/\/[^\n]*
            \#pragma[^\n]*\n    { [:T_PRAGMA, text] }
            \#[^\n]*\n          { preprocessor_directive( yytext ) }
            \{                  { [:T_LEFT_CURLY_BRACKET, text] }
            \}                  { [:T_RIGHT_CURLY_BRACKET, text] }
            \[                  { [:T_LEFT_SQUARE_BRACKET, text] }
            \]                  { [:T_RIGHT_SQUARE_BRACKET, text] }
            \(                  { [:T_LEFT_PARANTHESIS, text] }
            \)                  { [:T_RIGHT_PARANTHESIS, text] }
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
            const               { [:T_CONST, text] }
            typedef             { [:T_TYPEDEF, text] }
            float               { [:T_FLOAT, text] }
            double              { [:T_DOUBLE, text] }
            char                { [:T_CHAR, text] }
            wchar               { [:T_WCHAR, text] }
            fixed               { [:T_FIXED, text] }
            boolean             { [:T_BOOLEAN, text] }
            string              { [:T_STRING, text] }
            wstring             { [:T_WSTRING, text] }
            void                { [:T_VOID, text] }
            unsigned            { [:T_UNSIGNED, text] }
            long                { [:T_LONG, text] }
            short               { [:T_SHORT, text] }
            FALSE               { [:T_FALSE, text] }
            TRUE                { [:T_TRUE, text] }
            struct              { [:T_STRUCT, text] }
            union               { [:T_UNION, text] }
            switch              { [:T_SWITCH, text] }
            case                { [:T_CASE, text] }
            default             { [:T_DEFAULT, text] }
            enum                { [:T_ENUM, text] }
            in                  { [:T_IN, text] }
            out                 { [:T_OUT, text] }
            interface           { [:T_INTERFACE, text] }
            abstract            { [:T_ABSTRACT, text] }
            valuetype           { [:T_VALUETYPE, text] }
            truncatable         { [:T_TRUNCATABLE, text] }
            supports            { [:T_SUPPORTS, text] }
            custom              { [:T_CUSTOM, text] }
            public              { [:T_PUBLIC, text] }
            private             { [:T_PRIVATE, text] }
            factory             { [:T_FACTORY, text] }
            native              { [:T_NATIVE, text] }
            ValueBase           { [:T_VALUEBASE, text] }

            \:\:                { [:T_SCOPE, text] }
            
            module              { [:T_MODULE, text] }
            octet               { [:T_OCTET, text] }
            any                 { [:T_ANY, text] }
            sequence            { [:T_SEQUENCE, text] }
            readonly            { [:T_READONLY, text] }
            attribute           { [:T_ATTRIBUTE, text] }
            exception           { [:T_EXCEPTION, text] }
            oneway              { [:T_ONEWAY, text] }
            inout               { [:T_INOUT, text] }
            raises              { [:T_RAISES, text] }
            context             { [:T_CONTEXT, text] }

            Object              { [:T_OBJECT, text] }
            Principal           { [:T_PRINCIPAL, text] }


            {CORBA_Identifier}  { [:T_IDENTIFIER, text] }
            {Float_Literal1}    { [:T_FLOATING_PT_LITERAL, text] }
            {Float_Literal2}    { [:T_FLOATING_PT_LITERAL, text] }
            {Float_Literal3}    { [:T_FLOATING_PT_LITERAL, text] }
            {Float_Literal4}    { [:T_FLOATING_PT_LITERAL, text] }
            {Float_Literal5}    { [:T_FLOATING_PT_LITERAL, text] }
            {Float_Literal6}    { [:T_FLOATING_PT_LITERAL, text] }
            {Fixed_Literal1}    { [:T_FIXED_PT_LITERAL, text] }
            {Fixed_Literal2}    { [:T_FIXED_PT_LITERAL, text] }
            {Fixed_Literal3}    { [:T_FIXED_PT_LITERAL, text] }
            {Fixed_Literal4}    { [:T_FIXED_PT_LITERAL, text] }
            {Hex_Literal}       { [:T_INTEGER_LITERAL, text] }
            {Oct_Literal}       { [:T_INTEGER_LITERAL, text] }
            {Int_Literal}       { [:T_INTEGER_LITERAL, text] }
            {Char_Literal}      { [:T_CHARACTER_LITERAL, text] }
            {String_Literal}    { [:T_STRING_LITERAL, text] }
            .                   { [:T_UNKNOWN, text] }
end

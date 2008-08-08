class ZOMG::IDL::Lexer

/*
 *  MICO --- a free CORBA implementation
 *  Copyright (C) 1997-98 Kay Roemer & Arno Puder
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Send comments and/or bug reports to:
 *                 mico@informatik.uni-frankfurt.de
 *
 *  Converstion to RACC Copyright (C) 2008 Aaron Patterson
 */

token T_AMPERSAND
token T_ANY
token T_ASTERISK
token T_ATTRIBUTE
token T_BOOLEAN
token T_CASE
token T_CHAR
token T_CHARACTER_LITERAL
token T_WIDE_CHARACTER_LITERAL
token T_CIRCUMFLEX
token T_COLON
token T_COMMA
token T_CONST
token T_CONTEXT
token T_DEFAULT
token T_DOUBLE
token T_ENUM
token T_EQUAL
token T_EXCEPTION
token T_FALSE
token T_FIXED
token T_FIXED_PT_LITERAL
token T_FLOAT
token T_FLOATING_PT_LITERAL
token T_GREATER_THAN_SIGN
token T_IDENTIFIER
token T_IN
token T_INOUT
token T_INTEGER_LITERAL
token T_INTERFACE
token T_LEFT_CURLY_BRACKET
token T_LEFT_PARANTHESIS
token T_LEFT_SQUARE_BRACKET
token T_LESS_THAN_SIGN
token T_LONG
token T_MINUS_SIGN
token T_MODULE
token T_OCTET
token T_ONEWAY
token T_OUT
token T_PERCENT_SIGN
token T_PLUS_SIGN
token T_PRINCIPAL
token T_RAISES
token T_READONLY
token T_RIGHT_CURLY_BRACKET
token T_RIGHT_PARANTHESIS
token T_RIGHT_SQUARE_BRACKET
token T_SCOPE
token T_SEMICOLON
token T_SEQUENCE
token T_SHIFTLEFT
token T_SHIFTRIGHT
token T_SHORT
token T_SOLIDUS
token T_STRING
token T_STRING_LITERAL
token T_WIDE_STRING_LITERAL
token T_PRAGMA
token T_STRUCT
token T_SWITCH
token T_TILDE
token T_TRUE
token T_OBJECT
token T_TYPEDEF
token T_UNION
token T_UNSIGNED
token T_VERTICAL_LINE
token T_VOID
token T_WCHAR
token T_WSTRING
token T_UNKNOWN
token T_ABSTRACT
token T_VALUETYPE
token T_TRUNCATABLE
token T_SUPPORTS
token T_CUSTOM
token T_PUBLIC
token T_PRIVATE
token T_FACTORY
token T_NATIVE
token T_VALUEBASE

rule

/*1*/
specification
	: /*empty*/   { result = Specification.new([]) }
	| definitions { result = Specification.new(val[0]) }
	;

	
definitions
	: definition { result = val }
	| definition definitions { result = val.flatten }
	;

/*2*/
definition
	: type_dcl T_SEMICOLON
	| const_dcl T_SEMICOLON
	| except_dcl T_SEMICOLON
	| interface T_SEMICOLON
	| module T_SEMICOLON
	| value T_SEMICOLON
	;

/*3*/
module
	: T_MODULE T_IDENTIFIER T_LEFT_CURLY_BRACKET
       definitions T_RIGHT_CURLY_BRACKET { result = Module.new(val[1], val[3]) }
	;

/*4*/
interface
	: interface_dcl
	| forward_dcl
	;

/*5*/
interface_dcl
	: interface_header T_LEFT_CURLY_BRACKET interface_body
      T_RIGHT_CURLY_BRACKET {
        result = Interface.new(val[0], val[2])
      }
	;

/*6*/
forward_dcl
	: T_INTERFACE T_IDENTIFIER { result = ForwardDeclaration.new(val[1]) }
	| T_ABSTRACT T_INTERFACE T_IDENTIFIER
	;

/*7*/
interface_header
	: T_INTERFACE T_IDENTIFIER { result = InterfaceHeader.new(false, val[1]) }
	| T_INTERFACE T_IDENTIFIER interface_inheritance_spec {
      result = InterfaceHeader.new(false, val[1], val[2])
    }
	| T_ABSTRACT T_INTERFACE T_IDENTIFIER
	| T_ABSTRACT T_INTERFACE T_IDENTIFIER interface_inheritance_spec
	; 

/*8*/
interface_body
	: /*empty*/
	| exports
	;

exports
	: export { result = val }
	| export exports { result = val.flatten }
	;

/*9*/
export
	: type_dcl T_SEMICOLON
	| const_dcl T_SEMICOLON 
	| except_dcl T_SEMICOLON
	| attr_dcl T_SEMICOLON
	| op_dcl T_SEMICOLON 
	;

/*10*/
interface_inheritance_spec
	: T_COLON interface_names { result = val[1] }
	;

interface_names
	: scoped_names
	;

scoped_names
	: scoped_name { result = val }
	| scoped_name T_COMMA scoped_names { result = [val.first, val.last].flatten }
	;

/*11*/
interface_name
	: scoped_name
	;

/*12*/
scoped_name
	: T_IDENTIFIER { result = ScopedName.new(val[0]) }
  | T_SCOPE T_IDENTIFIER { result = ScopedName.new(val[0]) }
	| scoped_name T_SCOPE T_IDENTIFIER
	;

/*13*/
value
	: value_dcl
	| value_abs_dcl
	| value_box_dcl
	| value_forward_dcl
	;

/*14*/
value_forward_dcl
	: T_VALUETYPE T_IDENTIFIER
	| T_ABSTRACT T_VALUETYPE T_IDENTIFIER
	;

/*15*/
value_box_dcl
	: T_VALUETYPE T_IDENTIFIER type_spec
	;

/*16*/
value_abs_dcl
	: T_ABSTRACT T_VALUETYPE T_IDENTIFIER
		T_LEFT_CURLY_BRACKET value_body T_RIGHT_CURLY_BRACKET
	| T_ABSTRACT T_VALUETYPE T_IDENTIFIER value_inheritance_spec
		T_LEFT_CURLY_BRACKET value_body T_RIGHT_CURLY_BRACKET
	;

value_body
	: /*empty*/
	| exports
	;

/*17*/
value_dcl
	: value_header T_LEFT_CURLY_BRACKET value_elements
		T_RIGHT_CURLY_BRACKET
	| value_header T_LEFT_CURLY_BRACKET T_RIGHT_CURLY_BRACKET
	;

value_elements
	: value_element
	| value_element value_elements
	;

/*18*/
value_header
	: T_VALUETYPE T_IDENTIFIER value_inheritance_spec
	| T_CUSTOM T_VALUETYPE T_IDENTIFIER value_inheritance_spec
	| T_VALUETYPE T_IDENTIFIER
	| T_CUSTOM T_VALUETYPE T_IDENTIFIER
	;

/*19*/
value_inheritance_spec
	: T_COLON value_inheritance_bases
	| T_COLON value_inheritance_bases T_SUPPORTS interface_names
	| T_SUPPORTS interface_names
	;

value_inheritance_bases
	: value_name
	| value_name T_COMMA value_names
	| T_TRUNCATABLE value_name
	| T_TRUNCATABLE value_name T_COMMA value_names
	;

value_names
	: scoped_names
	;

/*20*/
value_name
	: scoped_name
	;

/*21*/
value_element
	: export
	| state_member
	| init_dcl
	;

/*22*/
state_member
	: T_PUBLIC type_spec declarators T_SEMICOLON
	| T_PRIVATE type_spec declarators T_SEMICOLON
	;

/*23*/
init_dcl
	: T_FACTORY T_IDENTIFIER
		T_LEFT_PARANTHESIS init_param_decls T_RIGHT_PARANTHESIS
		T_SEMICOLON
	;

/*24*/
init_param_decls
	: init_param_decl
	| init_param_decl T_COMMA init_param_decls
	;

/*25*/
init_param_decl
	: init_param_attribute param_type_spec simple_declarator
	;

/*26*/
init_param_attribute
	: T_IN
	;

/*27*/
const_dcl
	: T_CONST const_type T_IDENTIFIER T_EQUAL const_exp {
      result = Constant.new(val[1], val[2], val[4])
    }
	;

/*28*/
const_type
	: integer_type
	| char_type
	| wide_char_type
	| boolean_type
	| floating_pt_type
	| string_type
	| wide_string_type
	| fixed_pt_const_type
	| scoped_name 
	| octet_type
	;

/*29*/
const_exp
	: or_expr
	;

/*30*/
or_expr
	: xor_expr
	| or_expr T_VERTICAL_LINE xor_expr {
      result = OrExpr.new(val.first, val.last)
    }
	;

/*31*/
xor_expr
	: and_expr
	| xor_expr T_CIRCUMFLEX and_expr {
      result = XorExpr.new(val.first, val.last)
    }
	;

/*32*/
and_expr
	: shift_expr
	| and_expr T_AMPERSAND shift_expr {
      result = AmpersandExpr.new(val.first, val.last)
    }
	;

/*33*/
shift_expr
	: add_expr
	| shift_expr T_SHIFTRIGHT add_expr {
      result = ShiftRightExpr.new(val.first, val.last)
    }
	| shift_expr T_SHIFTLEFT add_expr {
      result = ShiftLeftExpr.new(val.first, val.last)
    }
	;

/*34*/
add_expr
	: mult_expr
	| add_expr T_PLUS_SIGN mult_expr {
      result = PlusExpr.new(val.first, val.last)
    }
	| add_expr T_MINUS_SIGN mult_expr {
      result = MinusExpr.new(val.first, val.last)
    }
	;

/*35*/
mult_expr
	: unary_expr
	| mult_expr T_ASTERISK unary_expr {
      result = MultiplyExpr.new(val.first, val.last)
    }
	| mult_expr T_SOLIDUS unary_expr {
      result = DivideExpr.new(val.first, val.last)
    }
	| mult_expr T_PERCENT_SIGN unary_expr {
      result = ModulusExpr.new(val.first, val.last)
    }
	;

/*36*/
/*37*/
unary_expr
	: T_MINUS_SIGN primary_expr { result = UnaryMinus.new(val[1]) }
	| T_PLUS_SIGN primary_expr { result = UnaryPlus.new(val[1]) }
	| T_TILDE primary_expr { result = UnaryNot.new(val[1]) }
	| primary_expr
	;

/*38*/
primary_expr
	: scoped_name
	| literal
	| T_LEFT_PARANTHESIS const_exp T_RIGHT_PARANTHESIS { result = val[1] }
	;

/*39*/
/*40*/
literal
	: T_INTEGER_LITERAL { result = IntegerLiteral.new(val.first) }
	| T_string_literal { result = StringLiteral.new([val.first]) }
  | T_WIDE_STRING_LITERAL { result = WideStringLiteral.new([val.first]) }
	| T_CHARACTER_LITERAL { result = CharacterLiteral.new(val.first) }
  | T_WIDE_CHARACTER_LITERAL { result = WideCharacterLiteral.new([val.first]) }
	| T_FIXED_PT_LITERAL { raise }
	| T_FLOATING_PT_LITERAL { result = FloatingPointLiteral.new(val.first) }
	| T_TRUE  /*boolean_literal*/ { result = BooleanLiteral.new(true) }
	| T_FALSE /*boolean_literal*/ { result = BooleanLiteral.new(false) }
	;

/*41*/
positive_int_const
	: const_exp
	;

/*42*/
/*43*/
type_dcl
	: T_TYPEDEF type_spec declarators { result = Typedef.new(val[1], val[2]) }
	| struct_type
	| union_type
	| enum_type
	| T_NATIVE simple_declarator
	;

/*44*/
type_spec
	: simple_type_spec
	| constr_type_spec 
	;

/*45*/
simple_type_spec
	: base_type_spec
	| template_type_spec
	| scoped_name
	;

/*46*/
base_type_spec
	: floating_pt_type
	| integer_type
	| char_type
	| wide_char_type
	| boolean_type
	| octet_type
	| any_type
	| object_type
	| value_base_type
	| principal_type  /*New*/
	;

/*47*/
template_type_spec
	: sequence_type
	| string_type
	| wide_string_type
	| fixed_pt_type
	;

/*48*/
constr_type_spec
	: struct_type
	| union_type
	| enum_type
	;

/*49*/
declarators
	: declarator { result = val }
	| declarator T_COMMA declarators { result = [val.first, val.last].flatten }
	;

/*50*/
declarator
	: simple_declarator
	| complex_declarator
	;

/*51*/
simple_declarator
	: T_IDENTIFIER { result = SimpleDeclarator.new(val[0]) }
	;

/*52*/
complex_declarator
	: array_declarator
	;

/*53*/
floating_pt_type
	: T_FLOAT { result = Float.new([]) }
	| T_DOUBLE { result = Double.new([]) }
	| T_LONG T_DOUBLE
	;

/*54*/
integer_type
	: signed_int
	| unsigned_int
	;

/*55*/
signed_int
	: signed_long_int
	| signed_short_int
	| signed_longlong_int
	;

/*56*/
signed_short_int
	: T_SHORT { result = Short.new([]) }
	;

/*57*/
signed_long_int
	: T_LONG { result = Long.new([]) }
	;

/*58*/
signed_longlong_int
	: T_LONG T_LONG { result = LongLong.new }
	;

/*59*/
unsigned_int
	: unsigned_long_int
	| unsigned_short_int
	| unsigned_longlong_int
	;

/*60*/
unsigned_short_int
	: T_UNSIGNED T_SHORT { result = UnsignedShort.new([]) }
	;

/*61*/
unsigned_long_int
	: T_UNSIGNED T_LONG { result = UnsignedLong.new([]) }
	;

/*62*/
unsigned_longlong_int
	: T_UNSIGNED T_LONG T_LONG { result = UnsignedLongLong.new }
	;

/*63*/
char_type
	: T_CHAR { result = Char.new([]) }
	;

/*64*/
wide_char_type
	: T_WCHAR { result = WChar.new }
	;

/*65*/
boolean_type
	: T_BOOLEAN { result = Boolean.new([]) }
	;

/*66*/
octet_type
	: T_OCTET { result = Octet.new([]) }
	;

/*67*/
any_type
	: T_ANY { result = Any.new }
	;

/*68*/
object_type
	: T_OBJECT { result = Object.new }
	;

/*69*/
struct_type
	: T_STRUCT T_IDENTIFIER T_LEFT_CURLY_BRACKET member_list 
      T_RIGHT_CURLY_BRACKET { result = Struct.new(val[1], val[3]) }
	;

/*70*/
member_list
	: member { result = val }
	| member member_list { result = val.flatten }
	;

/*71*/
member
	: type_spec declarators T_SEMICOLON {
      result = Member.new(val[0], val[1])
    }
	;

/*72*/
union_type
	: T_UNION T_IDENTIFIER T_SWITCH T_LEFT_PARANTHESIS
          switch_type_spec T_RIGHT_PARANTHESIS T_LEFT_CURLY_BRACKET
          switch_body T_RIGHT_CURLY_BRACKET {
            result = Union.new(val[1], val[4], val[7])
          }
	; 

/*73*/
switch_type_spec
	: integer_type
	| char_type
	| boolean_type
	| enum_type
	| scoped_name
	;

/*74*/
switch_body
	: case { result = val }
	| case switch_body { result = val.flatten }
	;

/*75*/
case	
	: case_label case
	| case_label element_spec T_SEMICOLON { result = Case.new(val[0], val[1]) }
	| case_label T_PRAGMA element_spec T_SEMICOLON   /* New */
	;

/*76*/
case_label
	: T_CASE const_exp T_COLON { result = CaseLabel.new(val[1]) }
	| T_DEFAULT T_COLON { result = DefaultLabel.new(val[0]) }
	;

/*77*/
element_spec
	: type_spec declarator { result = ElementSpec.new(val) }
	;

/*78*/
enum_type
	: T_ENUM T_IDENTIFIER T_LEFT_CURLY_BRACKET enumerators
      T_RIGHT_CURLY_BRACKET { result = Enum.new(val[1], val[3]) }
	;

enumerators
	: enumerator { result = val }
	| enumerator T_COMMA enumerators { result = [val.first, val.last].flatten }
	;

/*79*/
enumerator
	: T_IDENTIFIER
	;

/*80*/
sequence_type
	: T_SEQUENCE T_LESS_THAN_SIGN simple_type_spec T_COMMA
                        positive_int_const T_GREATER_THAN_SIGN {
      result = Sequence.new([val[2], val[4]])
    }
	| T_SEQUENCE T_LESS_THAN_SIGN simple_type_spec T_GREATER_THAN_SIGN {
      result = Sequence.new([val[2]])
    }
	;

/*81*/
string_type
	: T_STRING T_LESS_THAN_SIGN positive_int_const T_GREATER_THAN_SIGN {
      result = String.new(val[2])
    }
	| T_STRING { result = String.new }
	;

/*82*/
wide_string_type
	: T_WSTRING T_LESS_THAN_SIGN positive_int_const T_GREATER_THAN_SIGN
	| T_WSTRING { result = WString.new }
	;

/*83*/
array_declarator
	: T_IDENTIFIER fixed_array_sizes {
      result = ArrayDeclarator.new(val[0], val[1])
    }
	;

fixed_array_sizes
	: fixed_array_size { result = val }
	| fixed_array_size fixed_array_sizes { result = val.flatten }
	;

/*84*/
fixed_array_size
	: T_LEFT_SQUARE_BRACKET positive_int_const T_RIGHT_SQUARE_BRACKET {
      result = ArraySize.new(val[1])
    }
	;

/*85*/
attr_dcl
	: T_ATTRIBUTE param_type_spec simple_declarators {
      result = Attribute.new(val[1], val[2])
    }
	| T_READONLY T_ATTRIBUTE param_type_spec simple_declarators {
      result = Attribute.new(val[2], val[3], true)
    }
	; 

simple_declarators
	: simple_declarator { result = val }
	| simple_declarator T_COMMA simple_declarators
	;

/*86*/
except_dcl
	: T_EXCEPTION T_IDENTIFIER T_LEFT_CURLY_BRACKET members
      T_RIGHT_CURLY_BRACKET { result = Exception.new(val[1], val[3]) }
	;

members
	: /*empty*/ { result = [] }
	| member members { result = val.flatten }
	;

/*87*/
op_dcl
	: op_attribute op_type_spec T_IDENTIFIER parameter_dcls
      raises_expr context_expr { result = Operation.new(*val) }
	;

/*88*/
op_attribute
	: /*empty*/
	| T_ONEWAY
	;

/*89*/
op_type_spec	
	: param_type_spec
	| T_VOID { result = Void.new([]) }
	;

/*90*/
parameter_dcls
	: T_LEFT_PARANTHESIS param_dcls T_RIGHT_PARANTHESIS { result = val[1] }
	| T_LEFT_PARANTHESIS T_RIGHT_PARANTHESIS { result = [] }
	;

param_dcls
	: param_dcl { result = val }
	| param_dcl T_COMMA param_dcls { result = [val.first, val.last].flatten }
	;

/*91*/
param_dcl
	: param_attribute param_type_spec simple_declarator { result = Parameter.new(*val) }
	;

/*92*/
param_attribute
	: T_IN { result = In.new }
	| T_OUT { result = Out.new }
	| T_INOUT { result = InOut.new }
	;

/*93*/
raises_expr
	: /*empty*/
	| T_RAISES T_LEFT_PARANTHESIS scoped_names T_RIGHT_PARANTHESIS {
      result = val[2]
    }
	;

/*94*/
context_expr
	: /*empty*/
	| T_CONTEXT T_LEFT_PARANTHESIS string_literals T_RIGHT_PARANTHESIS {
      result = Context.new(val[2])
    }
	;

string_literals
	: T_string_literal { result = [StringLiteral.new(val.first)] }
	| T_string_literal T_COMMA string_literals {
      result = [StringLiteral.new(val.first), val.last].flatten
    }
	;

T_string_literal
	: T_STRING_LITERAL { result = val }
	| T_STRING_LITERAL T_string_literal { result = val.flatten }
	;

/*95*/
param_type_spec
	: base_type_spec
	| string_type
	| wide_string_type
	| scoped_name
	;

/*96*/
fixed_pt_type
	: T_FIXED T_LESS_THAN_SIGN positive_int_const T_COMMA
              T_INTEGER_LITERAL T_GREATER_THAN_SIGN
	;

/*97*/
fixed_pt_const_type
	: T_FIXED
	;

/*98*/
value_base_type
	: T_VALUEBASE
	;

/* New production for Principal */
principal_type
	: T_PRINCIPAL
	;

---- inner
  include ZOMG::IDL::Nodes

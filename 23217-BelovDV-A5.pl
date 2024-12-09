:- set_prolog_flag(double_quotes, chars).
:- discontiguous s_expression/2.

% Разделители
delimiter --> ",".
delimiter --> "\s".
delimiter --> "\t".
delimiter --> "\n".

% Для обработки более одного разделителя между выражениями
delimiter_array --> delimiter.
delimiter_array --> delimiter, delimiter_array.

% База специальных символов
special --> "+".
special --> "-".
special --> ">".
special --> "<".
special --> "=".
special --> "*".
special --> "_".

% База цифр, каждая цифра — отдельная ячейка
digit --> "0".
digit --> "1".
digit --> "2".
digit --> "3".
digit --> "4".
digit --> "5".
digit --> "6".
digit --> "7".
digit --> "8".
digit --> "9".

% Число, содержит одну или несколько цифр
number --> digit.
number --> digit, number.

% Любой печатный символ
char --> [A], {char_type(A, print)}.

% Строка без символов `"`
substring --> char.
substring --> char, substring.

% Строка, содержит любые символы
string --> "\"", substring, "\"".

% Идентификатор должен начинаться с буквы
letter --> [A], {char_type(A, alpha)}.

% Идентификатор (id), два варианта: с буквами или со специальными символами
id --> letter, letter_start.
id --> special, special_start.

% Содержит только буквы, цифры и специальные символы
letter_start --> "".
letter_start --> letter, letter_start.
letter_start --> number, letter_start.
letter_start --> special, letter_start.

% Содержит только цифры и специальные символы
special_start --> "".
special_start --> number, special_start.
special_start --> special, special_start.

% Начинается с ":"
keyword --> ":", id.

% Атом, варианты как в условии
atom --> number.
atom --> string.
atom --> id.
atom --> keyword.

% Каждый атом является s-выражением
s_expression --> atom.

% Как в условии, непустой набор выражений в скобках ()
s_expression --> "(", s_expression, expr_array, ")".

% Как в условии, непустой набор выражений в скобках []
s_expression --> "[", s_expression, expr_array, "]".

% Для обработки более одного выражения в скобках
expr_array --> "".
expr_array --> delimiter_array, s_expression, expr_array.

% Пустой набор разрешен
s_expression --> "{", "", "}".

% В множестве четное количество элементов
s_expression --> "{", s_expression, even_expr, "}".

% Только два элемента в множестве
even_expr --> delimiter_array, s_expression.

% Больше двух элементов: 4, 6, 8 и так далее
even_expr --> delimiter_array, s_expression, even.

% Для обеспечения четного числа выражений
even --> s_expression, delimiter_array, s_expression.
even --> delimiter_array, even_or, delimiter_array, even.
even --> delimiter_array, even, delimiter_array, even_or.

even_or --> "".
even_or --> s_expression, delimiter_array, s_expression.

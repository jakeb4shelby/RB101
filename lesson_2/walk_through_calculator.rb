require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

# Method definitions

def welcome_message
  clear_screen
  prompt(messages('welcome'))
end

def clear_screen
  system('clear') || system('cls')
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def get_language
  lang = ' '
  loop do
    lang = gets().chomp()
    break if %w(1 2 3 4).include?(lang)
    prompt(messages('valid_language'))
  end
  lang
end

def language_choice(lang)
  case lang
  when '1'
    lang = 'en'
  when '2'
    lang = 'es'
  when '3'
    lang = 'fr'
  when '4'
    lang = 'it'
  end
  lang
end

def name_prompt(lang)
  prompt(messages('name', lang))
end

def get_name(lang)
  name = " "
  loop do
    name = Kernel.gets().chomp().capitalize()
    break unless name.empty?() || name =~ /\d/
    prompt(messages('valid_name', lang))
  end
  name
end

def valid_number?(num)
  num.to_i().to_s() == num || num.to_f().to_s() == num
end

def get_first_number(lang)
  number1 = " "
  loop do
    prompt(messages('number1', lang))
    number1 = Kernel.gets().chomp()
    break if valid_number?(number1)
    prompt(messages('valid_number', lang))
  end
  number1
end

def get_second_number(lang)
  number2 = " "
  loop do
    prompt(messages('number2', lang))
    number2 = Kernel.gets().chomp()
    break if valid_number?(number2)
    prompt(messages('valid_number', lang))
  end
  number2
end

def get_operator(lang)
  operator = " "
  prompt(messages('operator_prompt', lang))
  loop do
    operator = Kernel.gets().chomp()
    break if %w(1 2 3 4).include?(operator)
    prompt(messages('select_operator', lang))
  end
  operator
end

def operation_to_message(operator, lang)
  case operator
  when '1'
    messages('adding', lang)
  when '2'
    messages('subtracting', lang)
  when '3'
    messages('multiplying', lang)
  when '4'
    messages('dividing', lang)
  end
end

def calculation_message(operator, lang)
  prompt(operation_to_message(operator, lang))
end

def get_result(operator, number1, number2)
  case operator
  when '1'
    number1.to_i() + number2.to_i()
  when '2'
    number1.to_i() - number2.to_i()
  when '3'
    number1.to_i() * number2.to_i()
  when '4'
    number1.to_f() / number2.to_f()
  end
end

def invalid_calculation(lang)
  prompt(messages('zero_division_error', lang))
end

def new_calculation?(lang)
  answer = " "
  loop do
    prompt(messages('perform_calculation', lang))
    answer = Kernel.gets().chomp().downcase()

    break if valid_answer?(answer)
    prompt(messages('invalid_answer', lang))
  end
  answer
end

def divide_zero?(number2, operator)
  number2 == '0' && operator == '4'
end

def integer?(num)
  /^-?\d+$/.match(num)
end

def number?(num)
  integer?(num) || float?(num)
end

def float?(num)
  /\d/.match(num) && /^-?\d*$/.match(num)
end

def valid_answer?(answer)
  ['y', 's', 'o', 'n'].include?(answer)
end

# Start program

welcome_message
lang = language_choice(get_language)

name_prompt(lang)
name = get_name(lang)

puts format(messages('greeting', lang), name: name)

loop do
  number2 = " "
  operator = " "

  number1 = get_first_number(lang)

  loop do
    number2 = get_second_number(lang)
    operator = get_operator(lang)
    break unless divide_zero?(number2, operator)
    invalid_calculation(lang)
  end

  calculation_message(operator, lang)
  result = get_result(operator, number1, number2)
  puts format(messages('result_prompt', lang), result: result)

  answer = new_calculation?(lang)
  break if answer == 'n'
  clear_screen
end

clear_screen
# prompt("Thank you for using calculator. Goodbye!")
puts format(messages('thank_you', lang))

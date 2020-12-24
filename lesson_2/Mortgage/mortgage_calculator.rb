require 'yaml'
MESSAGES = YAML.load_file('mortgage_calc_messages.yml')

# Definitions

def clear_screen
  system('clear') || system('cls')
end

def messages(message)
  MESSAGES[message]
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

# Validation Methods

def valid_number?(num)
  (num.to_i().to_s() == num || num.to_f().to_s() == num) && num.to_f > 0
end

def valid_duration?(num)
  integer?(num) && /^\d+$/.match(num) && num.to_i > 0
end

def zero?(num)
  num.to_f == 0 && (num.to_f.to_s == num || num.to_i.to_s == num)
end

def integer?(num)
  num.to_i().to_s() == num
end

def valid_answer?(answer)
  ['y', 'yes', 'n', 'no'].include?(answer)
end

# Get Methods

def get_loan_amount
  prompt(messages('principal_amount'))

  loan_amount = nil
  loop do
    loan_amount = Kernel.gets().chomp()

    break if valid_number?(loan_amount)
    prompt(messages('invalid_number'))
  end
  loan_amount
end

def get_apr
  prompt(messages('apr'))

  interest_rate = nil
  loop do
    interest_rate = Kernel.gets().chomp()
    break if valid_number?(interest_rate)
    prompt(messages('invalid_apr'))
  end
  interest_rate
end

def get_loan_duration
  prompt(messages('loan_duration'))

  loan_duration = nil
  loop do
    loan_duration = Kernel.gets().chomp()

    break if valid_duration?(loan_duration)
    prompt(messages('invalid_duration'))
  end
  loan_duration
end

def new_calculation?
  answer = " "
  loop do
    prompt(messages('perform_calculation'))
    answer = Kernel.gets().chomp().downcase()

    break if valid_answer?(answer)
    prompt(messages('invalid_answer'))
  end
  answer
end

# Calculation Methods
def monthly_payment(loan_amount, monthly_interest_rate, total_months)
  loan_amount.to_f() * (monthly_interest_rate.to_f() /
  (1 - (1 + monthly_interest_rate.to_f())**(-total_months.to_i())))
end

def display_monthly_payment(payment)
  prompt("Your total monthly payment is $#{payment.round(2)}")
end

# Program Start

clear_screen

puts format(messages('welcome'))

loop do
  loan_amount = get_loan_amount
  interest_rate = get_apr
  loan_duration = get_loan_duration

  annual_interest_rate = interest_rate.to_f() / 100
  monthly_interest_rate = annual_interest_rate.to_f() / 12
  total_months = loan_duration.to_i() * 12
  payment = monthly_payment(loan_amount, monthly_interest_rate, total_months)

  display_monthly_payment(payment)

  answer = new_calculation?
  break if answer == 'n'
  clear_screen
end
clear_screen
puts format(messages('thank_you'))
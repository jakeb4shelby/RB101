# Start

# Get the loan amount
# Get the annual percentage rate (apr)
# Get the loan duration

# Print the monthly interest rate
# Print the loan duration in months
# Print the monthly payment

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

def get_loan_amount
  
  loan_amount = nil
  loop do
    prompt(messages('principal_amount'))
    loan_amount = Kernel.gets().chomp()
    
    if loan_amount.empty?() || loan_amount.to_f() < 0
      prompt(messages('invalid_number'))
    else
      break
    end
  end
  loan_amount
end

def get_apr
  interest_rate = ' '
  loop do
    prompt(messages('apr'))
    interest_rate = Kernel.gets().chomp()
    
    if interest_rate.empty?() || interest_rate.to_f() < 0
      prompt(messages('invalid_number'))
    else
      break
    end
  end
  interest_rate
end

def get_loan_duration
  loan_duration = ' '
   loop do
    prompt(messages('loan_duration'))
    loan_duration = Kernel.gets().chomp()
    
    if loan_duration.empty?() || loan_duration.to_i() < 0
      prompt(messages('invalid_number'))
    else
      break
    end
  end
  loan_duration
end

#def valid_answer?(answer)
#  ['y', 's', 'o', 'n'].include?(answer)
#end

# Program Start

clear_screen

puts format(messages('welcome'))

loan_amount = get_loan_amount
interest_rate = get_apr
loan_duration = get_loan_duration

yearly_interest = get_apr.to_f()/100
monthly_interest= yearly_interest/12
months = get_loan_duration.to_i()*12

monthly_payment = get_loan_amount.to_f()*(monthly_interest/(1-(1+monthly_interest**(-months))))

puts format("Your monthly payment is: $#{format('%.2f', monthly_payment)}")

puts format("Another calculation?")
answer = gets().chomp()

#break unless valid_answer?(answer)

prompt ("Thank you for using the Mortgage Calculator!")
prompt ("Goodbye!")


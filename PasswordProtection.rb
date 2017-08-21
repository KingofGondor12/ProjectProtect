require 'parsel'
require 'twilio-rb'
Twilio::Config.setup \
:account_sid => "ACe25512cbd45623b6685149760e21ef8d",
:auth_token => "9e872a182edb3356c2943bfe78c9644e"

def cls
  system "cls"
end

def encrypt
  $new_encryption = Parsel.encrypt($user_input_key, $user_input_account_password)
  $encryption_hash = {$user_input_account => $new_encryption}
  File.write("accounts.txt", $encryption_hash)
  cls
end
def decrypt
  puts "Enter Account To Decrypt:"
  puts "> "
  $user_input_decrypt_account = $stdin.gets.chomp.capitalize
  @decrypt_file = eval(File.read("accounts.txt"))
  @to_decrypt  = @decrypt_file[$user_input_decrypt_account]
  puts "Enter Decryption Key:"
  $user_input_key = $stdin.gets.chomp
  @un_encrypted = Parsel.decrypt($user_input_key, @to_decrypt)
  puts "Your Account Is: #{$user_input_decrypt_account}"
  puts "Your Account Password Is: #{@un_encrypted}"
end

class PasswordProtect
  def initialize
    puts "Please Enter Account Name:"
    puts "> "
    $user_input_account = $stdin.gets.chomp
    puts "Please Enter Account Password:"
    puts "> "
    $user_input_account_password = $stdin.gets.chomp
    puts "Please Enter Encryption Key:"
    puts "> "
    $user_input_key = $stdin.gets.chomp
    encrypt
  end
end
class Authorised
  def initialize
    puts "Sending Verification Code"
    begin
      Twilio::SMS.create :to => '+61439472066', :from => '+61451562164',
      :body => 'Verification Code - 0435'
    end
    puts "Input Verification Code:\n"
    verification_code = $stdin.gets.chomp.to_s
    if verification_code == "0435"
      $user = parent_start
    else
      puts "Invalid Verification Code"
    end
  end
  def parent_start
    puts "What Would You Like To Do?"
    puts " Option 1 - Encrypt New Account"
    puts " Option 2 - Decrypt Existing Account"
    parent_input = $stdin.gets.chomp.to_i
    if parent_input == 1
      protection = PasswordProtect.new
      encrypt
    elsif parent_input == 2
      decrypt
    else
      puts "Input Not Recognised."
    end
  end
end
class Unknown
  def initialize
    puts "Access Restricted"
    begin
      Twilio::SMS.create :to => '+61439472066', :from => '+61451562164',
      :body => 'ALERT! There is unauthorised access on your accounts.'
    end
  end
end
puts "Enter Identity"
beginning_input = $stdin.gets.chomp.to_s.capitalize
if beginning_input == "Chris"
  $user = Authorised.new
elsif beginning_input == "Travis"
  $user = Authorised.new
elsif beginning_input == "Dog"
  puts "Edison says Woof!"
else
  $user = Unknown.new
end

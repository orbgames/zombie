# allows syntax: create(:user, :first_name => "John", :last_name => "Doe")
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
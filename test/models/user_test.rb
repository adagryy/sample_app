require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Adam", email: "user@example.com", password: "foobar", password_confirmation:"foobar")
  end

  test "should be valid" do
  	assert @user.valid?, "brak nazwy"
  end
  
  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?, "#{@user.name} sdfg" 
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
   end
  end

  test "email should be unique" do
    duplicate_user = @user.dup 
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?    
  end

  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
  
end

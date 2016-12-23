require File.dirname(__FILE__) + "/spec_helper"

describe User do
  it "should validates_presence_of :name, :password" do
    p = User.new
    expect(p).to_not be_valid
    v = User.new(name: "ruin", password: "dood")
    expect(v).to be_valid
  end

  it "should have all necessary fields" do
    p = User.new
    [:name, :password].each do |field|
      expect(p).to respond_to(field)
    end
  end

  ## methods ##
end

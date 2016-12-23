require File.dirname(__FILE__) + "/spec_helper"

require 'digest/md5'

describe "App" do
  def app
    @app ||= Scribl
  end

  before(:each) do
    password = "dood"
    user = create_user_with_password("ruin", password)
    ts = Time.now.to_i.to_s
    token = Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + ts)
    @params = {"p" => "1.2", "u" => "ruin", "t" => ts, "a" => token, "c" => "test"}
  end

  context "handshake" do
    it "should fail on missing params" do
      get "/"
      expect(last_response.status).to eq(400)
    end

    it "should fail on unsupported protocol" do
      params_l = @params
      params_l["p"] = "1.0"
      get "/", params_l
      expect(last_response.status).to eq(400)
    end

    it "should fail on future timestamp" do
      params_l = @params
      params_l["t"] = (Time.now.to_i + 1000).to_s
      get "/", params_l
      expect(last_response.status).to eq(400)
    end

    it "should fail on bad password" do
      ts = Time.now.to_i.to_s
      password = "d00d"
      token = Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + ts)
      params_l = @params
      params_l["a"] = token
      get "/", params_l
      expect(last_response.status).to eq(400)
    end

    it "should authenticate with good credentials" do
      get "/", @params
      expect(last_response.status).to eq(200)
    end

    it "should accept nowplaying" do
      post "/nowplaying"
      expect(last_response.status).to eq(200)
    end
  end

  context "submission" do
    before(:each) do
      get "/", @params
      @session = last_response.body.split("\n")[1]
      @submit_params = {"s" => @session, "a[0]" => "The Delgados", "t[0]" => "Mad Drums", "i[0]" => Time.now.to_i}
    end

    it "should fail on missing parameters" do
      post "/submit"
      expect(last_response.status).to eq(400)
    end

    it "should fail on non-array track parameters" do
      params_l = @submit_params.tap { |hs| hs.delete("a[0]") }
      params_l["a"] = "The Delgados"
      post "/submit", params_l
      expect(last_response.status).to eq(400)
    end

    it "should fail on empty parameters" do
      params_l = @submit_params
      params_l["a[0]"] = ""
      post "/submit", params_l
      expect(last_response.status).to eq(400)
    end

    it "should fail on future timestamp" do
      params_l = @submit_params
      params_l["i"] = (Time.now.to_i + 1000).to_s
      post "/submit", params_l
      expect(last_response.status).to eq(400)
    end

    it "should fail on expired session" do
      Timecop.freeze(Date.today + 2) do
        post "/submit", @params
        expect(last_response.status).to eq(400)
      end
    end
  end
end

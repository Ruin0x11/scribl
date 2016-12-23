def create_user_with_password(username, password)
  hash = Digest::MD5.hexdigest(password)
  User.create(name: username, password: hash)
end

def user_from_session(session)
  Session.where("expires < ?", Time.now.to_i).destroy_all

  return Session.find_by(sessionid: session)
end

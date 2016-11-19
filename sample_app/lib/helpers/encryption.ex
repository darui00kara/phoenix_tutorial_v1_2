defmodule SampleApp.Helpers.Encryption do
  import Comeonin.Bcrypt

  def encrypt(password) do
    hashpwsalt(password)
  end

  def check_password(password, password_digest) do
    checkpw(password, password_digest)
  end
end

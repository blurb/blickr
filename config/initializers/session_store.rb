# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blurbikr_session',
  :secret      => 'cef418acc2775025ee2cfc9724d816a8fbcbab6dfef35c2a2614fba1d40814054915b0e07e03b0220f2bc0fc50900c3dea07c90541ced9f470ae19c24b92515b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

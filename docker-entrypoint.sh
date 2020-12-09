bundle install --without development test
bin/rails db:migrate
bin/rails server -b 0.0.0.0

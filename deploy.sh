export PORT=8000

echo "Deploy to [$DIR]"

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

scp _build/prod/rel/msgr/releases/0.0.1/msgr.tar.gz msgr@jpegdev.win:/home/msgr

# ssh -t msgr@jpegdev.win "PORT=8000 ./msgr/bin/msgr stop; rm -R msgr; mkdir msgr; cd msgr; tar xzvf ../msgr.tar.gz;./bin/msgr migrate; PORT=8000 ./bin/msgr start; rm ../msgr.tar.gz"

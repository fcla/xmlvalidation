XML Validation Service
======================

JAXP + Sinatra on JRuby

As far as i know no libxml based xml library can validate against arbitrary
schema, only 1 specified schema. JAXP has pretty good support for any sort of
XML Schema validation.

start the server
----------------

with jruby installed:
    % bundle exec ruby app.rb

use the service
---------------

open up [http://localhost:4567](http://localhost:4567), choose a file and click *validate*. that's it.

or use curl:
    % curl -Fxml=@instance.xml localhost:4567

all (maybe most) the standard rack stuff applies, you are limited to webrick,
mongrel or one of those java things which I don't know about.

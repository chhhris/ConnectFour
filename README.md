## Running

# download app folder
# from app folder directory, run the following command:

`$ bundle install`
`$ ruby app.rb`

# Must have cookies enabled to play the game.

TODO add gemfile and run `bundle install`

## Notes

# The board and game play are saved in the session as a quick workaround to save the overhead of configuring a datastore. Drawbacks to this approach include [hitting limited memory and disk space limits].
# Further saving the game progress in session is an antipattern that forces the application to be heavily dependent on state -- thus going against RESTful best practices of maintaining application statelessness.
# This workaround is for demo / MVP purposes only and should not be used in any environment [where more than one user is making requests to the server]!



Storing number of columns x rows as environment variables allows configuration without having to redeploy the app.
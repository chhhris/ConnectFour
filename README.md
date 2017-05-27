# CONNECT FOUR
_Using Ruby implement the classic children's game Connect Four™._

## System requirements to play the game.
- Ruby
- [Bundler](http://bundler.io/)
- Your browser must have cookies enabled

## Instructions
- Clone the [repo on Github](https://github.com/chhhris/ConnectFour) or otherwise download the application folder.
- From app folder directory, run the following command:
```
$ bundle install
# install Sinatra gem
```

```
$ ruby app.rb
# spin up app server
```

- View at [http://localhost:4567/](http://localhost:4567/)
- The game can be played as One Player (against the computer) or Two Player.

## Notes / future improvements

#### Computer play
- The computer's playing strategy is fairly naive. Further iterations of the game should add more complexity to the computer's analysis with respect to the optimal next move.

#### Code used to count adjacent checkers
- The various `count_*` methods follow a similar format; I would look to DRY that section up.

#### Saving game data in the session / browser cookie
- This application saves game data in the browser cookie in order to simplify sharing and running this application on a developer's local machine.
- The board and game play are saved in the session as a quick workaround to eliminate the overhead of configuring a datastore.
- However I would like to acknowledge that loading application data into the session is problematic for several reasons, including the ability to tamper with the game results.
- Further, storing the game progress in session is an antipattern that forces the application to be heavily dependent on state, which goes against RESTful best practices of maintaining an application's statelessness.

#### The number of `columns` x `rows` is customizable
- The values are set as environment variables in the `.env` file. The benefit is the ability to customize the size of the grid without having to redeploy the application.

#### Single Player UX
- When playing against the computer, the computer executes its move almost simultaneously with the user's.
- The initial impression is almost that there is a bug because both checkers appear at the same time. An improved UX would visually switch turns with the computer in order to explicitly communicate the computer's move.
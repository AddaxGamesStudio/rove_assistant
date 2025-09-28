# Rove Assistant

*Rove Assistant* is an optional gameplay aid for the board game [Rove](https://boardgamegeek.com/boardgame/365670/rove) hosted in [roveassistant.com](https://roveassistant.com). If leveraged fully, the app serves the function of the Codex and Campaign books during gameplay. It can also do away with physical tracking of health, defense, reactions, tokens, phases, rounds, the campaign sheet, the world map, and even lyst and items for those who prefer it.

You don’t have to use all the features of Rove Assistant. It is designed to adapt to your play style and allows you to bypass or ignore what you don’t want to track digitally.

## Building

Usage: `./scripts/rove_build.sh [flutter build subcommand and arguments]`

Example: `./scripts/rove_build.sh macos`

## Project Structure

* `rove_data`: Contains campaign data and assets.
* `rove_data_types`: A Dart package defining data types to build any Rove application.
* `rove_assistant`: The Rove Assistant Flutter application.
* `rove_assistant/live/data`: Contains in-depth data about all quests/encounters. These will be eventually be moved to `rove_data` as JSON files, but are currently typed Dart files for ease of development.

## Contributing

For user feedback, please join the [Rove Discord server](https://discord.com/invite/cQGAeY36GV) and use the `#rove-assistant` channel.

For development matters, feel free to file a new issue for bugs, features, and improvements, or start a new new discussion for help or feedback.

Pull requests are also welcome!

# Copyright / License
Rove and all related properties, images and text are © Addax Games. All Rights Reserved. You can use these assets to use or contribute to the Rove Assistant application. No other individual, entity, or corporation is permitted to use and/or re-use the assets within this repository for any other purpose.

Source code is licensed under GNU General Public License v3.
# Standupbot

Have you ever done a standup in hipchat and then wanted a summary that wasn't scrolling by quickly? Well this is the utility for you.

# How it works

After you set some configuration information via the environment, you run the tool. It looks for #standup in your channel on that day and displays the output or optionally emails it to somebody.

# Configuration Options:


    HIPCHAT_ROOM      # Name of the room to scour
    HIPCHAT_API_TOKEN # your api key for hipchat (v1 api)"
    ENABLE_EMAIL      # by default no email is sent, just stdout."
    EMAIL_TARGET      # who you send the email to? "
    EMAIL_FROM        # who sends the standup email?" - this should be valid email address, or else it won't always go through.

# Usage

    export HIPCHAT_API_TOKEN=blahblahblahblah
    bundle install --path gems
    bundle exec ./standup-bot.rb

# Bugs
There are probably bugs, fix them. Patches accepted.

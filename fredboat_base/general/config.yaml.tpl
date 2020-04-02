apiVersion: v1
kind: ConfigMap
metadata:
  name: fredboat-configmap
  labels:
    app: fredboat
data:
  quarterdeck.yml: |
    security:
      admins:
      # Do not leave any of them blank or empty.
      - name: "{{ QUARTERDECK_USERNAME }}"
        pass: "{{ QUARTERDECK_PASSWORD }}"
    whitelist:
      # a list of discord user ids that shall never be ratelimited or blacklisted
      userIds:
        {% for id in QUARTERDECK_WHITELIST_IDS %}
        - {{ id }}
        {% endfor %}
    spring:
      main:
        banner-mode: log
      output:
        ansi:
          # for developers: setting this to "always" will force colored logs in your console
          enabled: detect
    server:
      # port of the backend
      port: {{ QUARTERDECK_PORT }}
    sentry:
      dsn: "{{ SENTRY_DSN }}"
    # If you are using docker to host the whole FredBoat, you can ignore all database settings below this line.
    database:
      main:
        # FredBoat was written to work with PostgreSQL.
        # FredBoat was written to work with PostgreSQL.
        # If you are running with docker-compose then you don't need to change the jdbcUrl here.
        # In PostgreSQL, role means user and vice versa. Keep that in mind when reading the following help and the provided links.
        # If you are running your own PostgreSQL database, you will need to provide a role and a database belonging to that role.
        # The role needs at least the permission to log in.
        # All postgres databases used by FredBoat are required to have the Hstore extension enabled.
        # Learn more about roles here: https://www.postgresql.org/docs/10/static/database-roles.html
        # Learn more about creating databases here: https://www.postgresql.org/docs/10/static/manage-ag-createdb.html
        # Learn more about the postgres jdbc url here: https://jdbc.postgresql.org/documentation/head/connect.html
        # Learn more about creating extensions here: https://www.postgresql.org/docs/current/static/sql-createextension.html
        # Example jdbc: "jdbc:postgresql://localhost:5432/fredboat?user=fredboat&password=youshallnotpass"
        jdbcUrl: "jdbc:postgresql://fredboat-postgres-service:{{ POSTGRES_PORT }}/fredboat?user={{ POSTGRES_USER }}&password={{ POSTGRES_PASSWORD }}"
      cache:
        # Database for caching things, see config of main database above for details about the individual values.
        # If you are running with docker-compose then you don't need to change the cache jdbcUrl here.
        # The main and cache databases can be two databases inside a single postgres instance.
        # They CANNOT be the same database due to the way flyway migrations work.
        # The main benefit is that you don't have to backup/migrate the cache database, it can just be dropped/recreated
        # If you do not provide a jdbc url for the cache database, FredBoat will still work (most likely), but may have a degraded
        # performance, especially in high usage environments and when using Spotify playlists.
        jdbcUrl: "jdbc:postgresql://fredboat-postgres-service:{{ POSTGRES_PORT }}/fredboat_cache?user={{ POSTGRES_USER }}&password={{ POSTGRES_PASSWORD }}"
    # tune these according to your needs, or just leave them as is.
    logging:
      file:
        max-history: 30
        max-size: 1GB
      path: ./logs/
      level:
        root: INFO
        fredboat: DEBUG
        com.fredboat: DEBUG
    docs:
      # Open the documentation endpoints for the public, and disable certain security features.
      open: false
      # DO NOT OPEN these on a production system.
      # Reference: https://swagger.io/docs/specification/2-0/api-host-and-base-path/
      host: ""
      # Tell swagger where to find this Quarterdeck for Try out queries
      basePath: ""

  application.yml: |
    server:
      # REST server
      port: {{ LAVALINK_PORT }}
      address: 0.0.0.0
    spring:
      main:
        banner-mode: log
    lavalink:
      server:
        password: "{{ LAVALINK_PASSWORD }}"
        sources:
          youtube: true
          bandcamp: true
          soundcloud: true
          twitch: true
          vimeo: true
          mixer: true
          http: true
          local: false
        bufferDurationMs: 400
        youtubePlaylistLoadLimit: 600
        gc-warnings: true
    metrics:
      prometheus:
        enabled: true
        endpoint: /metrics
    sentry:
      dsn: "{{ SENTRY_DSN }}"
    #  tags:
    #    some_key: some_value
    #    another_key: another_value
    logging:
      file:
        max-history: 30
        max-size: 1GB
      path: ./logs/
      level:
        root: INFO
        lavalink: INFO

  common.yml: |
    discordToken: "{{ DISCORD_TOKEN }}"

  fredboat.yml: |
    config:
      development:       false        # Set this to false for selfhosting. If you leave this enabled and complain about weird
                                      # things happening to your bot in the selfhosting chat you will be publicly taunted.
      prefix:            '{{ FREDBOAT_PREFIX }}'         # Default prefix used by the bot
      botAdmins:         []           # Add comma separated userIds and roleIds that should have access to bot admin commands. Find role ids with the ;;roleinfo command
      botOwners:         []           # Add comma separated userIds that should have access to bot OWNER commands. Mainly intended for bots that belong to teams
      autoBlacklist:     true         # Set to true to automatically blacklist users who frequently hit the rate limits
      game:              ""           # Set the displayed game/status. Leave empty quote marks for the default status
      continuePlayback:  false        # Set to true to force the player to continue playback even if left alone
      shardCount: 1                   # The number of shards this bot supports. Leave at 1 unless you know what you are doing.
    # ratelimit:
    #   ipBlocks: ["127.0.0.1/31", "127.0.0.3/32", "..."] # list of ip blocks
    #   excludedIps: ["...", "..."] # ips which should be explicit excluded from usage by lavalink
    #   strategy: "RotateOnBan" # RotateOnBan | LoadBalance | NanoSwitch | RotatingNanoSwitch
    #   searchTriggersFail: true # Whether a search 429 should trigger marking the ip as failing
    server:
      # Change the port of the API FredBoat exposes
      port: {{ FREDBOAT_PORT }}
    spring:
      main:
        # Set this to "servlet", "reactive" or "none", whichever ends up working, to enable/disable the FredBoat API.
        web-application-type: none
      output:
        ansi:
          # for developers: setting this to "always" will force colored logs in your console
          enabled: detect
    audio-sources:
      enableYouTube:     true         # Set to true to enable playing YouTube links
      enableSoundCloud:  true         # Set to true to enable playing SoundCloud links
      enableBandCamp:    true         # Set to true to enable playing BandCamp links
      enableTwitch:      true         # Set to true to enable playing Twitch links
      enableVimeo:       true         # Set to true to enable playing Vimeo links
      enableMixer:       true         # Set to true to enable playing Mixer links
      enableSpotify:     true         # Set to true to enable playing Spotify links
      enableLocal:       false        # Set to true to enable playing local files
      enableHttp:        true         # Set to true to enable playing direct links
    ################################################################
    ###                 Essential credentials
    ################################################################
    backend:
      quarterdeck:
        # Host address of your quarterdeck backend, including port unless you are using a reverse proxy.
        host: "http://fredboat-quarterdeck-service:{{ QUARTERDECK_PORT }}/"
        # Credentials used to authenticate to with Quarterdeck.
        user: "{{ QUARTERDECK_USERNAME }}"
        pass: "{{ QUARTERDECK_PASSWORD }}"
    credentials:
      # Used by the ;;split and ;;np commands. Must be hooked up to the Youtube Data API.
      # You can add additional keys in case you are running a big bot
      # How to get the key: https://developers.google.com/youtube/registering_an_application
      # Add your google API key between the quotation marks
      googleApiKeys:
        - "{{ GOOGLE_YOUTUBE_API_KEY }}"
      # The preferred way of setting the token is described in ./common.yml
      #discordBotToken: ""
      ################################################################
      ###                     Optional APIs
      ################################################################
      # Used to access imgur galleries for some RandomImageCommands
      # Acquired from here: https://api.imgur.com/oauth2/addclient
      # Choose an option that does not require an Authorization callback URL
      imgurClientId:  ""
      # Used to retrieve Spotify playlists
      # Get them from here: https://developer.spotify.com/my-applications
      spotifyId:      "{{ SPOTIFY_ID }}"
      spotifySecret:  "{{ SPOTIFY_SECRET }}"
      # Used by ;;weather command.
      # Get them from: http://openweathermap.org/appid
      openWeatherKey: "{{ OPENWEATHER_KEY }}"
      # Error aggregation service https://sentry.io/
      sentryDsn:      "{{ SENTRY_DSN }}"
    event-logger:
      # Webhooks to Discord channels that will post some guild stats and shard status changes
      # More information on webhooks: https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
      # Example: "https://canary.discordapp.com/api/webhooks/1234567890/QWERTZUIOPasdfghjklYXCVBNM" (no, this one will not work)
      eventLogWebhook:            "" # webhook url for connect / disconnect events
      eventLogInterval:           1  # interval at which connect / disconnect events are posted in minutes
      guildStatsWebhook:          "" # webhook url for guild stats
      guildStatsInterval:         60 # interval at which guild stats are posted in minutes
    # Lavalink is used for playing music.
    # More on Lavalink: https://github.com/Frederikam/Lavalink
    lavalink:
      nodes:
        - name : "local"
          host : "ws://fredboat-lavalink-service:{{ LAVALINK_PORT }}"
          pass : "{{ LAVALINK_PASSWORD }}"
    # tune these according to your needs, or just leave them as is.
    logging:
      file:
        max-history: 30
        max-size: 1GB
      path: ./logs/
      level:
        root: INFO
        fredboat: DEBUG
        com.fredboat: DEBUG
        net.dv8tion: DEBUG

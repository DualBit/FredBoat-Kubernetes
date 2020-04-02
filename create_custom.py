#!/usr/bin/env python3

import argparse
import os
import shutil
from pathlib import Path

from jinja2 import Template

from constants import DST_DIR_PREFIX, TEMPLATE_DIR


def main():
    parser = argparse.ArgumentParser()

    # Remaining letters: b, f, g, h, l, m

    # Main
    parser.add_argument('-n', '--name', action='store', dest='instance_name', required=True, help='Instance Name')
    # General
    parser.add_argument('-d', '--sentry-dsn', action='store', dest='sentry_dsn', required=False,
                        help='Sentry DSN, old format "http://user:pass@sentry/id"', default='', type=str)
    # Postgres
    parser.add_argument('-s', '--postgres-user', action='store', dest='psql_user', required=False,
                        help='Postgres Username', default='fredboat', type=str)
    parser.add_argument('-a', '--postgres-password', action='store', dest='psql_pass', required=False,
                        help='Postgres Password', default='fredboatpassword', type=str)
    parser.add_argument('-r', '--postgres-port', action='store', dest='psql_port', required=False,
                        help='Postgres Port', default=5432, type=int)
    # Quarterdeck
    parser.add_argument('-u', '--quarterdeck-username', action='store', dest='qd_user', required=False,
                        help='Quarterdeck Username', default='quarterdeck', type=str)
    parser.add_argument('-p', '--quarterdeck-password', action='store', dest='qd_pass', required=False,
                        help='Quarterdeck Password', default='fredboatquarterdeck', type=str)
    parser.add_argument('-i', '--quarterdeck-ids', action='store', dest='qd_ids', required=False,
                        help='Quarterdeck Whitelist User IDs, comma separated', default='', type=str)
    parser.add_argument('-o', '--quarterdeck-port', action='store', dest='qd_port', required=False,
                        help='Quarterdeck Port', default=4269, type=int)
    # Lavalink
    parser.add_argument('-w', '--lavalink-password', action='store', dest='ll_pass', required=False,
                        help='Lavalink Password', default='fredboatlavalink', type=str)
    parser.add_argument('-t', '--lavalink-port', action='store', dest='ll_port', required=False,
                        help='Lavalink Port', default=2333, type=int)
    # Discord
    parser.add_argument('-k', '--discord-token', action='store', dest='discord_token', required=True,
                        help='Discord Token', type=str)
    # FredBoat
    parser.add_argument('-x', '--fredboat-prefix', action='store', dest='fredboat_prefix', required=False,
                        help='FredBoat Prefix', default='<<', type=str)
    parser.add_argument('-j', '--fredboat-port', action='store', dest='fredboat_port', required=False,
                        help='FredBoat Port', default=1356, type=int)
    parser.add_argument('-y', '--youtube-api', action='store', dest='youtube_api', required=True,
                        help='Google YouTube API', type=str)
    parser.add_argument('-c', '--spotify-id', action='store', dest='spotify_id', required=False,
                        help='Spotify App ID', default='', type=str)
    parser.add_argument('-e', '--spotify-secret', action='store', dest='spotify_secret', required=False,
                        help='Spotify App Secret', default='', type=str)
    parser.add_argument('-q', '--openweather-key', action='store', dest='openweather_key', required=False,
                        help='OpenWeather Key', default='', type=str)
    # Generate single file
    parser.add_argument('-z', '--generate-full', action='store', dest='generate_full', required=False,
                        help='Generate full.yaml from *.yaml files', default='', type=str)
    # Parse arguments
    args = parser.parse_args()

    # Set context for template
    qd_ids = args.qd_ids.split(',') if args.qd_ids != '' else []
    template_context = {
            # General
            'SENTRY_DSN': args.sentry_dsn,
            # Postgres
            'POSTGRES_USER': args.psql_user,
            'POSTGRES_PASSWORD': args.psql_pass,
            'POSTGRES_PORT': args.psql_port,
            # Quarterdeck
            'QUARTERDECK_USERNAME': args.qd_user,
            'QUARTERDECK_PASSWORD': args.qd_pass,
            'QUARTERDECK_WHITELIST_IDS': qd_ids,
            'QUARTERDECK_PORT': args.qd_port,
            # Lavalink
            'LAVALINK_PASSWORD': args.ll_pass,
            'LAVALINK_PORT': args.ll_port,
            # Discord
            'DISCORD_TOKEN': args.discord_token,
            # FredBoat
            'FREDBOAT_PREFIX': args.fredboat_prefix,
            'FREDBOAT_PORT': args.fredboat_port,
            'GOOGLE_YOUTUBE_API_KEY': args.youtube_api,
            'SPOTIFY_ID': args.spotify_id,
            'SPOTIFY_SECRET': args.spotify_secret,
            'OPENWEATHER_KEY': args.openweather_key,
        }

    # Destination folder
    dst_dir = DST_DIR_PREFIX + args.instance_name

    # Copy template folder
    shutil.rmtree(dst_dir, ignore_errors=True)
    shutil.copytree(TEMPLATE_DIR, dst_dir)

    # Render templates
    for path in Path(dst_dir).rglob('*.tpl'):
        render_template(path, template_context)

    # Create single Yaml file
    with open(os.path.join(dst_dir, 'full.yaml'), 'w') as k8s_file:
        for path in Path(dst_dir).rglob('*/*.yaml'):
            k8s_file.write(open(str(path), 'r').read())
            k8s_file.write('\n---\n')
        k8s_file.flush()
        k8s_file.close()


# Render template and save to file
def render_template(template_file, template_context):
    dst_file = str(template_file).replace('.tpl', '')
    with open(dst_file, 'w') as config_file:
        config_tpl = Template(open(template_file).read())
        config_tpl = config_tpl.render(template_context)
        config_file.write(config_tpl)
        config_file.flush()
        config_file.close()
    os.remove(template_file)


# Main
if __name__ == "__main__":
    main()

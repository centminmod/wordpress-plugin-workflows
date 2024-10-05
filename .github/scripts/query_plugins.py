#!/usr/bin/env python3
import requests
import argparse
import json

def fetch_plugins_by_page(page, per_page=100):
    url = 'https://api.wordpress.org/plugins/info/1.2/'
    params = {
        'action': 'query_plugins',
        'request[browse]': 'popular',
        'request[page]': page,
        'request[per_page]': per_page
    }
    response = requests.get(url, params=params)
    return response.json().get('plugins', [])

def fetch_top_plugins(pages=10, per_page=100):
    all_plugins = []
    seen_slugs = set()
    for page in range(1, pages + 1):
        plugins = fetch_plugins_by_page(page, per_page)
        for plugin in plugins:
            if plugin['slug'] not in seen_slugs:
                all_plugins.append(plugin)
                seen_slugs.add(plugin['slug'])
    
    sorted_plugins = sorted(all_plugins, key=lambda x: x['downloaded'], reverse=True)
    top_plugins = [
        {
            'name': plugin['name'],
            'slug': plugin['slug'],
            'version': plugin['version'],
            'tested': plugin['tested'],
            'downloaded': plugin['downloaded'],
            'download_link': plugin['download_link']
        }
        for plugin in sorted_plugins
    ]
    return top_plugins

def main():
    parser = argparse.ArgumentParser(description='Fetch top WordPress plugins.')
    parser.add_argument('-pages', type=int, default=10, help='Number of pages to fetch')
    parser.add_argument('-perpage', type=int, default=100, help='Number of plugins per page')
    args = parser.parse_args()
    top_plugins = fetch_top_plugins(pages=args.pages, per_page=args.perpage)
    print(json.dumps(top_plugins, indent=4))

if __name__ == "__main__":
    main()
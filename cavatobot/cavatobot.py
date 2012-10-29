#!/usr/bin/env python3

from pypeul import IRC, Tags
import random
import requests
import yaml
import threading
import time
import logging
import json

def load_conf():
    return yaml.load(open('conf.yml'))

CONF = load_conf() 

def rdc(msg):
    return random.choice(CONF['msg'][msg])

def shortenurl(url):
    url = 'http://ln-s.net/home/api.jsp?url={}'.format(url)
    r = requests.get(url).text
    return r.split()[1]

def paste(text, hl='', ln=False, raw=False, comment='', user=''):
    data = {
                'paste': text,
                'hl': hl,
                'user': user,
                'comment': comment,
                'ln': bool_switch(ln),
                'raw': bool_switch(raw),
           }

    url = 'http://paste.awesom.eu/'
    data = urllib.parse.urlencode(data).encode('utf-8')
    r = urllib.request.urlopen(urllib.request.Request(url, data))
    return r.url

class Checker():
    def __init__(self, bot):
        self.bot = bot

    def get_last_commits(self, user, repo):
        url = 'https://api.bitbucket.org/1.0/repositories/{}/{}/changesets'
        url = url.format(user, repo)
        js = requests.get(url).text
        return json.loads(js)
    
    def run(self):
        if not self.bot.ready:
            return
        for repo in CONF['repos']:
            r = CONF['repos'][repo]
            self.check_last(repo, r['user'], r['repo'], r['channel'])

    def check_last(self, rid, user, repo, channel):
        try:
            last_commits = self.get_last_commits(user, repo)
        except:
            return
        nb_commits = last_commits['limit']
        lc = last_commits['changesets'][nb_commits - 1]
        if not rid in self.bot.last_commits:
            self.bot.last_commits[rid] = lc
            return
        if lc['node'] == self.bot.last_commits[rid]['node']:
            return
        self.bot.last_commits[rid] = lc
        url = 'https://bitbucket.org/{}/{}/changeset/{}'.format(
                user, repo, lc['raw_node'])
        params = {
            'node': Tags.Red(lc['node']),
            'author': Tags.Green(lc['author']),
            'branch': Tags.Blue(lc['branch']),
            'message': lc['message'].strip(),
            'url': shortenurl(url),
        }
        self.bot.message(channel, rdc('commit').format(**params))

class PeriodicalCall(threading.Thread):
    def __init__(self, delay, cls):
        super(PeriodicalCall, self).__init__()

        self._delay = delay
        self._cls = cls
        self.running = True

    def run(self):
        while self.running:
            self._cls.run()
            time.sleep(self._delay)

class Bot(IRC):
    def __init__(self):
        IRC.__init__(self)
        self.last_commits = {}
        self.ready = False

    def on_ready(self):
        for repo in CONF['repos']:
            r = CONF['repos'][repo]
            print(r)
            self.join(r['channel'], r['channel_key'])
            self.message(r['channel'], rdc('hello'))
        self.ready = True

    def on_channel_message(self, umask, channel, msg):
        msg = Tags.strip(msg)
        if msg[0] == '!':
            splitted = msg.split()
            command = splitted[0]
            args = splitted[1:]
 
if __name__ == '__main__':
    logging.basicConfig(level=logging.WARNING)
    
    bot = Bot()
    bot.connect(CONF['irc']['host'], CONF['irc']['port'])
    bot.ident(CONF['irc']['nick'])

    checker = Checker(bot)
    call = PeriodicalCall(CONF['bitbucket']['checkdelay'], checker)
    call.daemon = True
    call.start()
   
    bot.run()

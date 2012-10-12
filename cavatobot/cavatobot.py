#!/usr/bin/env python3

from pypeul import IRC, Tags
import random
import requests
import yaml
import threading
import time
import logging

def load_conf():
    return yaml.load(codecs.open('conf.yml', 'r', 'utf-8'))

CONF = load_conf() 

def rdc(msg):
    return random.choice(CONF['msg'][msg])

def shortenurl(url):
    url = 'http://ln-s.net/home/api.jsp?url=' + urllib.parse.quote(url)
    r = urllib.request.urlopen(url).read().decode('utf-8')
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
    
 def get_last_commits():
    url = 'https://api.bitbucket.org/1.0/repositories/{}/{}/changesets'
    url = url.format(CONF['bitbucket']['user'], CONF['bitbucket']['repo'])
    js = requests.get(url).text
    return json.loads(js)

   def run(self):
       lc = get_last_commits[0]
       if lc['node'] == self.bot.last_commit['node']:
           return
       self.bot.last_commit = lc
       self.bot.message(rdc('commit').format(node, author, branch, message))


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
        self.channel = CONF['irc']['channel']
        self.channel_key = CONF['irc']['key']
        self.last_commit = None
        self.lastposts = {}

    def on_ready(self):
        self.join(self.channel, self.channel_key)
        self.message(self.channel, rdc('hello'))
        self.ready = True
        self.last

    def on_channel_message(self, umask, channel, msg):
        msg = Tags.strip(msg)
        if channel != self.channel:
            return
        if msg[0] == '!':
            splitted = msg.split()
            command = splitted[0]
            args = splitted[1:]
 
if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    
    bot = Bot()
    bot.connect(CONF['irc']['host'], CONF['irc']['port'])
    bot.ident(CONF['irc']['nick'])

    checker = Checker(bot)
    call = PeriodicalCall(CONF['bitbucket']['checkdelay'], checker)
    call.daemon = True
    call.start()
   
    bot.run()

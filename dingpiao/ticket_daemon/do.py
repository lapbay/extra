#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os, time
from lib.lib_gmail import Gamil
from lib.lib_daemon import Daemon
from lib.log import logger
from jobs import *

class alert_daemon(Daemon):
	def _run(self):
		if self.path:
			os.chdir(self.path)
		while True:
			self.do()
			time.sleep(5)

	def do(self):
		#gmail=Gamil('wuchang@umeng.com', 'password' )
		#gmail.send("wcmilan@gmail.com" ,"MONI Alert" ,"%s missing"%vmid)
		do()
		logger.debug('doing')
	
if __name__=='__main__':
	daemon = alert_daemon('/tmp/do_daemon.pid')
	daemon.path=os.getcwd()
	#sys.exit(0)
	if len(sys.argv) == 2:
		if 'start' == sys.argv[1]:
			daemon.start()
		elif 'stop' == sys.argv[1]:
			daemon.stop()
		elif 'restart' == sys.argv[1]:
			daemon.restart()
		else:
			print "Unknown command"
			sys.exit(2)
		sys.exit(0)
	else:
		print "usage: %s start|stop|restart" % sys.argv[0]
		sys.exit(2)

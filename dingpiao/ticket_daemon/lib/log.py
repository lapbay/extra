#!/usr/bin/python
# -*- coding: utf-8 -*-
#Copyright 2011, Wu Chang

import httplib
import mimetypes
import json
import logging

logging.basicConfig( 
	level = logging.DEBUG,
	format = '%(asctime)s %(levelname)s %(module)s.%(funcName)s Line:%(lineno)d %(message)s', 
	filename = '/tmp/do_daemon.log',
)  
logger = logging.getLogger(__name__)

	
if __name__=='__main__':
	pass


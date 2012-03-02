#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os, hashlib, time, json
from lib.log import logger

import redis
from pyres import ResQ
from pyres import failure
from base64 import b64decode

from APNSWrapper import *
import binascii

def print_log(log):
	logger.debug(log + '\n')

def do():
	jobs=Jobs()
	jobs.send()

class Jobs(object): 
	def __init__(self,host='localhost',port=6379):
		HOST = 'localhost:6379'
		self.host=host
		self.port=port
		self.queue='iOSPush'
		self.resq = ResQ('%s:%i'%(self.host,self.port))

	def push(self,queue,item):
		self.resq.push(queue,item)

	def pop(self,queue):
		return self.resq.pop(queue)

	def add(self):
		pass
	
	def send(self):
		info=self.pop(self.queue) #will get (None, None) if none
		info={'badge':1,'msg':'您有新的车票信息','token':'cb86b176ee99ae5f3387c79f1226d234599e91c7bc300e97afb034cc0009e192'}
		deviceToken = binascii.unhexlify(info['token'])
		message = APNSNotification()
		message.token(deviceToken)
		message.alert(info['msg'])
		message.badge(info['badge'])
		message.sound()
		wrapper = APNSNotificationWrapper('ck.pem', True)
		wrapper.append(message)
		wrapper.notify()

if __name__=='__main__':
	do()

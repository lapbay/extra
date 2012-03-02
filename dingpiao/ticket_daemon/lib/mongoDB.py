#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os, time, json
import pymongo

connect = pymongo.Connection('127.0.0.1', 27017)
meifanr = connect.meifanr				# new a database
#meifanr.add_user('test','test')		# add a user
#meifanr.authenticate('test','test')	# check auth
counterC = meifanr.counter			# new a table
#collection.save({'id':1, 'name':'test'})	# add a record
#collection.insert({'id':2, 'name':'hello'})	# add a record
print counterC.find_one({'topic.a':11,'type':'user'})			# find a record
#collection.find_one({'id':2})		# find a record by condition
#collection.create_index('id')
#collection.find().sort('id',pymongo.ASCENDING)	# DESCENDING
#collection.drop()				# delete table
#collection.find({'id':1}).count()		# get records number
#collection.find({'id':1}).limit(3).skip(2)	# start index is 2 limit 3 records
#collection.remove({'id':1})			# delete records where id = 1
#collection.update({'id':2},{'$set':{'name':'haha'}})	# update one record
#collection.find_one({'id':2})

conn = pymongo.Connection('127.0.0.1', 27017)
db = conn['meifanr']
counterC = db['counter']
userC = db['user']
blogC = db['blog']
opQueueC = db['opQueue']
#meifanr.add_user('test','test') # add a user
#meifanr.authenticate('test','test') # check auth
#collection.save({'id':1, 'name':'test'})	# add a record
#collection.insert({'id':2, 'name':'hello'})	# add a record
#print counterC.find_one({'topic.a':11,'type':'user'})			# find a record
#collection.find_one({'id':2})		# find a record by condition
#collection.create_index('id')
#collection.find().sort('id',pymongo.ASCENDING)	# DESCENDING
#collection.drop()				# delete table
#collection.find({'id':1}).count()		# get records number
#collection.find({'id':1}).limit(3).skip(2)	# start index is 2 limit 3 records
#collection.remove({'id':1})			# delete records where id = 1
#collection.update({'id':2},{'$set':{'name':'haha'}})	# update one record
#collection.find_one({'id':2})

class Mongo(object):
	def __init__(db='meifanr',server='127.0.0.1',port=27017):
		self.connect = pymongo.Connection(server,port)

	def find():
		db = self.connect['meifanr']
		counterC=db['counter']
		print counterC.find_one({'topic.a':11,'type':'user'})

if __name__=='__main__':
	mongo=Mongo()
	
